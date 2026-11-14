# SWITCHWORKS — Jeu 001

Ce dossier contient pour l'instant un **projet minimal de vérification technique**. La scène ne constitue ni le gameplay ni la direction artistique finale de SWITCHWORKS.

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
