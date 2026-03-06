#!/usr/bin/env python3
import random
import time
from pathlib import Path

import pygame

# =============================
# Configuration générale
# =============================
WIDTH, HEIGHT = 800, 600
FPS = 60

FORCE_FULLSCREEN = False

PLAYER_W, PLAYER_H = 60, 22
PLAYER_SPEED = 430

BLOCK_W, BLOCK_H = 42, 42
BLOCK_BASE_SPEED = 180
BLOCK_SPEED_BONUS = 120
BLOCK_MAX_SPEED = 420

SPAWN_START = 1.0
SPAWN_MAX = 4.0
RAMP_DURATION = 75.0
MAX_BLOCKS = 24

JOY_BUTTON_A = 0

ENABLE_MUSIC = True
MUSIC_FILE = "assets/music.ogg"
MUSIC_VOLUME = 0.30

# =============================
# Couleurs
# =============================
BG = (8, 10, 20)
GRID = (18, 22, 36)
WHITE = (240, 240, 240)
GRAY = (170, 170, 170)

RED = (255, 90, 90)
RED_BORDER = (255, 140, 140)

PLAYER_COLORS = [
    ("Blue",   (0, 200, 255)),
    ("Green",  (0, 220, 120)),
    ("Yellow", (255, 210, 60)),
    ("Pink",   (255, 100, 180)),
    ("White",  (230, 230, 230)),
]

STATE_START = "start"
STATE_PLAYING = "playing"
STATE_GAMEOVER = "gameover"


# =============================
# Outils
# =============================
def clamp(value, minimum, maximum):
    return max(minimum, min(value, maximum))


