# Recette et revue contradictoire — Céramique littorale

16 novembre 2026. **Composition exécutée ; REWORK pour l'acceptation artistique finale.** Cette étude ne vaut ni nouvelle direction approuvée, ni validation commerciale. Une seule composition utilise le niveau existant, pas de nouveau niveau, boutique ou compte. Budget additionnel : **0 €** ; aucune publication distante.

## Corpus et version

Les quatre fichiers du dossier `references-2026-11-16` ont été lus/inspectés, avec le dossier Archipel Postal, les anciennes QA, la recette de finition et le retour propriétaire du 14 novembre. Les planches restent conceptuelles ; leurs T/Y/croisements, raccords et échelles ne font pas autorité. Leur « A Céramique littorale » est une sous-piste du B Archipel Postal historique, pas Atelier 17.

Branche `art/archipel-postal-littoral-study`, base `af5cc28f37386df0024d3e20134c7d8a80886807`. Godot **4.7.2.stable.official.ed1daf0bf Standard**, GDScript, Compatibility. Scène `res://experiments/littoral/composition.tscn`. Le [manifeste des preuves](evidence/MANIFEST.json) fige les entrées runtime, les empreintes et les dimensions réelles ; il identifie les sources locales sans transformer leur base Git en commit du nouveau build.

Le niveau, le modèle, les anciens assets, scènes et tests sont conservés. L'unique extension du contrôleur est la fabrique de vue, dont le retour par défaut reste la vue historique. Sauvegarde expérimentale et paquet Android distincts. `main`, la branche de finition et l'APK `108e2b04` sont conservés ; les préparatifs Android locaux antérieurs ne sont pas inclus dans cette livraison artistique.

## Voir le vrai rendu

| Preuve brute | Contexte exact |
|---|---|
| [Avant 390×844](evidence/before/390x844/planning.png) / [après 390×844](evidence/after/390x844/planning.png) | Même niveau initial, Windows/NVIDIA RTX 4060 Laptop, Godot réellement exécuté ; caméra et assets de la composition d'étude après intégration |
| [Avant compact 360×640](evidence/before/360x640/planning.png) / [après compact](evidence/after/360x640/planning.png) | Même protocole, pas un écran de téléphone physique ni un redimensionnement d'illustration |
| [Réception en cours](evidence/after/390x844/reception.png), [réussite](evidence/after/390x844/won.png), [échec](evidence/after/390x844/failed.png), [pause](evidence/after/390x844/paused.png) | PNG enregistrés depuis le viewport exécuté, aucune retouche |
| [Planche modulaire native 960×720](evidence/modules.png) | Six présentations des familles et deux colis, dans `module_sheet.tscn` exécutée ; pas concept art |
| [Android préparation](evidence/android/1080x2340/planning.png), [réussite](evidence/android/1080x2340/won.png), [compact](evidence/android/720x1280/planning.png) | APK d'étude exécuté sur AVD dédié, captures `screencap` non retouchées |
| [Vidéo Android](evidence/android-gameplay.mp4) | `screenrecord`, **720×1560**, environ **11,74 s**, cadence vidéo variable ; rotations, préparation, transport, pause/reprise et réception. Pas de piste sonore constatée |
| [Vidéo PC](evidence/desktop-gameplay.mp4) | Movie Maker réellement exécuté, **450×800**, 30 images/s, environ **9,23 s**, AVI encodé H.264 avec le FFmpeg existant. Enregistrement déterministe, pas mesure de FPS |

Les images ne sont jamais étiquetées « iPhone » ou « Android physique ». Les premières vidéos PC recadraient le viewport car la dimension AVI configurée était différente de la résolution demandée ; l'outil a été corrigé pour faire correspondre la fenêtre à la taille de capture du projet. L'échantillon de la vidéo finale a été rouvert : titre et actions restent dans le cadre. Les PNG comparatifs restent bien en 390×844 et 360×640.

## Inspiration → règle → implémentation → preuve

