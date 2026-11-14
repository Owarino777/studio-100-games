# Intégrité de la passe ciblée — revue indépendante

14 novembre 2026. Audit technique en lecture seule, distinct de l'auteur des correctifs et de la QA artistique. Seul ce rapport est écrit par cet auditeur : aucun runtime, asset, index, configuration, branche, APK ou appareil n'est modifié. Aucun commit, accès distant ou push n'est effectué par cet audit.

## Référence et périmètre conservé

Au snapshot vérifié, la branche est `fix/archipel-postal-finition-p1-p2`, partie de `d36af097ff169a807639b6ce9c50a9149b91ba3e`. L'ancienne branche `feat/archipel-postal-vertical-slice` pointe toujours sur ce SHA ; `main` reste `68548a4b004a047e43d9ce0c77f248ffc07af23d`. Il s'agit d'un contrôle **avant commit des corrections**, pas d'une attestation de dépôt propre après livraison.

Comparaison Git contre `d36af097` : aucun changement des données de niveau, scripts du domaine, trois runners historiques (`test_runner.gd`, `slice_gameplay_runner.gd`, `slice_ui_runner.gd`), fichiers de mire d'origine, outils de racine, `platform/`, `shared/`, `.agents/` ou archives historiques. Les assertions des anciens runners ne sont donc pas supprimées pour faire passer cette passe. Les nouveaux contrôles et les différences de nombres d'itérations visibles sont détaillés dans [TESTS.md](TESTS.md).

`project.godot` conserve le démarrage de la mire et son override `archipel_slice`. Les quatre sections des deux premiers presets gardent exactement les mêmes clés et valeurs. Le preset de tranche change de sortie et de version, sans remplacer les anciens APK/AAB de vérification. Le modèle, la topologie, les ports et les règles ne sont pas déplacés dans l'animation.

Le moteur installé a été vérifié par commande : **`4.7.2.stable.official.ed1daf0bf`**. Les deux exécutables installés correspondent aux octets du ZIP officiel déjà en cache, dont le SHA512 correspond à celui figé par `Setup-Studio.ps1`. Aucune réinstallation, migration de moteur ou version bêta n'est introduite.

## Assets, provenance et licences

Les **cinq textures** gardent les tailles et SHA256 de leur manifeste. Les **17 fichiers suivis** des dossiers textures, fontes et notices, imports compris, sont inchangés contre `d36af097` après les filtres Git applicables. Le TTF Nunito Sans produit toujours le hash de blob déclaré dans `assets/fonts/SOURCE.json` ; l'OFL complet et les deux notices Godot sont conservés. Les géométries et paramètres de matériau modifiés sont du code local existant ; aucun nouveau PNG généré, pack, modèle tiers ou dépendance de jeu n'est ajouté.

