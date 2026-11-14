# Recette du socle opérationnel — 14 novembre 2026

## Verdict

**Opérationnel pour développer et tester le projet minimal Godot sur Windows et Android, avec les réserves natives Android consignées ci-dessous.** Le lancement Windows, les tests headless, l'export APK, son installation, le rendu Android et l'interaction tactile ont été exécutés. L'export AAB est également vérifié, avec une sortie non signée destinée à la vérification de compilation. **Aucune qualification de publication ou de produit fini.** La chaîne iOS reste à exécuter sur macOS ultérieurement.

L'[audit initial](AUDIT_ENVIRONNEMENT_2026-11-14.md) est conservé comme état historique validé. La décision technique du propriétaire est consignée dans l'[ADR 0001](decisions/0001-socle-godot-mobile.md). Aucun gameplay ni graphisme complet de SWITCHWORKS n'a été commencé.

## Installation exécutée et outils réutilisés

| Élément | État vérifié |
|---|---|
| Git | `2.56.0.windows.4`, monorepo initialisé par `git init -b main` |
| Godot | Standard **`4.7.2.stable.official.ed1daf0bf`**, version réellement exécutée |
| Installation | `tools/.local/godot/4.7.2/`, portable `_sc_` ; aucun PATH global ajouté |
| Modèles | Archive Standard exacte ; `version.txt` = `4.7.2.stable`, modèles Android et `ios.zip` présents |
| JDK | Temurin **21.0.12.1** existant réutilisé, aucun JDK réinstallé |
| Android Studio / outils CLI | Installation 2026.1.4 et outils CLI 23 existants réutilisés |
| Plateformes | 35 et 36 déjà installées ; 34 et 37.0 conservées |
| Build-Tools | 35.0.1 ajouté ; 36.1.0 ajouté par le premier build Gradle ; 35.0.0 et 36.0.0 conservés |
| Platform-Tools | ADB **37.0.1** existant réutilisé |
| NDK | **28.1.13356709** ajouté à côté de 28.2.13676358 |
| CMake | **3.10.2.4988404** ajouté à côté de 3.22.1 |
| Émulateur / image | Émulateur **37.1.11** et image Android 36 Google APIs Play Store x86_64 existants réutilisés |
| Gradle | Wrapper **8.11.1** fourni par le template ; cache propre au studio, aucun Gradle global installé |
| SDK .NET | Non installé : inutile pour l'édition Standard et GDScript choisis |

