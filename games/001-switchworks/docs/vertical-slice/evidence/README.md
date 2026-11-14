# Preuves du rendu exécuté

Ces fichiers sont des copies octet pour octet des captures et journaux de la recette finale du 14 novembre 2026. Le [manifeste](MANIFEST.json) donne chaque source, empreinte et dimension. Le [rapport](../REPORT.md) indique les interprétations et limites.

- `android/` : `screencap` du package expérimental sur Studio_API_36, écran 1080×2400, et vidéo `screenrecord` 720×1600 sans audio. États atteints par interactions ADB ; reçu 67/67 et logs par PID.
- `desktop/` : framebuffer Godot réellement exécuté sur Windows, cinq proportions ; les états de capture sont préparés par arguments de développement.
- `android-layouts/` : deux tailles de l'AVD réellement appliquées (720×1280, 1200×1600), commandes tactiles et pause, reçu 28/28 ; l'affichage et la préparation de départ sont restaurés en fin de passage.
- `logs/` : tests, import, export et contrôles géométriques. Encodages originaux conservés (certains journaux PowerShell sont UTF-16). Les deux journaux `negative-control` contiennent un échec intentionnel pour prouver le code de sortie non nul.

Scène `res://scenes/archipel_postal.tscn`, Godot `4.7.2.stable.official.ed1daf0bf` Standard. Branche `feat/archipel-postal-vertical-slice`, parent Git `68548a4b004a047e43d9ce0c77f248ffc07af23d`, modifications de tranche locales non commitées.

Les compteurs diffèrent entre le concept artistique et la recette : le concept illustrait deux rotations sans essai ; le niveau natif nouveau comporte six rotations témoins, et la recette démontre d'abord un échec. Ces nombres proviennent de la session réelle. Aucune image conceptuelle ne figure parmi ces preuves de fonctionnement.
