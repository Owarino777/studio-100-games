# SWITCHWORKS — export Web de test pour iPhone Safari

14 novembre 2026. **Vrai jeu Godot exporté et exécuté, pas maquette HTML.** Branche `test/archipel-postal-web-iphone` depuis `108e2b04a3109f8f67d00a65caf0d60d7f1c979e`. La branche de finition reste à cette référence et `main` à `68548a4`. Les préparatifs Android non suivis ont été conservés, sans reset/stash. Aucun niveau, règle, donnée de plateau, texture ou identité Archipel Postal n'est remplacé.

## Accès et autorisation

**https://drops-discover-bicycle-wear.trycloudflare.com/** — utilisateur `studio`, mot de passe temporaire transmis séparément au propriétaire et conservé uniquement dans un fichier local ignoré. [Accès et arrêt des processus](ACCESS.md).

Le propriétaire a autorisé explicitement ce tunnel temporaire protégé, après préparation du build. Seuls les neuf fichiers clients Godot sont servis. Les sources du dépôt, les APK, clés et profils ne sont pas exposés. Aucun GitHub, store, compte Cloudflare, abonnement ou dépense n'est créé. Les certificats locaux préparés sont utilisés seulement pour vérifier le lien serveur d'origine ; **aucune confiance système ou profil iPhone, aucune règle de pare-feu n'a été installée**.

Le PC et les processus possédés doivent rester actifs. Cette URL est temporaire, sans garantie de disponibilité et change après recréation ; l'origine doit être consignée pour interpréter la sauvegarde. Ce n'est pas un hébergement de production.

## Compatibilité vérifiée

Le binaire réellement utilisé est **Godot 4.7.2.stable.official.ed1daf0bf Standard**, GDScript typé. Les modèles Web correspondants étaient déjà installés. Le projet était déjà en Compatibility ; l'export produit WebAssembly et WebGL 2.0.

Preset ajouté `Web Safari Test` : `archipel_slice,web_test`, `variant/thread_support=false`, extensions désactivées, PWA désactivée, textures desktop/mobile activées. Les trois presets existants sont conservés octet pour octet. Le HTML confirme `GODOT_THREADS_ENABLED=false` et aucune isolation cross-origin n'est nécessaire pour ce build sans threads. Le WASM est identique au modèle officiel local `web_nothreads_release.zip`.

L'[export et son pack réellement servi](EXPORT.md) terminent avec code 0 et `SLICE_READY`, sans erreur détectée. Le pack n'est pas remplacé par un `--export-pack` secondaire. Le shell est une adaptation minimale du HTML officiel : canvas et `engine.startGame()` conservés, langue française et `viewport-fit=cover`, pas de page vitrine. Le titre Web est distinct du nom de mire natif.

