# Plateformes mobiles

La mise en place initiale concerne Godot **4.7.2 stable Standard**, GDScript typé, Android depuis Windows puis iOS depuis macOS ultérieurement. Le [rapport d'audit initial](../docs/AUDIT_ENVIRONNEMENT_2026-11-14.md) reste un état historique ; les résultats opérationnels sont consignés dans la recette de mise en place.

## Android sur Windows

La [documentation Godot 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html) recommande JDK 17 et accepte une version supérieure. Le JDK Temurin 21 présent est réutilisé. La chaîne documentée comprend Platform 35, Build-Tools 35.0.1, NDK 28.1.13356709 et CMake 3.10.2.4988404 ; Platform-Tools doit être au moins 35. Le `config.gradle` du template officiel 4.7.2 demande en pratique compile/target SDK 36 et Build-Tools 36.1.0 : Setup et Doctor contrôlent donc aussi ces versions. Ce même fichier déclare NDK 29.0.14206865 ; aucune compilation native du moteur n'est entreprise avec les AAR précompilés, et l'export réel reste la preuve de compatibilité. Les versions plus récentes déjà installées sont conservées côte à côte. Android Studio et Android CLI existants sont réutilisés.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Setup-Studio.ps1 -InstallAndroidPackages
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action Doctor
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action ExportAndroid -Format apk
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Studio.ps1 -Action ExportAndroid -Format aab
```

Les scripts ne modifient ni PATH global ni préférences d'autres installations Godot. Android CLI fonctionne sans collecte de métriques et avec `--ignore-outdated-xmls` pour préserver les métadonnées anciennes des autres paquets. En cas de licence manquante, examiner et accepter les conditions dans l'outil officiel avant de relancer ; aucune réponse affirmative automatique n'est injectée.

Le projet contient les presets **Android APK** et **Android AAB**. Les sorties sont des **paquets debug de vérification**, pas des livrables de store. L'APK est signé avec une clé debug locale ; l'AAB compilé dans cette recette est non signé. Le format AAB utilise le template Gradle local du projet ; aucun Gradle global n'est requis. Les tests et journaux doivent être relus avant de considérer un export réussi. L'installation et le rendu sur cible constituent une vérification distincte.

Les commandes d'émulation isolée sont fournies dans `tools/Start-StudioEmulator.ps1`. L'AVD `Studio_API_36`, son GPU `host` et le port ADB 5041 ont été vérifiés sur ce poste. SwiftShader a échoué à compiler les shaders GLES3 ; il ne faut pas déclarer ce backend opérationnel ici. Ne pas modifier les AVD utilisés par d'autres projets. La présence d'une image SDK ne prouve pas le démarrage ni le rendu du jeu ; les preuves sont dans la [recette](../docs/RECETTE_BOOTSTRAP_2026-11-14.md).

Avant publication, contrôler l'API cible réelle du manifeste, les signatures, l'architecture, les bibliothèques natives et les règles courantes de Google Play. Platform 35 demandé par la page d'export ne remplace pas les exigences de soumission. [Exigences Google Play](https://developer.android.com/google/play/requirements/target-sdk)

## iOS ultérieurement

L'export iOS nécessite macOS, Xcode et les modèles de la même version de Godot. L'accès à un Mac, aux comptes développeur, aux appareils et aux profils de signature n'est pas établi sur ce poste Windows. Aucune recette iOS n'est revendiquée. [Documentation Godot iOS](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html)

Les réglages propres à un jeu restent dans son dossier. Les clés de signature release et identifiants privés doivent rester hors du dépôt, avec sauvegarde sécurisée. Aucun certificat, compte store ou paiement n'est créé par ces scripts.
