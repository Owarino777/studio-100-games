# SWITCHWORKS — Jeu 001

Ce dossier conserve la **mire historique du bootstrap** et ajoute une **tranche verticale expérimentale native**, fondée sur la direction candidate **B — Archipel Postal**. SWITCHWORKS reste **TEST / HOLD**, sans validation artistique ou commerciale définitive.

Sur la branche `test/archipel-postal-web-iphone`, une [version Web Godot de test](docs/web-test/REPORT.md) et son [accès HTTPS temporaire autorisé](docs/web-test/ACCESS.md) permettent de préparer les essais Safari. Le [protocole iPhone Safari](docs/user-tests/safari-web-5/README.md) ne remplace pas la campagne Android native ; les résultats sont séparés.

La [passe ciblée issue de la revue critique](docs/polish/REPORT.md) améliore le même niveau : quais distincts, consignes, ombres/matières, voies, réception et HUD. Ses [captures comparatives](docs/polish/evidence/diagnostics/comparison-planning-1080x2400.png) et sa [vidéo Android](docs/polish/evidence/regression/android-gameplay.mp4) proviennent du jeu exécuté. Le nouvel export séparé est `build/android/switchworks-archipel-polish-debug.apk` ; l'APK initial reste conservé. Une validation humaine est requise avant toute extension.

La [référence de stabilisation et les seconds regards indépendants](docs/stabilization/README.md) préparent une revue humaine et une éventuelle finition limitée. Le [kit externe autonome](docs/stabilization/review-kit/README.md) conserve les captures et la vidéo originales ; aucune extension du gameplay n'est ajoutée à ce jalon.

## Jouer à la tranche Archipel Postal

Depuis la racine du studio :

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action Run
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action Test
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action ExportAndroid
```

Dans Godot, ouvrir `scenes/archipel_postal.tscn` et utiliser **F6**. Le démarrage F5 par défaut conserve volontairement `scenes/verification.tscn`, pour retrouver la fondation sans ambiguïté. La tranche Android utilise le preset indépendant **Android Archipel Slice** et son feature tag ; elle ne remplace pas le package de vérification.

Le niveau « Les deux tournées » est nouveau : grille 6×6, deux flux A/B, six voies à réorienter et solution témoin fournie. Il n'est pas présenté comme un niveau historique restauré ni comme un PAR optimal prouvé. Les autres districts, les 18 niveaux web, comptes, achats et publicité ne font pas partie de cette tranche.

- Toucher une voie, ou la sélectionner avec les flèches puis Entrée : rotation de 90°.
- **Expédier** lance les deux colis ; la simulation bloque l'édition. Une rupture est signalée et peut être corrigée.
- **Annuler** restaure une action de préparation, ses rotations et indices ; les essais réellement lancés restent comptés.
- **Indice** encadre une voie de la solution témoin, sans la tourner automatiquement.
- **Pause** ouvre Reprendre, Recommencer, Mouvement réduit et Sons discrets. Les sons sont coupés initialement ; ils sont synthétisés localement, sans fichier tiers.
- Une victoire propose **Rejouer**. Le plateau n'est pas éditable derrière le bilan de réussite.

La préparation, les compteurs et les préférences sont sauvegardés localement avec un schéma versionné et remplacement atomique. Home/reprise garde la session en mémoire et demande Reprendre ; un redémarrage du processus retrouve la préparation en phase de planification, sans relancer un colis automatiquement. L'historique d'annulation et la phase de simulation ne sont pas restaurés après destruction du processus. Aucune migration des sauvegardes HTML G2/G3 n'est prétendue.

L'APK debug courant est généré sous `build/android/switchworks-archipel-polish-debug.apk`, avec le package distinct `org.studio100games.switchworks.archipel.slice`. L'APK initial `switchworks-archipel-slice-debug.apk` est conservé. Les notices Godot et Nunito Sans sont incluses. Les captures, les mesures et les limites historiques figurent dans [le rapport de tranche](docs/vertical-slice/REPORT.md) ; le correctif actuel est documenté dans [la recette de finition](docs/polish/REPORT.md).

Le plateau, les rails, pavillons et colis sont de vraies géométries indépendantes ; seuls les albedos et le décor de ciel sont des textures. Aucun poster conceptuel ne remplace le jeu ou les contrôles. Les sources d'assets et leurs conditions sont dans [assets/archipel/README.md](assets/archipel/README.md), le manifeste et les licences embarquées.

## Fondation conservée

La mire technique d'origine ne constitue ni le gameplay ni une validation artistique de la tranche.

Décisions : Godot **4.7.2 stable Standard**, GDScript typé, Android et iOS. Le poste Windows sert en priorité à Android ; les builds iOS seront vérifiés ultérieurement sur macOS.

## Contenu

- `project.godot` : configuration portrait 360 × 640, UI étirable et rendu Compatibility.
- `scenes/verification.tscn` : écran natif Godot, textes et bouton de contrôle.
- `scripts/verification.gd` : informations du moteur, compteur d'interactions et marges sûres mobiles.
- `tests/test_runner.gd` : contrôles d'intégration de la scène, du signal bouton, du focus et des dimensions.
- `export_presets.cfg` : presets Android APK/AAB debug, ARM64 et x86_64.
- `icons/verification.svg` : icône technique originale requise par l'export, sans identité graphique commerciale.

La mire utilise uniquement les contrôles et la police embarqués dans Godot. Aucun asset externe, son, animation, SDK publicitaire, achat ou stockage utilisateur n'est ajouté. L'état du compteur est volontairement temporaire.

## Utilisation

Les commandes communes du studio sont décrites dans [tools/README.md](../../tools/README.md) à la racine :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Import
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Test
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Run
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action ExportAndroid -Format apk
```