| Intention des planches | Règle vérifiable | Élément Godot | Preuve |
|---|---|---|---|
| Toiture émaillée courbe | Volume réel, façade et auvent différenciés, empreinte inférieure à une case | `guichet_a/b.glb`, sources TSCN, `roof_patch` | [Modules](evidence/modules.png), [préparation](evidence/after/390x844/planning.png) |
| Boîte et réception expressive | Ouverture à l'ouest, clapet articulé, sceau après événement réel | `boite_a/b.glb`, `ReceptionLid`, `ReceiptSeal`, handlers hérités | [Réception](evidence/after/390x844/reception.png), vidéo Android et `SLICE_RECEIVED A/B` |
| Rails modulaires | Seulement droites/coudes, deux ports aux milieux des côtés ; pas de branche inventée | `voie_droite/coude.glb`, rotations de la vue ; même PostalBoard | [Contrôle des meshes GLB](evidence/checks/model-validation.json), tests de toutes les orientations |
| Papier/kraft et identité d'adresse | Colis A/cercle et B/triangle, même code sur station et réception | `colis_a/b.glb`, traits A/B géométriques | Modules, préparation et vidéo native |
| Matière tactile, ombres courtes | Biseaux et paramètres PBR, blancs non brûlés, pas de stries | Six familles de matières, éclairage Compatibility, biais d'ombre contrôlé | Avant/après et [compact](evidence/android/720x1280/planning.png) |
| Plateau dominant et HUD lisible | Texte natif, légendes de compteurs 12 unités, commandes ≥48 unités logiques | Sous-classe de composition, mêmes actions et overlays | [Compact](evidence/after/360x640/planning.png), tests d'absence de chevauchement |

Sources modifiables : neuf TSCN et neuf GLB, avec [provenance et licences](../../../../games/001-switchworks/assets/littoral-study/PROVENANCE.md), [manifeste des assets](../../../../games/001-switchworks/assets/littoral-study/asset-manifest.json). Aucune planche entière, aucun fragment de planche ou texture empruntée à un concurrent n'est utilisé dans les modèles. Pas de `.blend` : Blender n'a pas été retenu. Le fond de ciel déjà existant est conservé, avec ses conditions de droits antérieures encore à revoir avant commercialisation.

## Contrôles réellement exécutés

