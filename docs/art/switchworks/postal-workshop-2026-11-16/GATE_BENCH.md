# Porte de validation du banc — 17 novembre 2026

Décision **GO technique/expert pour l'intégration limitée à l'unique niveau**, pas approbation artistique humaine ni commerciale.

Le banc `workbench.tscn` a été exécuté avant le niveau complet. La première composition masquait une partie du rail entre les stations : rejetée et recadrée en trois rangées distinctes. La seconde montrait côte à côte les anciens objets et le candidat sous la même caméra et la même lumière, avec la tuile, la voie rotative, les deux rôles de station et trois commandes thémées réellement actives.

Observations ayant permis l'intégration :

- Deux rôles visibles par la construction et les pictogrammes : guichet ouvert à flèche, boîte fermée à enveloppe. A/cercle et B/triangle conservés ; pas de choix fondé sur la couleur seule.
- Céramique et joints plus fins, métal et traverses moins envahissants, absence de toiture/dorure/fleurs sans fonction ; gain de sobriété cohérent avec la page 12 du brief.
- Rail à deux ports et pivot stable ; Tourner/Annuler agissent sur PostalBoard, pas sur un dessin. La réception d'aperçu est déclenchée après réussite d'une simulation témoin existante, sans nouvel état métier ni niveau.
- Dix GLB relus avec Godot puis inspectés indépendamment : aucun triangle dégénéré/face inversée dans le périmètre du contrôle ; ports physiques aux bords conformes.

Réserves transmises à l'intégration : garder de la marge dans les albedos clairs pour éviter les blancs brûlés ; vérifier les pictogrammes et lettres à taille mobile, pas seulement dans cette grande planche ; vérifier les ombres et la pause sur petits formats. Ces points ont entraîné des corrections et des captures supplémentaires, consignées dans la recette.

Ce jugement est celui de l'agent producteur à partir du vrai rendu. La reconnaissance en trois secondes par des personnes indépendantes et le confort physique restent non démontrés. Les preuves du banc sont conservées avec les autres captures de recette, et les candidats rejetés restent sous `artifacts/ui-ux-refonte-2026-11-16/`.