Artefacts courants : neuf fichiers, WASM **39 514 754 octets**, PCK **4 529 052 octets**, PCK SHA256 **`5ba7b0e797f60642cdd9fb458338a395a13510c27ef0485ff9298041212f8da6`**. [Manifeste d'export](evidence/export/web-files.json). Le serveur utilise le bon MIME `application/wasm` et gzip pour les transferts ; le proxy peut omettre la longueur HTTP, aucune taille comprimée fictive n'est annoncée.

## Contrôles exécutés, sans équivalence fictive avec iOS

| Contexte | Résultat et limite |
|---|---|
| CLI Godot / pack exporté | Export release et smoke du pack : codes 0, vraie scène démarrée |
| Compilation / suites natives | 13 scripts, 0 cassé ; 36/0 bootstrap, 137/0 modèle, 471/0 UI, 1758/0 états. Les branches non-Web restent couvertes dans ce périmètre |
| Chrome Windows, 393×852 CSS, DPR 3 | [Chargement, toucher, erreur/réparation, réception, rechargement et redémarrage complet](evidence/https-pro/receipt.json) exécutés via le vrai HTTPS ; 11 contrôles réussis |
| Chrome Windows, 430×932 CSS, DPR 3 | [Contrôles équivalents](evidence/chrome-max/receipt.json) sur loopback ; 10 contrôles réussis |
| Chrome Windows paysage, 852×393 CSS, DPR 3 | [Contrôles équivalents](evidence/chrome-landscape/receipt.json) sur loopback ; 10 contrôles réussis |
| Suspension de page | Le headless ne masquait pas réellement l'onglet à `bringToFront` ; la limitation est enregistrée. Les callbacks blur/focus sont testés par événements navigateur synthétiques. **Ce n'est pas un Home physique iOS** |
| Sauvegarde | Un toucher produit exactement une rotation ; le vrai rechargement puis la fermeture et réouverture du profil de navigateur isolé retrouvent compteurs et empreinte des ports. Pas d'accès à une API privée de FS |
| HTTPS et authentification | 401 anonyme, 200 authentifié ; neuf SHA de fichiers servis conformes. Clés, `.import`, configuration/source et chemins hors allowlist refusés ; TLS d'origine vérifié par CA explicite |

Les profils Chrome sont isolés sous `artifacts/`, pas le profil personnel de l'utilisateur. Ce sont des **exécutions WASM réelles avec viewport et toucher émulés**, pas Safari ou WebKit sur iPhone. L'agent a ouvert les captures, notamment après correction des glyphes. Le premier chargement HTTPS Chrome observé était d'environ dix secondes ; ce nombre n'est pas un temps iPhone ni une garantie réseau.

Les PNG sont des captures du navigateur exécutant le moteur. [Préparation](evidence/https-pro/planning.png), [reprise après reload](evidence/https-pro/restored.png), [erreur](evidence/https-pro/failed.png), [réussite](evidence/https-pro/won.png), [pause simulée](evidence/https-pro/returned-paused.png). Le [manifeste](evidence/MANIFEST.json) donne dimensions et empreintes, sans profil de navigateur ni identifiant secret.

Clôture locale : 735 fichiers candidats analysés, aucun motif de secret recherché ni valeur exacte du mot de passe temporaire trouvé. Les 32 preuves et 35 entrées du snapshot runtime correspondent également aux octets de l'index Git. Ce scan n'est pas une garantie exhaustive. Les journaux bruts sont conservés sans correction typographique : le runner natif contient des avertissements d'ancres Control pendant ses cas de fenêtres artificielles, malgré ses assertions réussies ; ils ne prouvent pas un défaut observé sur téléphone et ne sont pas supprimés. Le contrôle des espaces du code exclut ces preuves brutes, et reconnaît les CR du fichier de presets préservé.

Archive locale vérifiée : `build/delivery/switchworks-web-safari-108e-test.zip`, neuf fichiers clients uniquement, 14 779 571 octets, SHA256 `035aaba4e1b1104f8e1be5c9324c8788ad5029f0ff1cd22613d57831b3861279`. Elle ne contient ni serveur, clé, secret, APK ou source du dépôt. Les neuf membres ont été relus et comparés au manifeste d'export. Le nom rappelle la base native ; le manifeste identifie le PCK Web adapté. Une archive Web doit être servie par HTTP(S), pas ouverte par `file://` ; l'accès Safari courant reste le tunnel autorisé.

## Retour physique propriétaire, séparé des joueurs

Appareils déclarés : iPhone 15 Pro et iPhone 15 Pro Max sous iOS 27.2, même Wi-Fi. Le propriétaire a d'abord signalé un refus de connexion, puis précisé que le dialogue utilisateur/mot de passe revenait. Le mot de passe de campagne a été simplifié/renouvelé ; la saisie de l'utilisateur tolère maintenant la casse et les espaces extérieurs. Mauvais secret et accès anonyme restent refusés. Le retour suivant **« oui »**, puis la précision **« Iphone 15 pro »**, confirment l'accès sur cet appareil selon sa déclaration. Il a ensuite répondu **« oui/oui/oui »**, dans l'ordre des questions : toucher faisant tourner une voie, rotation conservée après rechargement, bouton « Reprendre » après Home et retour Safari. Ces trois contrôles sont positifs selon son témoignage, sans accès distant ni trace instrumentée du téléphone. Le Pro Max n'est pas encore essayé selon les informations reçues.

Retour artistique spontané du propriétaire : **« je m'attendait à mieux niveau graphisme »**, suivi d'une interrogation sur le niveau unique. Il précise ensuite **« les matériaux et le relief, les rails et bâtiments, l’interface etle demarrage lent »**. C'est un signal qualitatif à conserver, pas une note ni une session indépendante. L'export reprend l'art du commit de référence : il ne promet pas une nouvelle finition. Le niveau unique correspond au périmètre de la tranche représentative. Aucun niveau ni refonte n'est lancé à partir de ce retour seul.

Ces observations ne sont ni des résultats des cinq joueurs ni une certification du rendu physique. Le clic effectif sur « Reprendre », la fin d'une tournée, les animations de réception, les safe areas, le son et une conservation prolongée n'ont pas été confirmés sur téléphone. La durée du démarrage iPhone, cache froid/chaud, réseau et causes de lenteur ne sont pas mesurés ; ne pas substituer les dix secondes de Chrome au ressenti déclaré.

| Point ouvert | Preuve et qualification | Suite recommandée, sans implémentation autorisée par ce tableau |
|---|---|---|
| Matériaux/relief, rails/bâtiments, interface insatisfaisants | Verbatim propriétaire sur iPhone 15 Pro ; détails localisés et capture physique encore absents | Faire évaluer ces dimensions dans T05, puis choisir une correction ciblée sur le même niveau ; aucune note ni panne de lisibilité déduite |
| Démarrage lent | Ressenti propriétaire ; aucune durée physique mesurée | Chronométrer premier chargement et retour à origine identique, préciser cache/réseau et séparer téléchargement, compilation et entrée en jeu avant d'optimiser |
| Attente de contenu supplémentaire | Question sur le niveau unique | Expliquer le périmètre représentatif ; garder l'extension du contenu en HOLD jusqu'à décision après les tests |

## Différences Web / Android et corrections de portage

| Sujet | Web de test | Android natif conservé |
|---|---|---|
| Rendu | WebGL 2.0 Compatibility ; limites du navigateur et pilote Safari, performances mobiles à mesurer | OpenGL ES Compatibility de l'APK déjà testé sur émulateur ; physique encore prévu |
| Threads | WASM sans multithreading ; priorité à la compatibilité Safari | Runtime natif et planification propres à la plateforme |
| Entrées | Toucher navigateur, pas tactile Android ; premier contrôle automatique = un tap, une rotation | Pipeline natif de référence conservé |
| Glyphes | La fonte seule ne fournit pas les flèches/Ⅱ qui étaient disponibles via fallback natif. Remplacement Web uniquement par « Livrez A à A et B à B » et pause `II` | Libellés et police natifs inchangés |
| Safe areas / orientation | Sonde CSS `env(safe-area-inset-*)`, viewport cover et échelle paysage en pixels CSS ; barres Safari et encoche réelle à vérifier | Safe area du DisplayServer natif ; export portrait et tests existants conservés |
| Stockage | `user://` dans IndexedDB, dépend de l'origine, mode normal/cookies, éviction et délais de synchronisation | Fichier local de l'application, même schéma de préparation |
| Reprise | Page masquée : pause/sauvegarde ; retour : invalidation du cache et reprise explicite. Une page détruite revient en préparation après reload | Notifications Android natives, même contrat de préparation après nouveau processus |
| Contexte GPU perdu | Le backend Godot Web peut demander un rechargement ; aucune reconstruction automatique fictive n'est ajoutée | Comportement natif distinct |
| Audio | Désactivé initialement, Stream Web pour les WAV construits localement ; latence/autoplay à observer. Aucune écoute iPhone effectuée | Audio optionnel natif inchangé |

Les adaptations sont conditionnées par `OS.has_feature("web")`, avec diagnostics de compteurs/empreinte/dimensions, sans changer les règles ou la famille d'assets. [Détails et sources](RUNTIME.md). La [documentation Godot Web 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_web.html) explique le besoin WebAssembly/WebGL 2.0, le choix single-thread, le stockage et les limites Safari ; elle ne remplace pas l'essai réel de ce jeu.

## Incidents de préparation conservés

- Un premier outil réécrivait le PCK après export : corrigé, puis contrôle de toutes les empreintes servies.
- Windows autorisait deux sockets sur le même port avec réutilisation d'adresse : deux anciens serveurs pouvaient fournir des packs différents. Le serveur utilise maintenant un bind exclusif ; les deux anciens processus possédés ont été arrêtés et les neuf fichiers revérifiés.
- Le test headless supposait un vrai événement d'onglet masqué ; résultat qualifié puis remplacé par un contrôle synthétique explicitement identifié.
- Les premiers PNG Web révélaient des glyphes de remplacement dans l'objectif/pause : correction Web seule, nouveau build, nouvelle capture réelle vérifiée.
- L'authentification malformée non ASCII pouvait produire une exception serveur. Le parseur refuse maintenant proprement les cas invalides, sans accès ni trace de requête avec IP. Les erreurs de saisie mobile ont conduit à un secret temporaire plus lisible, jamais placé dans le dépôt.

## Campagne et issue de décision

Le [protocole Safari Web SW01–SW05](../user-tests/safari-web-5/README.md) reste distinct du protocole Android natif pr?par? localement (`docs/user-tests/android-physical-5/`, fichiers ant?rieurs hors du commit Web). Chaque personne ne fournit qu'une première découverte ; pour Android ultérieur, utiliser une nouvelle cohorte ou qualifier explicitement l'apprentissage. Toutes les mesures joueurs restent vierges/NE.

Si Safari ne charge pas ou ne permet pas les interactions/persistance correctement, enregistrer le cas et appliquer la [voie iOS native préparée macOS/Xcode](IOS_NATIVE_FALLBACK.md). Aucune location de Mac, adhésion Apple, signature ou distribution n'est engagée. Un échec d'authentification ne démontre pas une incompatibilité Godot/Safari.

**Accès, rotation, restauration après reload et affichage de reprise rapportés positifs sur iPhone 15 Pro ; autres contrôles physiques Safari encore incomplets, Android physique toujours prévu. HOLD artistique final et commercial.** Aucun nouveau niveau, refonte, store ou push GitHub. Le tunnel externe est la seule mise à disposition approuvée et reste temporaire. Les cinq sessions indépendantes restent à réaliser.
