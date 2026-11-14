# Sécurité et conservation de la référence locale

Audit du **14 novembre 2026**, avant staging et commit de stabilisation. Relecture technique distincte de l'audit artistique ; aucune validation juridique ou commerciale n'en est déduite. Cet auditeur n'a modifié ni runtime, ni assets, ni index Git, ni branche, ni configuration du poste. Seul ce rapport est écrit.

## État Git vérifié

- Branche : `feat/archipel-postal-vertical-slice`.
- HEAD et `main` au début de l'audit : `68548a4b004a047e43d9ce0c77f248ffc07af23d`. La branche n'a pas d'upstream configuré.
- Instantané initial : **463 fichiers candidats**, dont **122 nouveaux fichiers** totalisant 40 448 066 octets ; trois fichiers existants du jeu modifiés. Les rapports de stabilisation et le futur kit viennent ensuite s'ajouter à cet instantané.
- Identités effectives auteur et committer disponibles dans le contexte du propriétaire, sans créer d'identité locale et sans en afficher les valeurs. `core.autocrlf=true` est hérité ; aucun `core.hooksPath`, hook actif local, clé de signature ou `commit.gpgsign` configuré n'a été relevé.
- Un remote est configuré ; sa valeur n'a pas été affichée. Aucune URL avec mot de passe ou paramètres de requête détectée. Aucun accès distant, commit ou push par cet audit.
- Comparaison avec le parent : outils racine, `platform/`, `shared/`, `.agents/`, lock des skills et fichiers originaux de mire/tests/icône inchangés. Les **14 empreintes historiques** fournies restent exactes. `git diff --check` ne signale pas d'erreur de whitespace dans les modifications suivies ; les avertissements CRLF/LF ont été examinés séparément ci-dessous.

## Secrets et exclusions

Le scan de l'instantané porte sur **463 candidats**, avec détection brute et **408 textes décodés UTF-8 ou UTF-16**, logs compris. Aucun motif usuel de clé privée, token, URL avec identifiants ou affectation littérale sensible n'a été détecté ; aucun nom sensible candidat n'a été relevé. Les valeurs éventuellement détectées ne seraient pas imprimées. Ce scan ne démontre pas une absence exhaustive de secrets, notamment dans les formats comprimés, encodés ou propriétaires.

Une faiblesse locale a été identifiée dans `.gitignore` : `.pem`, `.aws`, `.ssh`, `.codex` et `.credentials` n'étaient pas couverts par Git, même si le packager les excluait. Le responsable a ajouté ces exclusions. Le recontrôle de **cinq chemins témoins passe 5/5**. Les exclusions existantes de keystores, credentials Godot, APK, build, artefacts et caches restent actives ; fonte, données JSON et preuves sélectionnées restent versionnables. Aucun fichier existant n'a été retiré.

Le plus gros nouvel élément à l'instantané est la vidéo de preuve, **3 428 103 octets**. Les binaires moteur/SDK, APK, ZIP de livraison et caches restent ignorés. Aucun gros binaire d'outillage ou paquet généré superflu n'est candidat au commit. Les captures de plusieurs formats et les logs conservés sont des preuves de recette, pas des assets embarqués.

## Préserver les octets lors du commit

Le contrôle `git hash-object --path=<chemin> <chemin>`, sans `-w` et sans modification de l'index, a révélé une seconde anomalie : la règle générale `* text=auto eol=lf` changerait les octets de **11 des 60 preuves** et de **5 des 32 sources gelées** recensées par le manifeste. Les SHA256 conservés seraient alors faux après checkout, même si le comportement des textes normalisés restait équivalent.

Les sources concernées sont `data/archipel_double_flux.json`, `assets/archipel/textures/paper_fibres.svg`, `assets/archipel/textures/porcelain_micro.svg`, `assets/fonts/SOURCE.json` et `export_presets.cfg`, dans le jeu. Les preuves concernées incluent des reçus/snapshots JSON et deux logs. Il faut préserver ces octets avec des exceptions `-text` ciblées et protéger de même les nouveaux dossiers de preuves munis d'empreintes. Les images, vidéos et tests n'ont pas à être réécrits.

