---
name: studio-visual-qa
description: Auditer la qualité d'un vrai rendu de jeu sur PC ou mobile; captures depuis moteur exécuté, comparaison à l'art bible, cohérence des assets, visuels, ergonomie tactile, régressions et performances; déclencher avant toute livraison d'UI/gameplay.
---

# Recette visuelle exécutée

1. Déterminer la version/build exact, plate-forme, jeu de scènes, révisions de l'art bible et cas testés.
2. Démarrer le jeu réellement. Enregistrer au moins une capture de l'écran d'accueil, du gameplay standard, d'un état d'erreur, d'une réussite et d'un écran secondaire si applicable. Capturer au minimum une taille smartphone petite, une moyenne et une tablette si le projet les vise.
3. Comparer le rendu exécuté à la direction approuvée. Ne pas se contenter de screenshots de maquettes. Vérifier silhouettes, matériaux, icônes, espacements, lisibilité, états actifs/inactifs, animation et feedback.
4. Exécuter les entrées réelles : toucher/clic, retour, pause, rotation, sauvegarde et reprise. Vérifier absence de zones invisibles/clips, cohérence avec la simulation du jeu.
5. Exécuter les tests disponibles ; relever logs et exceptions. Pour la performance, mesurer sur appareils ciblés si disponibles, sinon indiquer qu'elle reste non testée.
6. Attribuer à chaque anomalie ID, écran, résolution, attendu/observé, reproduction, gravité (bloquant/majeur/mineur), capture et statut. Réparer les bloquants avant livraison. Re-tester les corrections.

### Anti-faux résultat
- Une image générée ne prouve pas une implémentation.
- Un HTML ouvert par injection de contenu ne prouve pas qu'un ZIP téléchargeable démarre chez l'utilisateur.
- « Zéro problème » veut seulement dire aucun problème détecté dans le périmètre testé. Ne pas inférer iOS/Android physique depuis Chromium desktop.

### Rapport
Tableau des preuves, commandes exécutées, résolutions, captures du build, écarts par gravité, résultats des tests, contrôles impossibles et statut GO / NO GO.