Le [manifeste d'assets](../../assets/archipel/asset-manifest.json) décrit la révision de géométrie et conserve les conditions antérieures. La fonte est sous SIL OFL 1.1 ; les notices Godot ne donnent pas une licence générale aux autres ressources. Pour les trois PNG générés, **les conditions du fournisseur et les droits commerciaux restent à préciser et à valider humainement avant une diffusion commerciale**. L'audit constate leur provenance déclarée et leur conservation, sans certification juridique. La conservation privée des travaux n'est pas une autorisation de publication.

## APK final réellement inspecté

| Élément | Résultat observé |
|---|---|
| Fichier | `build/android/switchworks-archipel-polish-debug.apk` |
| Taille | **61 448 663 octets** |
| SHA256 | `6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965` |
| Package | `org.studio100games.switchworks.archipel.slice` |
| Version | `versionCode=6`, `versionName=0.1.1-polish.4` |
| Plateforme | Minimum API **24**, cible/compilation **36** ; `arm64-v8a` et `x86_64` |
| Type | `application-debuggable`, sans signature release revendiquée |
| Signature | `apksigner verify --verbose` : code 0, **v2 et v3 valides**, un signataire |
| Alignement ZIP | `zipalign -c -P 16 4` : code 0 ; ne certifie pas seul tous les segments ELF |
| Archive | CRC ZIP valide ; **48 entrées d'assets**, **8 remaps d'import** rapprochés de cibles présentes |
| Permissions | Aucune ligne `uses-permission` dans le badging observé |

Le JSON du niveau, l'OFL et les deux notices Godot sont présents **octet pour octet** comme leurs sources. La fonte est importée en `.fontdata`, ressource bien présente et référencée ; l'absence d'un TTF brut dans l'APK n'est pas un défaut d'emballage. Les remaps de textures/icônes présents ont leurs ressources importées correspondantes. Aucun chemin de tests, QA, outils, docs, credentials ou clé privée n'a été relevé dans les entrées APK. Cette vérification de noms et d'octets n'est pas une analyse de sécurité exhaustive du binaire.

L'APK d'origine est toujours distinct : `build/android/switchworks-archipel-slice-debug.apk`, **61 432 091 octets**, SHA256 `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1`. Les candidats intermédiaires archivés ne sont pas présentés comme l'APK final.

## Preuves et formats Git

Les **60 preuves historiques** gardent leurs SHA256. Les **32 sources runtime de cet ancien manifeste** sont vérifiées contre les blobs du commit `d36af097`, **pas contre les fichiers volontairement corrigés de la branche actuelle**. Les comparer au nouveau runtime ou réécrire l'ancien manifeste masquerait l'historique.

Sur le manifeste de la nouvelle passe au moment de cette revue : **121 copies de preuve, 40 snapshots runtime actuels et trois documents fournis**, soit **164 SHA256 bruts conformes**. Les reçus durables sont lus : **101/101 contrôles avant** et **113/113 après**, statuts `passed`, hashes d'APK cohérents et trois ratios consignés. **38 PNG Android** ont été lus au niveau de leur en-tête binaire : leurs dimensions correspondent aux dossiers 1080×2400, 720×1280 et 1200×1600. Ces contrôles ne sont pas une nouvelle exécution ADB par cet auditeur ni un jugement de beauté.

Une anomalie de clôture a été détectée : le nouveau snapshot inclut `assets/archipel/asset-manifest.json`, dont **206 CRLF** auraient été normalisés au staging et auraient invalidé son SHA après checkout. Le responsable a ajouté l'exception `-text` ciblée. **Recontrôle : 164/164 entrées produisent maintenant les mêmes blobs avec les filtres Git que depuis leurs octets bruts.** Les autres protections de preuves et de documents fournis restent présentes. Aucun contenu de preuve n'a été réécrit pour rendre ces contrôles favorables.

Les vidéos complémentaires, diagnostics dérivés et documents de clôture ajoutés après ce snapshot doivent être contrôlés dans la clôture du responsable. Les images en niveaux de gris ou montages comparatifs restent des dérivés d'analyse, à étiqueter séparément ; ils ne remplacent pas les PNG/MP4 natifs conservés.

## Secrets, configuration et périmètre de recette

Deux snapshots ont été scannés, sans afficher les valeurs : initialement **501 candidats / 438 textes**, puis **623 candidats / 514 textes UTF-8 ou UTF-16**, logs compris, après la première curation de preuves. Les motifs bruts et décodés du packager existant ne détectent aucun secret ni nom de candidat sensible. **Neuf probes d'exclusion passent 9/9**, notamment `.pem`, `.aws`, `.ssh`, `.codex`, `.credentials`, credentials Godot, APK, artefacts et outils locaux. Un remote existe sans motif d'identifiants ou paramètres secrets dans son URL ; aucun `core.hooksPath` personnalisé n'est relevé. Identités auteur/committer disponibles, sans affichage de leurs valeurs ni modification de configuration.

`capture_polish_android.py` passe l'analyse AST. Il réutilise le helper existant : **ADB 5041**, **emulator-5580**, identité **Studio_API_36** vérifiée avant mutation. Le package de l'APK et l'activité résolue doivent correspondre au seul package de tranche. Les changements de taille d'affichage concernent cet AVD ; la taille/override initial est lu puis rétabli. Installation et force-stop ciblent le seul package expérimental. La sauvegarde lue est celle de ce package via `run-as` et chemin contrôlé ; pas de `pm clear`, désinstallation, commande de push distant, service de compte ou analytics ajouté par cet outil. Les remises à zéro du niveau passent par ses commandes UI pour la recette.

Un point de robustesse de l'outil a été signalé puis corrigé : l'attente de fin d'enregistrement était placée avant le bloc de restauration de l'affichage. Le nettoyage est désormais dans des `try/finally` imbriqués ; un délai dépassé tente de terminer uniquement le sous-processus d'enregistrement de cette invocation et conserve la tentative de restauration et l'écriture du reçu. Le chemin normal est exercé par la recette ; **le cas d'un enregistreur volontairement bloqué n'a pas été provoqué** et n'est pas inventé comme test réussi.

## Limites et clôture avant commit

Les scans par motifs ne démontrent pas une absence exhaustive de secrets, particulièrement dans des formats compressés, encodés ou propriétaires. La présence d'architectures ARM64 et x86_64, une signature debug valide et l'alignement ZIP ne prouvent ni l'usage sur téléphone physique, ni l'iOS, ni une aptitude aux stores. La validation des licences commerciales, les avis de joueurs et les critères artistiques restent séparés. Les logs bruts de poste sont des preuves internes ; ils n'ont pas à accompagner un dossier artistique destiné à une diffusion plus large.

Le responsable doit encore scanner le contenu **staged final**, vérifier les nouvelles preuves ajoutées après ce snapshot depuis l'index puis depuis un checkout réel, effectuer le commit local autorisé et confirmer arbre propre, `main` et ancienne branche inchangés. Aucun push ou déploiement n'est autorisé par ce contrôle. **Avis d'intégrité : favorable à la clôture locale sous ces derniers contrôles ; statut produit TEST / HOLD inchangé.**

Commandes locales exécutées : requêtes Git `status`, `diff`, `rev-parse`, `config`, `var`, `check-ignore`, `hash-object` sans écriture ; lectures SHA/ZIP avec Python standard ; version du moteur ; `aapt dump badging`, `apksigner verify --verbose` et `zipalign -c -P 16 4` depuis le SDK existant. Aucun outil réinstallé et aucune commande ADB supplémentaire par cet auditeur.