| Contrôle | Résultat |
|---|---|
| Suites existantes | **36/0**, **137/0** (dont 1 000 essais d'annulation), **471/0**, **1 758/0** ; journaux conservés |
| Composition isolée | **1 107 réussis, 0 échec**, formats logiques 390×844, 360×640 et 800×1067 ; caméra du vrai SubViewport, projection des 36 cases, ports visibles/logiques, rotations, échec, réception, pause, mouvement réduit et commandes |
| Contrôle négatif du nouveau runner | **Code 1**, 1 échec intentionnel ; aucune qualification en échec fonctionnel du jeu |
| Compilation et ressources | **19 scripts, 0 cassé** ; **431 fichiers, 0 erreur et 0 avertissement** au vérificateur de chemins |
| Export/lecture des modèles | **9/9 GLB** relus dans Godot puis analysés indépendamment en Python : buffers, dépendances embarquées, géométrie, normales et intersections des vrais rails aux bords. 0 triangle dégénéré et 0 face opposée aux normales selon ce contrôle limité ; pas certification Khronos |
| Raster | **23 images** décodées, contrôles réussis, dont les deux références originales ; [reçu](evidence/checks/raster-qa.json) |
| Android natif émulateur | **77/77** ; AVD `Studio_API_36`, serveur ADB dédié 5041, API 36, GPU host, formats 1080×2340 et 720×1280 ; [reçu](evidence/android/receipt.json) |

La recette Android installe seulement `org.studio100games.switchworks.littoral.study` et ne remplace pas le paquet de finition. Un tap produit une rotation, Annuler restitue les ports, les stations restent fixes, le niveau initial échoue honnêtement et le témoin existant aboutit à deux réceptions. La vidéo est capturée pendant les gestes ; Home/reprise et fermeture de processus/restauration sont vérifiés ensuite. La résolution initiale de l'AVD est restaurée en sortie. Aucun `clear` ni effacement de sauvegarde.

Les timings/gestes automatisés ne mesurent pas la compréhension, la préférence ou le confort d'un joueur. Les résultats propriétaires Safari du 14 novembre concernent l'ancienne version Web, **pas cette nouvelle étude**. Aucun des cinq joueurs indépendants n'a été déclaré testé par ce travail.

## Performance et limites de mesure

[Valeurs contextuelles et intervalles bruts](evidence/checks/metrics-summary.json). La scène compte **76 863 triangles soumis en comptant les instances**, **120 nœuds de mesh dont MultiMesh**, 36 instances de chaque surface de dalle. Ce comptage statique n'est pas le nombre de triangles visibles après culling ni une consommation GPU.

Pendant la livraison Android finale : environ **250–251 appels de dessin**, contre **520–521** avant regroupement du sol/décor. C'est une réduction mesurée du nombre d'appels, pas une promesse de doublement du framerate.

- Sur les passages Android observés, médianes d'intervalles autour de 16,7–17 ms et P95 autour de 19–22 ms ; lire les valeurs exactes de chaque profil dans le reçu. Les compteurs de FPS du moteur peuvent afficher environ 60 dans ce contexte, sans certifier un 60 FPS stable sur téléphone.
- Mémoire statique Godot observée : environ **48–54 Mo décimaux**. Elle exclut notamment Java, mémoire GPU et surcoût de l'émulateur ; ce n'est pas la RAM totale d'un téléphone.
- Premières images Android depuis `_ready` : environ **1,7–2,0 s** sur le dernier passage ; les journaux conservent chaque mesure et les sorties `am start -W`. Les captures Windows sont autour de 0,12–0,15 s depuis `_ready`. Ce périmètre exclut le téléchargement, l'ouverture du processus et une partie du chargement.
- La vidéo PC utilise un temps de simulation fixé à 30 images/s ; ses « FPS » de traitement ne sont pas une mesure de performance de jeu. La vidéo Android peut perdre des images à l'encodage ; sa cadence vidéo n'est pas le FPS de rendu.
- Hôte Windows avec GPU de portable, autres vérifications parfois simultanées, caches chauds, profil débogage, premier passage Android enregistré ; pas de benchmark laboratoire, chauffe, batterie, GPU mobile physique ou latence doigt-écran mesurés.

Le démarrage lent signalé sur l'iPhone n'est **pas déclaré corrigé**. Cette étude n'a pas été mise à jour sur le tunnel ni testée dans Safari. La 3D n'emploie pas SSAO, bloom ou fonction Forward+ indispensable ; les matériaux sont simplifiés et le décor statique regroupé. Il reste à exporter/mesurer cette composition Web avant toute conclusion WebGL/iOS.

## Checklist ergonomique et appréciation artistique

| Critère | Observation, pas validation terrain |
|---|---|
| Actions et navigation | Commandes de 48 unités logiques ou plus, texte natif, pause/reprise, relance, erreur réparable et focus initial vérifiés dans le périmètre automatisé |
| Grille et toucher | Centres projetés vérifiés pour les 36 cases ; espacement mesuré ≈53,5–53,7 horizontal et ≈45 vertical en unités Godot. **Ne pas annoncer 48 dp/points pour les cases** : AVD en densité 420, formats forcés et confort physique non mesuré |
| Couleur | Lettres et formes en plus du bleu/terre cuite ; guichet à auvent/flèche et boîte à enveloppe/clapet. La reconnaissance spontanée de ces petits indices reste à observer |
| Mouvement | Rotation de 90° et réception sur événements réels, pause des tweens, mode réduit sans attente logique ; audio existant optionnel et désactivé au départ, non évalué sensoriellement |
| Contraste | Texte encre sur surfaces claires et actions principales conservés. Pas de certification WCAG/RGAA, pas de test VoiceOver/TalkBack, plein soleil ou vision déficiente |
| Matières | Relief, biseaux, métal des rails et toits courbes plus construits ; larges surfaces encore uniformes, richesse picturale sensiblement sous les références |
| Identité et proportions | Palette et formes cohérentes, pas de palais/ponts décoratifs qui brouillent le puzzle. Les bâtiments restent plus petits que dans les planches pour protéger les ports |

Grille expert 0–4 : **identité 3 ; lisibilité du réseau 3 ; cohérence 3 ; finition 2 ; fidélité du build au contrat technique 3 ; confort mobile NT physiquement**. Le confort n'est pas converti en note favorable. La finition à 2 interdit de présenter cette étude comme direction finalisée. Cette appréciation est celle de l'agent producteur après inspection des rendus, **pas une revue artistique indépendante**.

## Anomalies, corrections et réserves

| ID / gravité | Constat et preuve | Statut |
|---|---|---|
| LIT-01 majeure | Premier rendu blanc brûlé, détails de pierre perdus ; `candidate-v1` local | Corrigé : marge des albedos clairs et éclairage réduit ; après/compact vérifiés |
| LIT-02 majeure | Toits sombres/rails aux faces inversées ; contrôles géométriques initiaux | Corrigé : sources normalisées avant export, faces et triangles contrôlés ; validation 9/9 |
| LIT-03 majeure | Enseigne/enveloppe cachées dans la toiture, confusion de rôle | Corrigé pour l'occlusion : enseignes avancées et plaque dédiée ; [modules](evidence/modules.png). La compréhension spontanée reste non démontrée |
| LIT-04 majeure | Stries d'auto-ombrage sur les dalles au format compact | Corrigé : biais d'ombre révisé, compact PC/Android rouvert |
| LIT-05 majeure | 520–521 appels de dessin, nombreuses instances statiques séparées | Corrigé dans ce périmètre à 250–251 ; perf physique encore inconnue |
| LIT-06 mineure | Petites légendes de compteurs, repère de sélection flottant | Corrigé : légendes 12 unités et marge dimensionnée, repère ramené au contrat de hauteur de la vue |
| LIT-07 majeure d'acceptation | Uniformité des dalles/façades et richesse moindre que les planches, surtout à taille téléphone | **Ouvert / REWORK artistique** : proposer une passe ciblée de matières et détails utiles après retour du propriétaire, pas une refonte complète |
| LIT-08 risque UX à valider | Indices de rôle et réception petits ; espacement vertical de cases ≈45 unités | **Ouvert / essais humains nécessaires** ; les taps automatisés et la grande planche de modèles ne prouvent pas le confort au doigt |
| LIT-09 outillage | Première vidéo PC recadrée par la différence de taille Movie Maker/fenêtre | Corrigé : vidéo finale 450×800 complète, format réel contrôlé par décodage ; essais précédents conservés localement |

Autres essais conservés sous `artifacts/art-study-2026-11-16/` : rejet TextMesh sur contours de fonte variable, faux négatif du contrôle de direction qui utilisait un demi-vecteur non normalisé, premier enregistrement aux clics non convertis en pixels de fenêtre, première lecture ADB de sauvegarde interrompue. Les parcours ont été rejoués après correction/qualification ; aucun de ces essais n'est rebaptisé succès.

## Décision

**GO technique pour examiner cette composition réellement jouable ; REWORK pour l'acceptation artistique et la généralisation.** Les améliorations observables sont des modèles séparés, un volume/cadrage plus lisible et des événements réellement animés. Elles ne comblent pas entièrement l'écart avec les illustrations.

Décision humaine attendue : conserver ou ajuster cette sous-piste, juger les guichets/boîtes et la matière à taille téléphone, puis autoriser éventuellement une passe limitée sur ces mêmes composants. Aucun nouvel écran de progression, niveau ou refonte complète n'est engagé. Les cinq tests indépendants, Android physique et Safari de cette étude restent à réaliser. SWITCHWORKS reste **TEST / HOLD commercial**.

Reproduction, édition et commandes : [README](README.md). Références techniques vérifiées : [GLTFDocument 4.7](https://docs.godotengine.org/en/4.7/classes/class_gltfdocument.html), [matériaux StandardMaterial3D](https://docs.godotengine.org/en/4.7/tutorials/3d/standard_material_3d.html). Les captures et les mesures du build, plutôt que ces documentations ou les concepts, fondent les constats de ce rapport.

## Archive locale de livraison

`games/001-switchworks/build/delivery/switchworks-littoral-study-source.zip` : **180 fichiers, 28 670 414 octets**, SHA256 `7960db3da7be58819b5735d3bf0fe3bfb20a33e7c14c9e9c6876819ced2a3495`. Snapshot des sources runtime, assets et documents de l'étude au moment de l'emballage, pas archive complète du monorepo. Aucun moteur, SDK, APK, cache, secret ou keystore inclus. `START_HERE.md` donne les commandes Godot directes, sans installation portable à chemin implicite ; les anciens dossiers historiques demandent le dépôt complet.

L'archive a été contrôlée, extraite dans un répertoire neuf, importée avec Godot 4.7.2 puis sa composition lancée headless : **deux codes 0, sans erreur détectée**. Ce contrôle de livraison ne remplace pas les captures GPU, réalisées depuis les mêmes sources runtime dans le checkout. Les preuves d'archivage sont conservées séparément, pour éviter une empreinte d'archive auto-référente. Aucun fichier n'est téléversé.