L'option d'exécution est limitée au processus et ne change pas la politique PowerShell globale. Avec le binaire Godot 4.7.2 explicitement sélectionné, les commandes sous-jacentes sont :

```powershell
# Depuis la racine du studio ; $godotBin désigne le binaire installé localement.
& $godotBin --headless --path games/001-switchworks --import
& $godotBin --headless --path games/001-switchworks --script res://tests/test_runner.gd
& $godotBin --headless --path games/001-switchworks --quit-after 120
& $godotBin --path games/001-switchworks
```

Le runner imprime `BOOTSTRAP_TESTS passed=… failed=…` et sort avec un code non nul en cas d'échec. L'argument utilisateur `-- --force-failure` provoque volontairement un échec pour vérifier ce contrat. Les logs de smoke test doivent également être inspectés : Godot peut sortir avec code 0 après une erreur de script.

La scène imprime `BOOTSTRAP_READY` au démarrage et `BOOTSTRAP_INPUT count=…` après une interaction. Ces événements servent à vérifier le lancement réel et la réponse sur Android, sans données personnelles.

L'export Android active l'import de textures ETC2/ASTC requis par le moteur. Le package `org.studio100games.switchworks.verification` est réservé à cette vérification locale ; la publication et l'identité commerciale seront configurées séparément. Aucun secret de signature n'est enregistré dans les presets.

## Direction de la mire et recette

La cible visuelle est celle d'un écran d'atelier : fond uni sombre, texte clair, un seul bouton large et aucune animation. Le titre précise le caractère technique de la scène. L'information essentielle est l'état d'initialisation du moteur et la réponse du bouton. Aucun benchmark artistique de concurrents ni art bible du jeu n'est lancé à cette étape de configuration.

Vérifier le texte à 360 × 640 et 720 × 1280, l'absence de débordement, le focus initial, l'activation au clavier et par toucher. Les captures doivent provenir d'une exécution du vrai moteur ou du paquet Android ; la recette opérationnelle du studio consigne les résultats et limites. Les tests headless couvrent la structure et le signal du bouton, pas le rendu GPU ou la réception tactile d'un appareil.
