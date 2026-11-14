# Mission Codex — Passe de correction ciblée Archipel Postal

Tu travailles dans `C:\Users\malik\Developpement\studio-100-games`, sur le projet `games/001-switchworks`.

La revue critique indépendante d'un autre assistant IA est disponible dans `games/001-switchworks/docs/revue-critique-ia-2026-11-14/REVUE_CRITIQUE.md` ; elle ne constitue pas un test humain. Lis-la avec les captures comparatives et avec le dossier natif `docs/vertical-slice`, la recette de stabilisation et les documents artistiques existants. Ne considère aucune note subjective comme une vérité non contestable : vérifie les constats dans le rendu Godot.

## Travail à effectuer

1. Vérifie d'abord que la branche `feat/archipel-postal-vertical-slice` et la référence `d36af097` sont présentes, que l'arbre est propre et que les tests de référence passent. Crée une branche de corrections depuis cette référence sans modifier `main`. Préserve tout travail existant.
2. **P1 UX :** distingue clairement les quais de départ et d'arrivée, sans modifier la grille, les ports, les règles ni les niveaux. Inscris l'objectif A→A, B→B dans le guidage initial et différencie les fonctions des stations par des silhouettes/signalisations non dépendantes uniquement des couleurs.
3. **P1 états :** corrige les textes des états préparation, reprise, trajet, erreur et victoire. Lors du trajet, ne plus afficher « Touchez une voie... » si la rotation est verrouillée. En préparation restaurée, ne plus inviter génériquement à tourner un réseau déjà raccordé. Remplace « essai(s) » par une formulation naturelle.
4. **P1 graphique :** améliore sur un petit jeu d'assets de référence les ombres fortes des pavillons et fleurs ainsi que l'unité de matériaux (porcelaine/papier/kraft). Ne crée pas un effet d'image générée sans cohérence de texture, d'échelle et d'éclairage ; conserve les performances mobiles.
5. **P2 rails :** diminue le bruit des traverses répétées et harmonise les voies bleues et brunes, sans altérer leur topologie, les ports ni les indices A/B.
6. **P2 arrivée :** rends reconnaissable la réception locale des deux colis par un feedback court, sobre et réductible avec l'option de mouvement réduit. Il doit se voir dans une nouvelle vidéo native.
7. **P3 HUD :** abaisse la priorité de la marque, évite les consignes redondantes et sécurise la marge inférieure pour Android, en préservant la taille des contrôles tactiles.
8. Utilise les skills pertinents : `studio-art-direction`, `studio-visual-qa`, `studio-game-ux`, `game-feel`, `godot-ui-control`, `create-game-assets`. Préfère les modifications ciblées aux refontes globales.

## Recette

- Exécuter et rapporter les suites de tests réellement disponibles, sans effacer les assertions ni déclarer un succès sans preuve.
- Produire les captures **réelles Godot/Android** des états préparation, transport, victoire et reprise, même cadrage que les sources précédentes, plus une courte vidéo d'arrivée des colis ; conserver les originaux non retouchés.
- Comparer visuellement avant/après sur 1080×2400, 720×1280, 1200×1600 et un format compact ; noter la performance mesurée sans attribuer à tort les FPS de l'émulateur à un appareil physique.
- Contrôler les changements de consigne par tests d'état ; vérifier la lisibilité de A/B en niveaux de gris et la différenciation départ/réception.
- Réaliser une revue QA critique, documenter les erreurs restantes et les décisions. Les tests utilisateurs réels (cinq personnes proposées) restent à organiser avec l'utilisateur.

**Interdictions de cette passe :** aucun nouveau niveau, boutique, compte, analytics, push distant, publication en store, remplacement global des assets ou suppression de l'historique ; ne pas prétendre que la validation artistique ou commerciale est acquise.

**Sortie attendue :** correctifs versionnés localement sur branche dédiée, captures/vidéo du jeu réel, résultats de tests, tableau avant/après et décision de QA argumentée. Demande la validation humaine avant d'étendre le contenu.
