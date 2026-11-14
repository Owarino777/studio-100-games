# Audit de l'environnement — 14 novembre 2026

## Verdict

**NON PRÊT pour développer, tester et publier des jeux Godot Android/iOS.** La structure et les skills sont exploitables. Godot et ses modèles d'export n'ont pas été trouvés, aucun projet moteur n'existe et Git n'est pas initialisé. Android est partiellement équipé ; l'export iOS exige un environnement macOS distinct.

Périmètre : `C:\Users\malik\Developpement\studio-100-games`, outillage accessible sur cet hôte Windows, documentation officielle consultée le 14 novembre 2026. Les outils portables placés dans des emplacements non examinés et les machines distantes ne sont pas exclus par cet inventaire.

La demande actuelle limite le travail à l'audit : les étapes de conception et d'implémentation du prompt de lancement n'ont pas été exécutées. Aucun projet de jeu, compte, dépôt distant, commit ou déploiement n'a été créé.

## Instructions et skills

Documents lus : `AGENTS.md`, `CODEX_PROMPT_DE_LANCEMENT.md`, README et modèles du kit ; routeur complet, sa référence de détection ; les cinq skills `studio-*` ; `godot-export` et sa référence d'export ; `godot-gdscript-headless-testing`.

| Contrôle | Résultat |
|---|---|
| Catalogue local | 85 dossiers physiques sous `.agents/skills/`, sans lien symbolique |
| Routeur | `router/SKILL.md` présent, dans le catalogue de la session et reconnu par le CLI |
| Skills personnalisés | `studio-product-discovery`, `studio-art-direction`, `studio-game-ux`, `studio-visual-qa`, `studio-mobile-release` : tous présents et détectés |
| YAML | 85 frontmatters et 13 fichiers `.yaml`/`.yml` analysés ; zéro erreur et zéro avertissement |
| Métadonnées | Noms conformes aux dossiers, descriptions non vides, zéro nom doublon |
| Lock | JSON v2 valide ; 80 entrées du catalogue toutes présentes ; 80 empreintes conformes |
| Origine locale | Les 5 skills `studio-*` sont hors lock, volontairement ; `untracked` dans ce CLI signifie hors lock skills, sans lien avec Git |
| Références du routeur | Les trois fichiers de référence déclarés existent |
| Cohérence | Aucun conflit bloquant trouvé dans les instructions et skills pertinents relus |

Le YAML a été validé avec le parseur `yaml` **2.9.1** déjà disponible dans le cache npm, avec vérification des clés uniques. Aucun paquet n'a été installé. Le CLI `skills list --json -a codex` retourne 85 éléments : 80 `tracked`, 5 `untracked`, aucun `modified` ou manquant. Les empreintes ont aussi été recalculées selon son algorithme de normalisation LF, chemin, longueur et contenu SHA256.

Les exigences des cinq skills locaux complètent celles du catalogue : recherche produit, art, ergonomie mobile, captures du build et release contrôlée. La règle d'un moteur du routeur s'applique au projet ciblé, conformément à sa référence monorepo ; elle n'impose pas un moteur commun aux 100 jeux. L'audit de cohérence ne certifie pas toutes les API et tous les exemples des 85 skills.

Limites conservées : `skills-lock.json` ne contient aucun commit amont ; ses empreintes attestent le contenu local, pas la révision historique d'installation. La référence `router/references/engine-detection.md:68` renvoie au §6 pour le fallback, situé au §7. Ce défaut éditorial amont n'a pas été corrigé dans la copie pour préserver son intégrité. Aucun deuxième routeur n'a été ajouté.

## Structure et nommage

Le monorepo contient `games/001-switchworks/README.md` avec un titre seulement. Aucun `project.godot`, scène, script de jeu, preset d'export, manifeste moteur, test de jeu ou pipeline CI n'a été trouvé hors exemples du catalogue. **Le moteur réel reste indéterminé** ; Godot est la cible de l'audit, pas un moteur déjà installé dans le dépôt.

Le nom `001-switchworks` respecte `NNN-slug`. L'inventaire initial ne relève ni espace, ni caractère non ASCII dans les noms, ni collision de casse ; longueur absolue maximale 131 caractères. Les conventions et rôles sont maintenant décrits dans le README racine. Les dossiers auparavant vides `shared/`, `platform/`, `tools/`, `docs/decisions/`, `docs/market-research/` possèdent un README pour être conservés dans un futur clone. `imports/` reste une zone locale ignorée, sans dépendance de build.

