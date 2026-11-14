# VS-002 — Corriger la présentation sans étendre la tranche

- Date : 14 novembre 2026
- Statut : correction ciblée autorisée, mise en œuvre ; acceptation humaine et commerciale non acquise
- Base : `d36af097`, branche `fix/archipel-postal-finition-p1-p2`

La revue critique confirme l'utilité d'une correction du même écran, sans nouveau niveau. Les problèmes de rôles, de guidage et d'ombres sont observables dans le rendu ; les notes expertes ne prouvent pas les réactions de joueurs.

La décision conserve Godot Standard/Compatibility, le modèle et toutes les textures. Une coque/cap natifs ajoutent un mesh par tuile, une boîte de réception remplace la silhouette quasi jumelle du guichet, et la lumière/réflexion statique est calibrée pour cette miniature. Une refonte globale ou de nouveaux lots d'images n'apporteraient pas de preuve supplémentaire de compréhension et augmenteraient le risque de dérive de famille.

Le feedback de réception anime uniquement les objets de présentation : le résultat logique, l'instant de réussite et l'accès à Rejouer restent indépendants. Pause, reset et mouvement réduit doivent ramener exactement les poses finales ou initiales prévues. Les consignes sont bornées à deux lignes et construites après un premier layout ; le défaut de minimum d'autowrap trouvé sur Android justifie la nouvelle fixture de chargement précoce.

Les preuves avant/après partagent scène, ports, caméra, AVD et tailles physiques. La composition HUD évolue volontairement ; les images de transport ne sont pas artificiellement synchronisées au même tick. Les vidéos restent originales, avec cadence encodée séparée des FPS du moteur. Les tests fonctionnels ne ferment aucun critère artistique humain.

Conséquences : accepter la petite hausse de coût d'objets en s'appuyant sur les mesures disponibles, conserver les anciens APK/rapports, faire une revue humaine et choisir un téléphone de référence. [Recette et réserves](../polish/REPORT.md). Aucune extension ou diffusion n'est décidée par cet ADR.
