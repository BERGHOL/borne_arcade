
# Rapport IA documentation

## Diff analys�
diff --git a/docs/DOCUMENTATION_TECHNIQUE.md b/docs/DOCUMENTATION_TECHNIQUE.md
index a20dbcd..7389e66 100644
--- a/docs/DOCUMENTATION_TECHNIQUE.md
+++ b/docs/DOCUMENTATION_TECHNIQUE.md
@@ -337,4 +337,8 @@ La borne peut désormais être :
 - Installée automatiquement
 - Mise à jour via Git
 - Relancée automatiquement en cas de crash
-- Maintenue durablement dans le temps
\ No newline at end of file
+- Maintenue durablement dans le temps
+
+---
+
+La documentation suit une approche Docs-as-Code : elle est versionnée dans Git, contrôlée par pull request, validée par des checks CI, puis publiée automatiquement. Une IA intervient comme assistant de rédaction : elle analyse les diffs, produit un rapport de revue documentaire, et peut proposer des mises à jour. Le merge reste conditionné à une validation humaine et à la réussite des tests.

## Actions recommand�es

- V�rifier INSTALLATION.md
- V�rifier DOCUMENTATION_TECHNIQUE.md
- V�rifier AJOUT_JEU.md
- V�rifier UTILISATEUR.md

R�gle : L'IA propose, l'humain valide.
