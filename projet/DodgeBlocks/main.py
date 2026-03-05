#!/usr/bin/env python3
import sys
import random
import time
import pygame

# -----------------------------
# Configuration
# -----------------------------
WIDTH, HEIGHT = 800, 600
FPS = 60

PLAYER_W, PLAYER_H = 50, 20
PLAYER_SPEED = 420  # pixels/s

BLOCK_W, BLOCK_H = 40, 40
BLOCK_MIN_SPEED = 180   # pixels/s
BLOCK_MAX_SPEED = 520
SPAWN_START_PER_SEC = 1.2   # blocs/s au début
SPAWN_MAX_PER_SEC = 5.0     # blocs/s max
DIFFICULTY_RAMP_SECONDS = 90  # temps pour atteindre spawn max

# Joystick : bouton "A" (souvent 0 sur beaucoup de manettes, mais ça dépend)
JOY_BUTTON_A = 0

# Fullscreen option (utile sur borne). Mettre True si vous voulez forcer le plein écran.
FORCE_FULLSCREEN = False

# -----------------------------
# Utilitaires
# -----------------------------
def clamp(v, a, b):
    return max(a, min(b, v))

def draw_center_text(screen, font, text, y, color=(255, 255, 255)):
    surf = font.render(text, True, color)
    rect = surf.get_rect(center=(WIDTH // 2, y))
    screen.blit(surf, rect)

# -----------------------------
# Entités
# -----------------------------
class Player:
    def __init__(self):
        self.rect = pygame.Rect((WIDTH - PLAYER_W)//2, HEIGHT - 80, PLAYER_W, PLAYER_H)

    def update(self, dt, move_dir):
        # move_dir: -1 (gauche), 0, +1 (droite)
        self.rect.x += int(move_dir * PLAYER_SPEED * dt)
        self.rect.x = clamp(self.rect.x, 0, WIDTH - self.rect.w)

    def draw(self, screen):
        pygame.draw.rect(screen, (0, 200, 255), self.rect, border_radius=6)

class Block:
    def __init__(self):
        x = random.randint(0, WIDTH - BLOCK_W)
        y = -BLOCK_H
        self.rect = pygame.Rect(x, y, BLOCK_W, BLOCK_H)
        self.speed = random.randint(BLOCK_MIN_SPEED, BLOCK_MAX_SPEED)

    def update(self, dt):
        self.rect.y += int(self.speed * dt)

    def draw(self, screen):
        pygame.draw.rect(screen, (255, 80, 80), self.rect, border_radius=6)

# -----------------------------
# Gestion input (clavier + joystick)
# -----------------------------
class Input:
    def __init__(self):
        self.joy = None
        self._init_joystick()

        # état "bouton A" edge-trigger (appui)
        self.a_pressed = False

        # direction -1 / 0 / +1
        self.move_dir = 0

        # demande de quitter
        self.quit_requested = False

    def _init_joystick(self):
        pygame.joystick.init()
        if pygame.joystick.get_count() > 0:
            self.joy = pygame.joystick.Joystick(0)
            self.joy.init()

    def poll(self):
        self.a_pressed = False
        self.move_dir = 0
        self.quit_requested = False

        keys = pygame.key.get_pressed()
        if keys[pygame.K_ESCAPE]:
            self.quit_requested = True

        # Clavier (fallback)
        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            self.move_dir -= 1
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            self.move_dir += 1

        # Joystick
        if self.joy is not None and self.joy.get_init():
            # Axe horizontal (souvent axe 0)
            try:
                axis = self.joy.get_axis(0)
            except pygame.error:
                axis = 0.0

            deadzone = 0.25
            if axis < -deadzone:
                self.move_dir -= 1
            elif axis > deadzone:
                self.move_dir += 1

        # Gestion événements (pour bouton A + quit fenêtre)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.quit_requested = True

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_RETURN or event.key == pygame.K_SPACE:
                    self.a_pressed = True

            if event.type == pygame.JOYBUTTONDOWN:
                if event.button == JOY_BUTTON_A:
                    self.a_pressed = True

# -----------------------------
# Boucle de jeu (états)
# -----------------------------
STATE_START = "start"
STATE_PLAYING = "playing"
STATE_GAMEOVER = "gameover"

def main():
    pygame.init()
    pygame.display.set_caption("Dodge the Blocks")

    flags = 0
    if FORCE_FULLSCREEN:
        flags |= pygame.FULLSCREEN

    screen = pygame.display.set_mode((WIDTH, HEIGHT), flags)
    clock = pygame.time.Clock()

    font_big = pygame.font.SysFont(None, 60)
    font_med = pygame.font.SysFont(None, 36)
    font_small = pygame.font.SysFont(None, 26)

    inp = Input()

    state = STATE_START
    player = Player()
    blocks = []
    start_time = None
    survive_time = 0.0

    # spawn timer
    spawn_acc = 0.0

    def reset_game():
        nonlocal player, blocks, start_time, survive_time, spawn_acc
        player = Player()
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

        # logique par état
        if state == STATE_START:
            if inp.a_pressed:
                reset_game()
                state = STATE_PLAYING

        elif state == STATE_PLAYING:
            # temps de survie = score (en secondes)
            survive_time = time.time() - start_time if start_time else 0.0

            # difficulté : spawn/sec augmente progressivement
            t = clamp(survive_time / DIFFICULTY_RAMP_SECONDS, 0.0, 1.0)
            spawn_per_sec = SPAWN_START_PER_SEC + (SPAWN_MAX_PER_SEC - SPAWN_START_PER_SEC) * t

            # spawn bloc via accumulateur
            spawn_acc += dt * spawn_per_sec
            while spawn_acc >= 1.0:
                spawn_acc -= 1.0
                blocks.append(Block())

            # update
            player.update(dt, inp.move_dir)
            for b in blocks:
                b.update(dt)

            # nettoyage blocs hors écran
            blocks = [b for b in blocks if b.rect.y < HEIGHT + 100]

            # collision
            for b in blocks:
                if player.rect.colliderect(b.rect):
                    state = STATE_GAMEOVER
                    break

        elif state == STATE_GAMEOVER:
            if inp.a_pressed:
                reset_game()
                state = STATE_PLAYING

        # rendu
        screen.fill((15, 15, 20))

        # dessins communs
        player.draw(screen)
        for b in blocks:
            b.draw(screen)

        # HUD / textes
        if state == STATE_START:
            draw_center_text(screen, font_big, "DODGE THE BLOCKS", HEIGHT // 2 - 80)
            draw_center_text(screen, font_med, "Press A to start", HEIGHT // 2)
            draw_center_text(screen, font_small, "ESC to quit", HEIGHT // 2 + 50)

        elif state == STATE_PLAYING:
            score_txt = f"Score: {survive_time:0.1f}s"
            hud = font_small.render(score_txt, True, (240, 240, 240))
            screen.blit(hud, (16, 12))
            hint = font_small.render("ESC to quit", True, (160, 160, 160))
            screen.blit(hint, (16, 40))

        elif state == STATE_GAMEOVER:
            draw_center_text(screen, font_big, "GAME OVER", HEIGHT // 2 - 60, (255, 120, 120))
            draw_center_text(screen, font_med, f"Score: {survive_time:0.1f}s", HEIGHT // 2 - 5)
            draw_center_text(screen, font_med, "Press A to restart", HEIGHT // 2 + 40)
            draw_center_text(screen, font_small, "ESC to quit", HEIGHT // 2 + 85)

        pygame.display.flip()

    pygame.quit()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())