## Git et secrets

| Contrôle | Résultat |
|---|---|
| Dépôt local | Aucun marqueur `.git` à la racine ni imbriqué ; `git rev-parse --show-toplevel` échoue avec code 128 |
| Configuration locale | Indisponible faute de dépôt ; aucun index, branche active, historique ou remote vérifiable |
| Git / LFS | `2.56.0.windows.4` / `3.8.1` installés |
| Configuration héritée | Identité renseignée, branche initiale `main`, `core.autocrlf=true`, `pull.rebase=false` |
| Credentials / hooks | Gestionnaire standard ; aucun helper shell personnalisé, `core.hooksPath`, `core.attributesFile` ou `core.excludesfile` déclaré |
| Secrets présents | Scan initial des 257 fichiers puis scan final des 267 fichiers : zéro motif suspect |
| Ignore | 16 cas d'exclusion ou d'autorisation vérifiés avec un vrai Git temporaire : tous conformes |

Le scan lit tous les fichiers présents, sans exclusion de binaire. Il recherche noms sensibles, clés privées, tokens usuels GitHub/AWS/Google/OpenAI/Slack, JWT, affectations de secrets et URL avec identifiants. Les valeurs potentielles ne sont jamais affichées. Le scan final inclut les 267 fichiers, rapport compris, avec 9 contrôles positifs synthétiques du détecteur : zéro résultat. La lecture UTF-8 de tous les fichiers et les liens locaux de la documentation du studio contrôlée passent également sans erreur. Un scan par motifs ne constitue pas une preuve exhaustive d'absence de secret.

**L'absence de secrets versionnés n'est pas certifiable ici : aucun historique Git n'est disponible.** Aucun audit d'un éventuel dépôt distant indépendant n'a été réalisé. Aucune identité ni configuration globale n'a été modifiée. Il faudra choisir les attributs de fin de ligne avant le premier commit ; aucune normalisation de masse n'a été effectuée.

Les exclusions ajoutées couvrent `*.jks`, `*.key`, `*.p8`, `*.mobileprovision`, `*.provisionprofile`, `export_credentials.cfg`, `local.properties` et `/credentials/`. Les contrôles conservent l'ajout possible de `export_presets.cfg`, `.env.example` (racine et sous-dossier), `public.pem` et `README.md`. Un fichier exemple doit toujours être relu avant ajout.

## Outillage observé

| Élément | Version / état |
|---|---|
| Hôte | Windows NT `10.0.26300.0`, PowerShell `5.1.26100.9818` |
| Node / npm / Python | `24.16.0` / `12.2.2` / `3.14.6` |
| Godot | Non résolu sur PATH ; non trouvé dans le workspace ni les emplacements usuels examinés (Programs, WinGet, Downloads, Desktop) |
| Modèles d'export | Répertoires Godot utilisateur absents ; aucun modèle trouvé dans les emplacements examinés |
| Java | Temurin OpenJDK et `javac` `21.0.12.1` ; `keytool` présent |
| Android Studio | Répertoire de version `2026.1.4`, build `261.26222.65.2614.16204760` |
| SDK Android | `%LOCALAPPDATA%\Android\Sdk` |
| Plateformes SDK | 34, 35, 36 et `37.0` |
| Build-Tools | `35.0.0`, `36.0.0` |
| Outils CLI | `23.0` d'après `source.properties` |
| ADB | `37.0.1-15733141`, commande absolue fonctionnelle |
| NDK / CMake | `28.2.13676358` / `3.22.1` |
| Émulateur | `37.1.11` ; `-list-avds` vide malgré deux descriptions AVD Android 36 |
| Signature debug | Keystore debug présente ; contenu non lu |
| .NET | Runtime/host `6.0.16`, aucun SDK ; à compléter seulement si C# retenu |

`JAVA_HOME`, `ANDROID_HOME`, `ANDROID_SDK_ROOT`, `ANDROID_NDK_HOME` et les variables Godot examinées ne sont pas définies. `adb`, `sdkmanager`, `emulator` et `gradle` ne sont pas résolus sur PATH. Les trois premiers existent en chemin absolu. Ce constat ne justifie pas une modification globale du PATH : les chemins Java/SDK pourront être configurés dans Godot. Un Gradle global n'est pas nécessaire si le projet utilise un wrapper.