Godot provient de la [release officielle 4.7.2 stable](https://godotengine.org/download/archive/4.7.2-stable/), via `godotengine/godot-builds`. Les deux archives ont été contrôlées contre le manifeste officiel et les empreintes désormais épinglées dans `tools/Setup-Studio.ps1` avant extraction :

| Archive | SHA512 |
|---|---|
| `Godot_v4.7.2-stable_win64.exe.zip` | `83decd58fdf67b9d657958a1ae6bf1929c20785315a81effe245874cdc57acb709bf868e00778a96984338c1b29dafdb453c6847747694621c6ecf5da2259993` |
| `Godot_v4.7.2-stable_export_templates.tpz` | `ca4d71c4d7b81dfc15d1a98baa07534aa95b03fdda78a0075b06672e1648d2e5f40980c9adc28d23e1b92e732ee7bf3461997aa804af74ec2fcd7a93ccb84079` |

Les préférences Java/SDK, les données de test `APPDATA`, les caches Android/Gradle et le nouvel AVD restent dans les emplacements locaux du studio. Seuls les paquets SDK manquants ont été ajoutés au SDK existant. Aucune modification de driver, hyperviseur, politique PowerShell persistante, variable Windows persistante ou projet extérieur n'a été effectuée.

La [page Android Godot 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html) liste encore Platform 35, Build-Tools 35.0.1, NDK 28.1 et CMake 3.10.2. Le template **effectivement téléchargé** contient `compileSdk=36`, `targetSdk=36`, Build-Tools 36.1.0 et une déclaration NDK 29.0.14206865. Les modèles précompilés ont permis les deux exports sans installer NDK 29 ; aucune compilation du moteur ou d'extension C++ n'est revendiquée. Les scripts contrôlent les prérequis documentés et ceux effectivement nécessaires à ces exports.

## Commandes et résultats observés

Commandes depuis la racine, avec `powershell.exe -NoProfile -ExecutionPolicy Bypass -File` pour les scripts. `Bypass` est limité au processus après revue des scripts ; la politique persistante n'a pas été modifiée.

| Contrôle réellement exécuté | Résultat |
|---|---|
| `Godot_v4.7.2-stable_win64_console.exe --headless --version` | `4.7.2.stable.official.ed1daf0bf`, code 0 |
| `tools/Setup-Studio.ps1 -InstallAndroidPackages` après installation | Code 0, idempotent, aucune réinstallation requise |
| `tools/Studio.ps1 -Action Doctor` | **12/12** prérequis contrôlés présents, code 0 |
| `tools/Studio.ps1 -Action Import` | Code 0, aucun `ERROR` ou `SCRIPT ERROR` |
| `tools/Studio.ps1 -Action Test` | **36 réussites, 0 échec**, code 0 |
| `tools/Studio.ps1 -Action Test -ForceTestFailure` | Échec volontaire détecté, **code 1** attendu |
| Vérification de ressources et compilation des scripts | Aucun chemin ressource cassé ; 2 scripts GDScript chargés sans erreur |
| Smoke test `--headless --path games/001-switchworks --quit-after 120` | Code 0, `BOOTSTRAP_READY`, aucun défaut runtime |
| Lancement et capture Windows avec le moteur exécuté | Compatibility/OpenGL 3.3, NVIDIA RTX 4060 Laptop, **450 × 800**, code 0 |
| `tools/Studio.ps1 -Action ExportAndroid -Format apk` | Code 0, APK présent, aucun `ERROR` dans le log final |
| `aapt dump badging` sur l'APK final | Package de vérification, **versionName 0.0.1**, **versionCode 1**, **minSdk 24, targetSdk 36**, ARM64/x86_64 |
| `apksigner verify --verbose` sur l'APK final | Signature debug valide, schémas v2/v3 vérifiés |
| `zipalign -c -P 16 4` sur l'APK | Code 0 ; vérifie l'alignement ZIP, sans certifier à lui seul les binaires ELF |
| `tools/Studio.ps1 -Action ExportAndroid -Format aab` | Code 0 et fin normale de commande après correction du daemon ; archive AAB valide, **non signée** |
| `jarsigner -verify` et inspection AAB | Sortie `jar is unsigned`, aucun fichier de signature JAR ; aucune signature de publication prétendue |
| Vérification ZIP des deux paquets | Aucun membre corrompu ; bibliothèques Godot ARM64/x86_64 présentes ; runner de tests exclu |
| Sonde contrôlée du timeout du helper | Processus de test arrêté après délai de 1 s, retour vérifié en **1,33 s** |
| `tools/Start-StudioEmulator.ps1 -Action Start` / `Status` | Démarrage et réexécution idempotente vérifiés ; identité de l'AVD contrôlée |
| `tools/Start-StudioEmulator.ps1 -Action Stop` puis `Status` | Seul AVD studio arrêté, `Running=false` ; aucun autre AVD touché |

Les logs positifs [headless](recette/bootstrap-2026-11-14/tests-headless.log), le [contrôle négatif attendu](recette/bootstrap-2026-11-14/tests-negative-control.log), le [rendu Windows](recette/bootstrap-2026-11-14/windows-render.log) et l'[export AAB final](recette/bootstrap-2026-11-14/export-aab.log) sont conservés. Les copies des logs initialement en UTF-16 sont converties en UTF-8 ; les originaux restent dans les artefacts locaux. Les sorties détaillées de travail restent sous `games/001-switchworks/artifacts/`, ignorées par Git.

## Recette Android exécutée

AVD neuf **`Studio_API_36`**, créé sous `tools/.local/android/avd/`, Android **16/API 36**, x86_64, **1080 × 2400**, accélération **WHPX**, backend **GPU host**. Le log du moteur confirme OpenGL ES 3.1 via le traducteur GLES Android Emulator et la **NVIDIA GeForce RTX 4060 Laptop**. Le serveur ADB dédié est sur **5041**, l'émulateur `emulator-5580`. Les AVD Pixel_8 et flutter_emulator existants n'ont pas été modifiés.

L'APK final a été installé avec ADB puis lancé par son activité réellement résolue : `org.studio100games.switchworks.verification/com.godot.game.GodotAppLauncher`. Le log confirme `BOOTSTRAP_READY platform=Android`, moteur 4.7.2. Un toucher à `(540,1275)` fait passer le compteur **0 → 1** et produit `BOOTSTRAP_INPUT count=1`. Après Home puis reprise, le lancement est `HOT`, le PID **4918** reste identique et le compteur vaut toujours 1.

**Aucune erreur Godot `ERROR:`, `SCRIPT ERROR` ou exception fatale détectée ; aucun crash observé dans l'essai Android final.** Le log comporte néanmoins des diagnostics natifs de niveau `E` : dépréciation `ashmem`, délais `SurfaceSyncGroup` au démarrage, puis `BufferQueueProducer`/`Surface` et `EGL_BAD_SURFACE` lors du passage en arrière-plan. Ils n'ont pas empêché la reprise ni les captures, mais restent une réserve à recontrôler sur appareil physique. Un avertissement Godot de cache shader recompilé est également présent. Ces messages interdisent de qualifier la recette de « zéro erreur native » ou « zéro avertissement ». Les [métadonnées annotées](recette/bootstrap-2026-11-14/verification-android.json), le [log applicatif](recette/bootstrap-2026-11-14/android-runtime.log), le [lancement](recette/bootstrap-2026-11-14/android-launch.log) et la [reprise](recette/bootstrap-2026-11-14/android-resume.log) sont conservés. Les annotations ajoutent le périmètre du détecteur et les diagnostics natifs ; les valeurs de l'essai restent celles du relevé original dans les artefacts locaux.

| Capture authentique | Environnement / scène / observation |
|---|---|
| [Windows 450 × 800](recette/bootstrap-2026-11-14/windows-450x800.png) | Windows 10.0.26300, Godot 4.7.2, `res://scenes/verification.tscn`, compteur 0 |
| [Android avant toucher](recette/bootstrap-2026-11-14/android-api36-before.png) | Android 16/API 36, même scène, 1080 × 2400, compteur 0 |
| [Android après toucher](recette/bootstrap-2026-11-14/android-api36-after.png) | Compteur 1, retour explicite de réception |
| [Android après reprise](recette/bootstrap-2026-11-14/android-api36-resumed.png) | Compteur conservé, même processus |

Les captures ont été inspectées : texte lisible, contrôle accessible, aucun débordement visible dans ces résolutions. Aucun écran de maquette ou concept art n'est utilisé comme preuve de fonctionnement.

## Anomalies rencontrées et corrections vérifiées

- `_sc_` isole les données de l'éditeur mais pas `user://` : `APPDATA` est désormais redirigé pour les seuls processus Godot de test.
- Le sandbox empêche la lecture du magasin de certificats Windows : les commandes propres ont été exécutées avec l'accès requis, sans désactiver TLS.
- Le contrôle natif de l'UI Windows échoue avec `native pipe is unavailable`. Les presets ont été générés par `EditorExportPlatformAndroid.create_preset()` et ses **183 options par défaut**, via un plugin temporaire retiré après génération, puis validés par les exports réels.
- Android exige l'import ETC2/ASTC et une icône : le réglage et une petite icône SVG technique originale ont été ajoutés.
- La surcharge du SDK cible est réservée au mode Gradle : elle reste vide pour l'APK précompilé (manifeste réel cible 36), et vaut 36 pour l'AAB.
- L'installation du template Gradle doit accompagner l'export : le script ajoute `--install-android-build-template` à cette invocation si le wrapper manque.
- Un daemon Gradle conservait les flux du wrapper console ouverts après la première compilation : seul le daemon du cache studio a été arrêté ; `org.gradle.daemon=false` dans ce cache corrige la réexécution finale. Les délais et l'arrêt de l'arbre des processus créés par les scripts sont bornés.
- SwiftShader provoquait des erreurs de shaders GLES3 et un écran noir : le backend `host` est validé sur ce poste. Aucun driver ni réglage Windows n'a été changé. Les essais échoués restent dans les artefacts locaux de diagnostic.

## Git, fichiers et secrets

Le dépôt local est sur `refs/heads/main`, sans remote, index vide et sans premier commit. Les contenus sélectionnables ont été examinés avant tout commit : instructions et documentation du studio, 85 skills et leur lock, notices Apache du catalogue, scripts et sources du projet. Les octets des copies de skills et des notices restent préservés par `.gitattributes` ; les textes du studio utilisent LF. Le sandbox exécute Git avec une identité différente du propriétaire du dossier : les contrôles utilisent une exception `safe.directory` limitée à chaque commande et à cette racine, sans exception globale persistante.

`.gitignore` exclut `tools/.local/`, modèles et caches, `.godot/`, sorties APK/AAB, `android/build/`, `.build_version` généré, secrets et clés mobiles. Le debug keystore créé par cette installation reste sous son `editor_data/` ignoré. Aucun keystore utilisateur préexistant ni clé release n'a été lu ou modifié. Le scan final des **296 fichiers candidats Git** n'a détecté aucun motif de secret ; **27/27 cas d'exclusion** sont conformes. Ce contrôle par motifs ne constitue pas une garantie exhaustive. Les empreintes des 80 skills tiers, les 85 frontmatters et les 13 fichiers YAML restent conformes. Les quatre scripts passent le parseur PowerShell, les textes sélectionnés sont en UTF-8 et les liens locaux contrôlés sont valides.

Fichiers créés ou modifiés pour cette phase :

- `.gitignore`, `.gitattributes`, `README.md`, `CHANGELOG.md` et le dépôt local `.git/`.
- `tools/Setup-Studio.ps1`, `Studio.Common.ps1`, `Studio.ps1`, `Start-StudioEmulator.ps1`, `tools/README.md`.
- `games/001-switchworks/project.godot`, `export_presets.cfg`, `scenes/verification.tscn`, `scripts/verification.gd` et son `.uid`, `tests/test_runner.gd` et son `.uid`, `icons/verification.svg` et son fichier `.import`, `README.md`.
- `platform/README.md`, `docs/decisions/README.md`, `docs/decisions/0001-socle-godot-mobile.md`, le présent rapport et les preuves sous `docs/recette/bootstrap-2026-11-14/`.
- Outils installés et données de travail sous `tools/.local/` et paquets ajoutés au SDK utilisateur, exclus du suivi Git.

Les empreintes et tailles des paquets locaux sont dans [packages.json](recette/bootstrap-2026-11-14/packages.json). APK final : **56 984 562 octets**, SHA256 `de19cccacb618b4c55db76964c0da07e2269dd55d7121e4d8e66dccc8a29aea0`. AAB final : **56 896 710 octets**, SHA256 `e0fc5eb78ebe7df48e0b9bc77c4b3d6e2ffaf4d50304c864d004d36a67dfa67b`.

## Limites et suite

La recette couvre une mire technique, Windows et un émulateur Android sur ce poste. Elle ne couvre pas un téléphone Android physique, ARM64 exécuté, plusieurs GPU, les tablettes, le lecteur d'écran, la rotation, les achats, les notifications, la sauvegarde durable, la performance/batterie ou la conformité juridique. Le backend hôte dépend du matériel disponible ; SwiftShader n'est pas validé ici. Les diagnostics natifs de surface et de cache restent à recontrôler sur la chaîne Android ciblée avant qualification de livraison.

L'AAB est **non signé** et n'a pas été installé via un jeu d'APK issu de bundletool. Aucune signature release, soumission Play Console, compte store ou dépense n'est configurée. L'alignement ZIP contrôlé ne certifie pas la conformité complète des bibliothèques natives aux pages 16 Ko.

Les modèles iOS sont présents dans l'archive exacte ; **aucun export, build, signature ou test iOS n'a été exécuté sur Windows**. La prochaine mise en place iOS devra utiliser macOS et Xcode conformément à la [documentation Godot](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html), puis des appareils ciblés.

Les prochaines décisions concernent le premier commit local, le cadrage produit et le périmètre jouable de SWITCHWORKS, puis les appareils physiques et la chaîne macOS. Toute publication GitHub reste soumise à l'autorisation du propriétaire. Les [commandes reproductibles](../tools/README.md) permettent de reprendre le travail sans réinstaller les outils contrôlés.
