# Mission Codex — Utiliser les références visuelles comme contrat de design contrôlable

Lis `AGENTS.md`, le dossier de conception d’Archipel Postal et tous les fichiers de `docs/art/switchworks/references-2026-11-16/`.

Ces deux planches visuelles sont des **références conceptuelles originales**, générées pour réduire l’improvisation artistique. Elles ne constituent ni un mockup garanti techniquement réalisable, ni des captures Godot, ni des assets finalisés. Les règles de la scène existante, les ports et connexions du niveau, les comportements A/B et les contraintes mobiles font autorité.

**Travail demandé**
1. Auditer la correspondance entre la direction visuelle des deux planches et les contraintes actuelles du gameplay : géométrie, points de connexion, proportions et lisibilité du niveau. Relever explicitement les éléments incompatibles ou confus. Ne rien intégrer directement depuis les planches.
2. Formaliser une mini art bible approuvable : silhouettes, échelle relative, palette, 4 à 6 matériaux avec paramètres plausibles, éclairage, typographie, traitement des HUD, symboles A/B et principes d’animation. Distinguer décor, éléments interactifs et retours d’état.
3. Produire **une seule composition de référence** basée sur un vrai niveau : mise en place des rails, guichet, boîte et colis, avec deux états de jeu au minimum (préparation et réception). Produire une version de lecture à taille mobile et une planche simple des pièces modulaires.
4. Construire une mini-scène Godot isolée avec trois familles de modèles éditables (guichet, boîte, voie), les exports `.glb` et leur source `.blend` si Blender est retenu. Les composants doivent être fonctionnels : sélection, rotation, réception selon les vrais événements existants.
5. Capturer **dans Godot**, avant et après intégration, la même taille d’écran. Tester une taille mobile habituelle et un format compact ; vérifier une partie de bout en bout, la lisibilité à l’échelle réelle, la cohérence entre connexion logique et rails affichés, les interactions au doigt et les régressions.
6. Documenter les mesures réellement disponibles (temps de chargement, FPS, mémoire, triangles, draw calls), sans inventer de résultats Safari ou appareils physiques. Expliquer les compromis si WebGL/Compatibility impose une simplification.
7. Comparer objectivement les captures réelles aux critères de l’art bible, signaler les défauts majeurs et les corriger. Ne pas substituer une belle illustration aux preuves moteur. En cas de résultat insuffisant, conclure REWORK.

**Contraintes** : budget de 0 € pour logiciels/API, licences commerciales vérifiées, aucun service payant, aucune publication distante, pas de refonte totale, pas de niveau supplémentaire, aucune suppression de branches ou de sources.

**Livrables** : art bible courte, tableau « inspiration → règle applicable → élément Godot → preuve », modèles sources/modulaires, scène de test, images brutes, courtes séquences d’animation, checklist ergonomique, rapport contradictoire GO/REWORK/STOP. L’utilisateur valide la direction artistique avant toute généralisation.
