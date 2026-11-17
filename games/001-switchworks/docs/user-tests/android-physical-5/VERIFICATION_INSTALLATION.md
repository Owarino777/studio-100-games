# Vérification de l'APK destiné au test physique

**14 novembre 2026 — contrôle technique local, sans installation sur téléphone et sans résultat humain.** La décision du propriétaire autorise la préparation des tests Android physiques ; l'acceptation artistique finale et commerciale reste HOLD.

La [revue externe finale](../../polish/REVUE_EXTERNE_FINALE_2026-11-14.md), fournie après le premier inventaire, a été lue intégralement. Elle autorise une campagne exploratoire sur appareils physiques et maintient HOLD pour l'art final, le contenu et la commercialisation. Son jugement porte sur des médias : elle ne prétend pas avoir installé l'APK ou exécuté les tests automatisés. Ce contrôle complète seulement les prérequis techniques de cette campagne.

## Référence effectivement vérifiée

| Élément | Observation locale |
|---|---|
| Branche | `fix/archipel-postal-finition-p1-p2` |
| HEAD conservé | `108e2b04a3109f8f67d00a65caf0d60d7f1c979e` |
| APK existant | `build/android/switchworks-archipel-polish-debug.apk` |
| Taille | **61 448 663 octets** |
| SHA256 | **`6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965`** |
| Package | `org.studio100games.switchworks.archipel.slice` |
| Version | `versionCode=6`, `versionName=0.1.1-polish.4` |
| API minimum / cible | **24 / 36**, compilation API 36 |
| Graphisme déclaré | **OpenGL ES 3.0**, valeur `0x30000` |
| Architectures | `arm64-v8a` et `x86_64` ; la présence de x86_64 ne transforme pas un émulateur en test physique |
| Type | APK **debuggable**, aucune signature de release revendiquée |
| Signature | `apksigner verify --verbose --print-certs` : code 0, schémas **v2 et v3 valides**, un signataire |
| Certificat public SHA256 | `20c3cd58cdb9597430c71070dcf5bdcd71ee55efe29c427a8bf6cfb1c0afdd40` |
| Archive | CRC ZIP valide ; `zipalign -c -P 16 4` : code 0 |
| Permissions dans le badging | Aucune ligne `uses-permission` observée |

Les deux bibliothèques ARM64 embarquées, `libc++_shared.so` et `libgodot_android.so`, sont des **ELF64 AArch64**, `e_machine=183`. Chacune possède trois segments `PT_LOAD` avec alignement d'au moins 16 Kio et congruence adresse virtuelle/offset à 16 Kio. Cette lecture structurelle ne constitue pas un test sur Android physique à pages de 16 Kio, ni une certification de distribution.

Les outils déjà présents ont été réutilisés : Build Tools **36.1.0**, `aapt`, `zipalign`, `apksigner.jar` et JDK **21.0.12**. Aucun moteur, SDK ou outil n'a été réinstallé ; aucune clé privée n'a été ouverte ou affichée. Aucun accès ADB n'a été effectué par cet auditeur. L'inventaire initial de l'agent principal sur le serveur 5037 ne listait aucun appareil ; ce constat doit être rafraîchi au moment du branchement.

## Conditions à vérifier sur le téléphone

- Sélection explicite du numéro de série pour toute installation ou ouverture. Une liste vide, plusieurs appareils sans choix, `offline` ou `unauthorized` ne constitue pas un appareil prêt.
- Téléphone réellement physique identifié par l'opérateur ; rejeter les séries `emulator-*` et les indicateurs qemu/ranchu/goldfish. Ces propriétés sont un filtre technique, pas une preuve physique infaillible sur une ROM modifiée.
- `ro.product.cpu.abilist` doit contenir `arm64-v8a`, API Android au moins 24 ; vérifier également la déclaration GLES du téléphone et confirmer le vrai rendu après lancement. ARM64 et API seuls ne prouvent pas la qualité du pilote GPU.
- Pour USB, le propriétaire du téléphone effectue lui-même les autorisations nécessaires. Le script ne doit ni accepter une empreinte RSA à sa place, ni modifier les réglages de sécurité.
- Contrôler visuellement après lancement : scène Archipel Postal, objectif A → A / B → B, préparation neuve, commandes et marges. Le lancement technique est une vérification d'installation, **pas la réussite d'une tâche par un joueur**.

## Gardes à conserver dans l'aide d'installation

Le hash et le package doivent correspondre à cet APK avant toute mutation. Le mode inspection reste distinct du mode installation. Une installation de mise à jour emploie le seul package prévu et préserve ses données ; ne pas ajouter de `pm clear`, désinstallation, changement de taille/densité ou commande touchant un autre paquet.

Si une version installée est supérieure au code 6, arrêter et laisser le propriétaire arbitrer : ne pas forcer un downgrade. Si Android refuse une signature de mise à jour (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`), conserver l'application et ses données ; ne pas désinstaller automatiquement pour contourner le refus. Une erreur de stockage, pilote, câble, autorisation ou compatibilité doit rester un blocage explicite avec son message, sans être convertie en succès.

La relecture de [l'aide d'installation](../../../tools/install_physical_android.py) confirme la vérification de l'APK installé par `pm path` et son SHA256 distant, avant ouverture et après installation. Un code de version 6 ne suffit pas à identifier les octets du build. Le chemin distant doit désigner un seul `base.apk` attendu, sans traversée ni métacaractère ; splits, version illisible ou empreinte inaccessible conduisent à un refus explicite. L'activité à ouvrir est également bornée au composant connu. Ces chemins physiques restent non exercés faute de téléphone connecté.

## Contrôle indépendant des gardes, avec simulation explicite

**18 cas ont été exécutés en mémoire**, en remplaçant les appels natifs par des réponses contrôlées : appareil unauthorized ; série d'émulateur ; indicateur qemu ; ABI non ARM64 ; API 23 ; GLES 2 ; métadonnées compatibles sans numéro brut dans leur dictionnaire ; package absent ; chemin distant avec métacaractère ; chemins split ; version non lisible ; checksum mal formé ; identification du package exact ; refus d'ouverture d'un même code 6 avec un autre hash ; refus du code installé 7 avant installation ; refus d'un autre composant avant `am start` ; conservation d'une erreur d'installation écrite sur stdout ; refus d'une résolution d'activité vide sans tentative d'ouverture.

Résultat du contrôle de gardes : **18/18**, aucune commande ADB exécutée par ce contrôle, aucune installation et aucun résultat humain. Les sorties d'erreur sont aussi relues pour que les reçus privés ne réintroduisent pas le numéro de série brut. Ce contrôle ne certifie pas les particularités d'un constructeur, la lisibilité réelle de `base.apk` sur toutes les versions Android ou le bon rendu d'un téléphone.

Avant chaque participant, le modérateur utilise la commande **Recommencer** du jeu pour retrouver le même état initial et vérifie les compteurs. Il ne faut pas distribuer une préparation déjà résolue, ni compter comme découverte autonome une solution fournie par le modérateur.

## Limites

L'APK n'a pas été installé ou lancé sur un téléphone ARM64 par cet audit. Le confort tactile, les erreurs de doigt, les safe areas réelles, les performances, la batterie, l'audio, le plaisir et la compréhension de cinq joueurs restent **non évalués**. Aucun commit, changement de branche, push ou publication n'est effectué. Le jeu et sa référence restent inchangés.