def draw_center_text(screen, font, text, y, color=WHITE):
    surf = font.render(text, True, color)
    rect = surf.get_rect(center=(WIDTH // 2, y))
    screen.blit(surf, rect)


def draw_grid(screen):
    for x in range(0, WIDTH, 40):
        pygame.draw.line(screen, GRID, (x, 0), (x, HEIGHT), 1)
    for y in range(0, HEIGHT, 40):
        pygame.draw.line(screen, GRID, (0, y), (WIDTH, y), 1)


# =============================
# Classes du jeu
# =============================
class Player:
    def __init__(self, color):
        self.rect = pygame.Rect((WIDTH - PLAYER_W) // 2, HEIGHT - 80, PLAYER_W, PLAYER_H)
        self.last_dir = 0
        self.color = color

    def update(self, dt, move_dir):
        self.last_dir = move_dir
        self.rect.x += int(move_dir * PLAYER_SPEED * dt)
        self.rect.x = clamp(self.rect.x, 0, WIDTH - self.rect.w)

    def draw(self, screen):
        shadow = self.rect.move(3, 3)
        pygame.draw.rect(screen, (0, 60, 90), shadow, border_radius=6)
        pygame.draw.rect(screen, self.color, self.rect, border_radius=6)
        pygame.draw.rect(screen, WHITE, self.rect, 2, border_radius=6)


class Block:
    def __init__(self, speed_bonus=0):
        x = random.randint(0, WIDTH - BLOCK_W)
        self.rect = pygame.Rect(x, -BLOCK_H, BLOCK_W, BLOCK_H)
        self.speed = random.randint(BLOCK_BASE_SPEED, BLOCK_BASE_SPEED + BLOCK_SPEED_BONUS) + speed_bonus
        self.speed = min(self.speed, BLOCK_MAX_SPEED)

    def update(self, dt):
        self.rect.y += int(self.speed * dt)

    def draw(self, screen):
        shadow = self.rect.move(3, 3)
        pygame.draw.rect(screen, (120, 30, 30), shadow, border_radius=6)
        pygame.draw.rect(screen, RED, self.rect, border_radius=6)
        pygame.draw.rect(screen, RED_BORDER, self.rect, 2, border_radius=6)


class Input:
    def __init__(self):
        self.joy = None
        self.a_pressed = False
        self.left_pressed = False
        self.right_pressed = False
        self.move_dir = 0
        self.quit_requested = False
        self._init_joystick()

    def _init_joystick(self):
        pygame.joystick.init()
        if pygame.joystick.get_count() > 0:
            self.joy = pygame.joystick.Joystick(0)
            self.joy.init()

    def poll(self):
        self.a_pressed = False
        self.left_pressed = False
        self.right_pressed = False
        self.move_dir = 0
        self.quit_requested = False

        keys = pygame.key.get_pressed()

        if keys[pygame.K_ESCAPE]:
            self.quit_requested = True

        # Déplacement continu pendant la partie
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            self.move_dir -= 1
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            self.move_dir += 1

        # Axe joystick
        if self.joy is not None and self.joy.get_init():
            try:
                axis = self.joy.get_axis(0)
            except pygame.error:
                axis = 0.0

            deadzone = 0.25
            if axis < -deadzone:
                self.move_dir -= 1
            elif axis > deadzone:
                self.move_dir += 1

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.quit_requested = True

            elif event.type == pygame.KEYDOWN:
                if event.key in (pygame.K_RETURN, pygame.K_SPACE, pygame.K_a):
                    self.a_pressed = True
                elif event.key == pygame.K_LEFT:
                    self.left_pressed = True
                elif event.key == pygame.K_RIGHT:
                    self.right_pressed = True

            elif event.type == pygame.JOYBUTTONDOWN:
                if event.button == JOY_BUTTON_A:
                    self.a_pressed = True

            elif event.type == pygame.JOYHATMOTION:
                hat_x, _ = event.value
                if hat_x < 0:
                    self.left_pressed = True
                elif hat_x > 0:
                    self.right_pressed = True


# =============================
# Audio
# =============================
def start_music():
    if not ENABLE_MUSIC:
        return

    music_path = Path(MUSIC_FILE)
    if not music_path.exists():
        print(f"Musique introuvable : {music_path}")
        return

    try:
        pygame.mixer.init()
        pygame.mixer.music.load(str(music_path))
        pygame.mixer.music.set_volume(MUSIC_VOLUME)
        pygame.mixer.music.play(-1)  # boucle infinie
    except pygame.error as err:
        print(f"Audio désactivé : {err}")


def stop_music():
    try:
        if pygame.mixer.get_init():
            pygame.mixer.music.stop()
            pygame.mixer.quit()
    except pygame.error:
        pass


# =============================
# Jeu principal
# =============================
def main():
    pygame.init()
    pygame.display.set_caption("Dodge the Blocks")

    flags = pygame.FULLSCREEN if FORCE_FULLSCREEN else 0
    screen = pygame.display.set_mode((WIDTH, HEIGHT), flags)
    clock = pygame.time.Clock()

    font_big = pygame.font.SysFont(None, 64)
    font_med = pygame.font.SysFont(None, 36)
    font_small = pygame.font.SysFont(None, 26)

    start_music()
    inp = Input()

    color_index = 0
    state = STATE_START

    player = Player(PLAYER_COLORS[color_index][1])
    blocks = []

    start_time = 0.0
    survive_time = 0.0
    best_score = 0.0
    spawn_acc = 0.0
    gameover_time = 0.0

    def reset_game():
        nonlocal player, blocks, start_time, survive_time, spawn_acc
        player = Player(PLAYER_COLORS[color_index][1])
        blocks = []
        start_time = time.time()
        survive_time = 0.0
        spawn_acc = 0.0

    running = True
    while running:
        dt = clock.tick(FPS) / 1000.0
        inp.poll()

        if inp.quit_requested:
            running = False

        if state == STATE_START:
            if inp.left_pressed:
                color_index = (color_index - 1) % len(PLAYER_COLORS)
            elif inp.right_pressed:
                color_index = (color_index + 1) % len(PLAYER_COLORS)

            player.color = PLAYER_COLORS[color_index][1]

            if inp.a_pressed:
                reset_game()
                state = STATE_PLAYING

        elif state == STATE_PLAYING:
            survive_time = time.time() - start_time
            best_score = max(best_score, survive_time)

            difficulty = clamp(survive_time / RAMP_DURATION, 0.0, 1.0)
            spawn_rate = SPAWN_START + (SPAWN_MAX - SPAWN_START) * difficulty
            speed_bonus = int(120 * difficulty)

            spawn_acc += dt * spawn_rate
            while spawn_acc >= 1.0 and len(blocks) < MAX_BLOCKS:
                spawn_acc -= 1.0
                blocks.append(Block(speed_bonus))

            player.update(dt, inp.move_dir)

            for block in blocks:
                block.update(dt)

            blocks = [b for b in blocks if b.rect.y < HEIGHT + 60]

            for block in blocks:
                if player.rect.colliderect(block.rect):
                    state = STATE_GAMEOVER
                    gameover_time = time.time()
                    break

        elif state == STATE_GAMEOVER:
            best_score = max(best_score, survive_time)

            if inp.a_pressed and (time.time() - gameover_time) > 0.25:
                reset_game()
                state = STATE_PLAYING

            # Changer la couleur aussi depuis l'écran de game over
            if inp.left_pressed:
                color_index = (color_index - 1) % len(PLAYER_COLORS)
                player.color = PLAYER_COLORS[color_index][1]
            elif inp.right_pressed:
                color_index = (color_index + 1) % len(PLAYER_COLORS)
                player.color = PLAYER_COLORS[color_index][1]

        # =============================
        # Rendu
        # =============================
        screen.fill(BG)
        draw_grid(screen)

        if state in (STATE_PLAYING, STATE_GAMEOVER):
            for block in blocks:
                block.draw(screen)

        player.draw(screen)

        if state == STATE_START:
            selected_name, selected_color = PLAYER_COLORS[color_index]

            draw_center_text(screen, font_big, "DODGEBLOCKS", HEIGHT // 2 - 120, selected_color)
            draw_center_text(screen, font_med, "Left / Right : change color", HEIGHT // 2 - 30, WHITE)
            draw_center_text(screen, font_med, f"Color : {selected_name}", HEIGHT // 2 + 10, selected_color)
            draw_center_text(screen, font_med, "Press A / Space / Enter", HEIGHT // 2 + 65, WHITE)
            draw_center_text(screen, font_small, "ESC to quit", HEIGHT // 2 + 110, GRAY)

        elif state == STATE_PLAYING:
            score_surf = font_small.render(f"Score : {survive_time:05.1f}s", True, WHITE)
            best_surf = font_small.render(f"Best : {best_score:05.1f}s", True, WHITE)
            esc_surf = font_small.render("ESC : quit", True, GRAY)

            screen.blit(score_surf, (16, 12))
            screen.blit(best_surf, (16, 40))
            screen.blit(esc_surf, (16, 68))

        elif state == STATE_GAMEOVER:
            selected_name, selected_color = PLAYER_COLORS[color_index]

            draw_center_text(screen, font_big, "GAME OVER", HEIGHT // 2 - 80, RED)
            draw_center_text(screen, font_med, f"Score : {survive_time:0.1f}s", HEIGHT // 2 - 20, WHITE)
            draw_center_text(screen, font_med, f"Best : {best_score:0.1f}s", HEIGHT // 2 + 15, WHITE)
            draw_center_text(screen, font_med, f"Color : {selected_name}", HEIGHT // 2 + 50, selected_color)
            draw_center_text(screen, font_small, "Left / Right : change color", HEIGHT // 2 + 90, GRAY)
            draw_center_text(screen, font_small, "Press A / Space / Enter to restart", HEIGHT // 2 + 120, GRAY)
            draw_center_text(screen, font_small, "ESC to quit", HEIGHT // 2 + 150, GRAY)

        pygame.display.flip()

    stop_music()
    pygame.quit()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())