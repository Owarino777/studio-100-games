# Outils du studio

Scripts Windows PowerShell 5.1, à exécuter depuis n'importe quel dossier. Les exemples ci-dessous partent de la racine du monorepo. Les outils téléchargés et leurs caches restent dans `tools/.local/`, exclu de Git.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Setup-Studio.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Setup-Studio.ps1 -InstallAndroidPackages
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Doctor
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Import
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Test
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Run
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action ExportAndroid -Format apk
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action ExportAndroid -Format aab
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Start-StudioEmulator.ps1 -Action Start
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Start-StudioEmulator.ps1 -Action Status
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Start-StudioEmulator.ps1 -Action Stop
```

`Bypass` s'applique uniquement au nouveau processus pour exécuter ces scripts locaux relus ; aucune politique PowerShell persistante n'est modifiée. L'appel direct `./tools/Studio.ps1` convient sur une machine dont la politique autorise déjà les scripts.

`Setup-Studio.ps1` installe Godot **4.7.2 stable Standard** et les modèles exacts depuis la release officielle `godotengine/godot-builds`. Il contrôle les SHA512 du manifeste officiel et les empreintes attendues consignées dans le script avant extraction. Il réutilise les fichiers en cache et saute les installations déjà présentes, vérifie la version par une commande exécutée et refuse une installation de modèles incomplète. Le marqueur `_sc_` isole les préférences dans `editor_data/`.

Le SDK Android est détecté depuis `ANDROID_HOME`, `ANDROID_SDK_ROOT`, puis `%LOCALAPPDATA%/Android/Sdk` ; le JDK vient de `JAVA_HOME` s'il contient un compilateur, puis de `javac` sur PATH. Les paramètres `-AndroidSdkPath` et `-JavaSdkPath` permettent des emplacements explicites. Ces chemins sont enregistrés uniquement dans les préférences Godot portables ignorées par Git.

`-InstallAndroidPackages` utilise Android CLI 23 déjà installé et n'ajoute que les paquets manquants. Il conserve les autres versions, n'accepte aucune licence automatiquement et n'active ni bêta ni canary. Les détails et limites Android sont dans [platform/README.md](../platform/README.md).

`Studio.ps1` vérifie le binaire exact, importe le projet avant les tests/exports, impose un délai maximal aux processus et refuse les logs contenant des erreurs Godot même avec un code zéro. `Doctor` retourne un code non nul si un prérequis contrôlé manque. Les logs sont dans `games/001-switchworks/artifacts/logs/` ; les paquets de vérification debug dans `games/001-switchworks/build/android/`.

Le contrôle volontaire du runner doit échouer avec le code **1** :

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Test -ForceTestFailure
```

Son log distinct est `tests-failure-control.log`. Une exécution normale doit produire `BOOTSTRAP_TESTS passed=36 failed=0` et le code zéro. `Run` ouvre le projet minimal jusqu'à fermeture de la fenêtre.

Les processus Godot utilisent un `APPDATA` local pour leurs données de test ; les caches Gradle et Android utilisateur sont également locaux au studio. Les exports imposent `org.gradle.daemon=false` uniquement dans `tools/.local/gradle/gradle.properties`, pour éviter qu'un daemon conserve les flux de sortie ouverts. Un dépassement de délai arrête uniquement l'arbre du processus lancé par le script, identifié par son PID ; aucun processus Java externe n'est recherché ou arrêté. Le PATH et les variables persistantes de Windows ne sont pas modifiés. Aucune commande ne publie de paquet, ne crée de compte ou ne configure une signature release.

L'installateur du kit complémentaire `Installer-StudioKit.ps1` reste à la racine ; son rôle est distinct de l'installation du moteur et du SDK.

## Exécution Android après export

Le script d'émulation crée l'AVD `Studio_API_36` dans les fichiers locaux du studio en réutilisant l'image Android 36 déjà installée. Le backend par défaut est `host`, validé sur ce poste NVIDIA ; le premier démarrage peut prendre quelques minutes. `-Gpu swiftshader` reste une option de diagnostic, mais a échoué au rendu Godot sur ce poste. Le script ne modifie pas les AVD existants et utilise ADB sur le port 5041.

Après `ExportAndroid -Format apk` et `Start-StudioEmulator.ps1 -Action Start` :

```powershell
$studioAdb = Join-Path $env:LOCALAPPDATA 'Android/Sdk/platform-tools/adb.exe'
& $studioAdb -P 5041 -s emulator-5580 install -r games/001-switchworks/build/android/switchworks-verification-debug.apk
& $studioAdb -P 5041 -s emulator-5580 shell am start -W -n org.studio100games.switchworks.verification/com.godot.game.GodotAppLauncher
```

Adapter `$studioAdb` si un chemin SDK explicite a été choisi. Fermer uniquement l'émulateur du studio avec `-Action Stop` après la recette. Les captures, métadonnées et résultats réellement observés sont dans la [recette du socle](../docs/RECETTE_BOOTSTRAP_2026-11-14.md).

L'APK est signé avec la clé **debug locale** générée par Godot. L'AAB de cette recette est compilé mais **non signé** ; aucune signature release n'est configurée. Les deux sorties servent à vérifier la chaîne, et ne sont pas des paquets à soumettre aux stores.