`sdkmanager --version` sort avec code 0, un avertissement de dépréciation et le texte `unknown (Android CLI)` ; la version 23.0 vient des métadonnées, pas de ce texte. Aucun émulateur ni serveur ADB n'a été démarré. La présence des fichiers AVD ne prouve pas leur fonctionnement. L'accès CIM aux informations système/GPU est refusé : renderer, accélération matérielle, RAM et compatibilité graphique non validés.

## Prérequis Godot et stores

La page officielle propose **Godot 4.7.2**, daté du 18 août 2026, cohérent avec la base annoncée des skills. Cette version constitue une proposition pour le futur projet ; aucun choix n'a été imposé ou installé. Il faudra l'éditeur et ses modèles strictement correspondants. [Téléchargement officiel](https://godotengine.org/download/windows/)

Pour Godot 4.7, la documentation Android recommande JDK 17 et accepte les versions supérieures. Elle liste Platform 35, Build-Tools **35.0.1**, NDK **28.1.13356709**, CMake **3.10.2.4988404** et les outils CLI. Les trois versions en gras manquent localement. Leur coexistence avec les versions actuelles sera préférable à leur remplacement ; la compatibilité effective reste à prouver par export. Un AAB nécessite le template Gradle et une signature release. [Export Android Godot 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html)

Google Play demande **API cible 36 au minimum** pour les nouveaux jeux mobiles et mises à jour depuis le 31 août 2026. La page Godot liste encore Platform 35 : il faudra vérifier le `targetSdk` du manifeste final et la compatibilité du template. API 36 est déjà installée. [Exigences Google Play](https://developer.android.com/google/play/requirements/target-sdk)

Prévoir l'inspection des bibliothèques natives et de leur alignement pour les pages mémoire de 16 Ko ; ni les plugins ni un paquet final n'existent encore pour ce contrôle. [Documentation Android 16 Ko](https://developer.android.com/guide/practices/page-sizes)

Pour iOS, Godot requiert **macOS, Xcode, les modèles d'export**, ainsi qu'un Team ID et un Bundle ID adaptés. Ce poste Windows ne peut pas valider ce parcours. [Export iOS Godot 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html)

App Store Connect exige **Xcode 26 ou supérieur et un SDK iOS 26 ou supérieur** depuis le 28 avril 2026 ; la page officielle indique aussi une cible minimale iOS 13 depuis le 9 septembre 2026. Vérifier à nouveau ces exigences au moment de la livraison. [Exigences Apple](https://developer.apple.com/news/upcoming-requirements/)

Accès aux comptes Play Console/Apple Developer, signatures release, profils de provisioning, sauvegardes de clés, appareils physiques et capacité de publication : **non vérifiés**. Aucun accès à ces comptes, achat ou création de clé n'a été entrepris. Les gates produit, art, UX, conformité, confidentialité, licences d'assets et politiques de monétisation seront évaluées sur le produit réel avant publication.

## Corrections et preuves

| Fichiers | Correction / vérification |
|---|---|
| `.gitignore` | Exclusions mobiles et configuration locale ; 16/16 cas Git conformes |
| `Installer-StudioKit.ps1` | Copie explicite des 5 skills locaux, 3 documents et 2 instructions ; sources prévalidées ; auto-destination refusée ; existants préservés |
| `README.md` | État réel, rôles, nommage, portée de l'installateur et du lock |
| `shared/README.md`, `platform/README.md`, `tools/README.md` | Rôles des dossiers réservés |
| `docs/decisions/README.md`, `docs/market-research/README.md` | Conventions et état des dossiers réservés |
| `docs/third-party/gamedev-skills/LICENSE`, `NOTICE`, `README.md` | Notices amont Apache-2.0 et attribution récupérées intégralement ; SHA256 consignés et vérifiés |
| `CHANGELOG.md` | Trace des corrections de cet audit |
| `docs/AUDIT_ENVIRONNEMENT_2026-11-14.md` | Présent état, preuves et limites |

L'ancien installateur aurait copié les 85 skills sans leur lock ni leurs notices. Sa portée est maintenant celle du kit complémentaire annoncé ; le catalogue s'installe séparément. Aucune copie du catalogue ni de `skills-lock.json` n'a été modifiée.

Tests de l'installateur dans des dossiers temporaires sous le workspace : parseur PowerShell sans erreur ; copie exacte de 10 fichiers par SHA256 ; uniquement 5 dossiers `studio-*` ; réexécution idempotente ; sentinelles de fichiers existants conservées ; destination source et kit incomplet refusés avant écriture. Un second contrôle indépendant confirme 7/7 assertions, y compris politique d'exécution persistante inchangée. Tous les dossiers de test ont été supprimés après vérification de leur chemin.

L'exécution directe des `.ps1` est bloquée par la politique `Restricted`. Les tests ont utilisé un sous-processus `powershell.exe -NoProfile -ExecutionPolicy Bypass`, après revue du code ; aucune politique globale n'a été changée. La copie manuelle documentée reste possible.

## Commandes exécutées et limites de validation

| Commande / méthode | Résultat observé |
|---|---|
| `rg --files --hidden`, `Get-ChildItem -Force -Recurse`, lectures `Get-Content -Encoding UTF8` | Instructions, arborescence et absence de fingerprint moteur établies |
| `node --version`, `npm.cmd --version`, `python --version`, `git --version`, `git lfs version` | Versions ci-dessus |
| `node <cache-npm>/skills/dist/cli.mjs list --json -a codex` | Code 0 ; 85 skills, 80 suivis par lock et 5 locaux |
| Here-string JavaScript via `node`, module npm `yaml` 2.9.1 existant | 98 documents/frontmatters YAML sans erreur ni avertissement ; noms et lock contrôlés |
| Recalcul SHA256 des dossiers selon le CLI installé | 80/80 empreintes conformes |
| `git rev-parse --show-toplevel`, `git config --local ...` | Code 128 : aucun dépôt local |
| `git config` avec lecture sélective et valeurs sensibles masquées | Configuration héritée décrite ci-dessus |
| Here-string Python de scan de fichiers et noms | Zéro résultat ; aucun fichier présent exclu du périmètre |
| `git init --bare <temp>`, `git -c core.bare=false --git-dir=<temp> --work-tree=<source> check-ignore --no-index` | Dépôt de test isolé, 16/16 cas ; aucun dépôt initialisé dans la source |
| `java -version`, `javac -version`, `dotnet --info`, `dotnet --list-sdks` | Java 21 présent ; aucun SDK .NET |
| Chemins absolus : `adb version`, `emulator -version`, `emulator -list-avds`, `sdkmanager --version` | Outils présents ; réserves AVD et CLI décrites ci-dessus |
| Lecture `source.properties` et `product-info.json` | Versions Android installées établies |
| `[System.Management.Automation.Language.Parser]::ParseFile(...)` | Zéro erreur de syntaxe de l'installateur |
| Tests temporaires de l'installateur et `Get-FileHash -Algorithm SHA256` | Copies fidèles, préservation et refus vérifiés |
| `Get-CimInstance` OS/GPU | Accès refusé ; contrôle non validé |
| Téléchargements HTTPS de `LICENSE` et `NOTICE` publics | Réussis ; empreintes dans le README tiers |

Le parseur YAML utilisé est à `C:\Users\malik\AppData\Local\npm-cache\_npx\ac0ed6aa23b37c1e\node_modules\yaml` et le CLI sous le dossier frère `skills`. Ces chemins décrivent la machine auditée ; ce ne sont pas des dépendances du monorepo ni une installation reproductible promise ailleurs.

Aucun import, runner, smoke test, export APK/AAB/iOS ou test de jeu n'a été exécuté : l'éditeur et le projet manquent. Aucun rendu ni UI n'a été modifié, donc aucune capture de jeu n'est fournie. Aucun test physique, de performance, d'achat, de notifications, de conformité juridique ou de soumission store n'est validé par cet audit.

## Prochaines actions recommandées

1. Choisir et documenter la version exacte de Godot et le langage, puis installer l'éditeur et ses modèles correspondants. GDScript n'exige pas le SDK .NET ; C# demandera son propre contrôle de compatibilité.
2. Compléter les paquets Android manquants pour la version choisie et configurer Java/SDK dans Godot ou un environnement local au projet, en préservant les installations utilisées par d'autres projets.
3. Diagnostiquer la découverte AVD, valider l'accélération et identifier au moins un appareil Android physique disponible.
4. Prévoir un Mac compatible Xcode et un appareil iOS ; établir ultérieurement comptes, identifiants et signatures hors dépôt.
5. Décider de l'initialisation Git locale et des fins de ligne avant tout premier commit. La destination GitHub et toute publication nécessitent une autorisation distincte.
6. Après autorisation de démarrer le jeu : fixer les critères d'acceptation, créer le projet, tester l'import headless, un runner qui échoue réellement, puis un export Android et une exécution sur cible. Traiter ensuite les gates de publication.

Les installations manquantes, la création du projet et la publication restent des actions à entreprendre ultérieurement ; aucune disponibilité complète n'est revendiquée.