Le responsable a corrigé `.gitattributes` avec `-text` pour le dossier de preuves et ces cinq chemins exacts, ainsi que pour les futurs dossiers `review-kit/` et `video-evidence/`. **Recontrôle exécuté : 60/60 preuves et 32/32 sources gelées produisent désormais les mêmes blobs avec ou sans filtres Git ; leurs 92 SHA256 restent conformes.** Aucun octet runtime n'a été modifié pour cette correction. La vérification du contenu réellement staged reste la dernière étape du responsable avant commit.

## Assets et licences

Les cinq textures sources correspondent aux tailles et SHA256 du manifeste. Le fichier Nunito Sans correspond au hash de blob Google Fonts déclaré ; l'OFL complet est présent. Les deux notices Godot sont conservées avec provenance et empreintes. Les 80 skills tiers sont accompagnés des textes Apache-2.0 et NOTICE ; ces textes ne donnent pas une licence aux cinq skills locaux ni aux jeux du studio. Ce catalogue reste inchangé dans cette phase.

Les géométries/SVG/code/sons sont déclarés comme créations du projet ; aucun pack commercial ou modèle concurrent n'est ajouté par la tranche. Pour les trois PNG générés, les prompts et fichiers d'origine sont conservés, mais la mention **« provider terms apply; commercial rights review pending »** ne constitue pas une licence commerciale définitivement vérifiée. Une validation humaine des droits, des conditions applicables au compte et de la portée de diffusion reste nécessaire avant une exploitation commerciale ou redistribution publique. Cela ne bloque pas la conservation privée du travail dans un commit local.

Le kit externe doit rester une sélection de PNG/MP4 et de documents de revue, sans clés, comptes, journal brut de poste ou ZIP source complet. Les originaux internes restent conservés. Les chemins personnels présents dans certains logs techniques n'ont pas à être transmis pour une appréciation artistique.

## Paquets et preuves rapprochés des sources

| Élément préexistant | Résultat vérifié dans cette phase |
|---|---|
| APK debug | 61 432 091 octets ; SHA256 `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1` ; CRC ZIP valide |
| Ancien ZIP sources de livraison | 69 413 957 octets ; SHA256 `2e4e7d68dd392690da625bdb6a116541053d2d83db0b8ac412e52eb4fa4b3cb9` ; CRC ZIP valide ; snapshot de la phase précédente, sans prétendre inclure les nouveaux rapports |
| Manifeste de preuve | **60/60 copies** et **32/32 sources runtime** correspondent encore aux SHA256, avant traitement Git |
| Données/notices dans APK | JSON du niveau, OFL et notices Godot présents octet pour octet comme les sources |
| Contenus exclus de l'APK | Aucun nom de test, outil, QA, credential ou clé détecté dans les entrées ZIP |

Les signatures v2/v3 et l'alignement de l'APK avaient été vérifiés dans la recette conservée ; leur résultat n'est pas présenté comme une nouvelle exécution par cet audit. Le paquet est debug, sans signature release revendiquée. Le moteur n'a pas été reconstruit et la recette artistique n'est pas déduite de ces contrôles d'intégrité.

## Clôture nécessaire par le responsable

1. Corrections locales réalisées : `.gitignore` renforcé et `.gitattributes` ciblé ; cinq probes sensibles ignorées et **92/92** entrées de manifeste préservées. `main` reste au SHA initial.
2. Terminer le kit léger et les rapports, puis scanner le contenu staged final, avec les nouveaux fichiers inclus explicitement.
3. Effectuer le commit local autorisé sur la branche dédiée, vérifier son arbre et les preuves depuis les blobs committés ; confirmer `main` inchangé et l'état propre du dépôt.
4. Conserver séparément les décisions artistiques humaines encore ouvertes. Aucun passage de tests ne vaut acceptation de la direction artistique.

Les commandes utilisées sont des requêtes locales Git (`status`, `diff`, `rev-parse`, `config`, `var`, `check-ignore`, `hash-object` sans écriture), des lectures ZIP/SHA256 et des scans Python stdlib réutilisant les motifs du packager existant. Aucun outil réinstallé, aucun secret ou clé privé consulté, aucun service distant utilisé. SWITCHWORKS reste **TEST / HOLD**.
