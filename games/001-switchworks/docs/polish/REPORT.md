# Archipel Postal — passe de correction P1/P2/P3

**14 novembre 2026 — correctif expérimental livré pour validation humaine. Statut produit : TEST / HOLD.** Les départs et boîtes de réception sont distincts, les ombres et voies sont apaisées, les tuiles possèdent un bord/cap céramique, les consignes correspondent aux états et les colis entrent dans leur boîte avec confirmation locale. La reconnaissance par quatre personnes sur cinq n'a pas été testée.

## Référence et périmètre

Les trois fichiers de [revue fournie](../revue-critique-ia-2026-11-14/REVUE_CRITIQUE.md), son prompt et son image comparative ont été lus/examinés et sont conservés sans modification, avec SHA256 dans le manifeste. La revue est celle d'un autre assistant IA, pas d'un joueur humain. Les constats ont été confrontés au moteur, aux captures Android et aux nouveaux rendus, sans transformer les notes expertes en vérités de terrain.

Branche : **`fix/archipel-postal-finition-p1-p2`**, créée depuis **`d36af097ff169a807639b6ce9c50a9149b91ba3e`**. Au départ, les fichiers suivis étaient propres ; seuls les documents de critique ajoutés par le propriétaire étaient non suivis. Ils ont été conservés, sans stash ni reset. Tests de référence exécutés avant édition : **36/0, 137/0, 476/0**.

La grille, les ports, les règles, le JSON du niveau, les trois anciens runners et le moteur sont conservés. Aucun niveau, compte, boutique, achat, analytics ou progression n'est ajouté. Les scènes de bootstrap et `main` restent intactes ; l'ancienne branche demeure à `d36af097`. Les rapports antérieurs ne sont pas réécrits en validations du présent rendu.

| APK | Identité vérifiée |
|---|---|
| Avant, fichier conservé | `build/android/switchworks-archipel-slice-debug.apk`, code 2, SHA256 `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1` |
| Après final V6 | `build/android/switchworks-archipel-polish-debug.apk`, **61 448 663 octets**, code **6**, nom `0.1.1-polish.4`, SHA256 **`6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965`** |
| Exécution | Godot **4.7.2.stable.official.ed1daf0bf Standard**, Compatibility ; scène `res://scenes/archipel_postal.tscn` |

Les APK intermédiaires sont conservés sous `build/android/candidates/`, ignorés par Git ; les preuves utiles sont versionnées dans `evidence/`. Aucun push, store ou service distant n'a été utilisé pour diffuser ce travail.

## Corrections observables

| Priorité / constat vérifié | Modification ciblée | Preuve et limite |
|---|---|---|
| P1 — rôles des stations peu distingués | Guichet de départ avec flèche dégagée du colis ; réception en boîte céramique voûtée, enveloppe, fente et clapet. A/cercle et B/triangle conservés. | [Avant](evidence/before/1080x2400/planning.png), [après](evidence/after/1080x2400/planning.png). Silhouettes réellement distinctes ; compréhension en trois secondes par un novice encore à mesurer. |
| P1 — objectif et consignes contradictoires | Objectif permanent « Livrez A → A et B → B ». Une consigne contextuelle, deux lignes bornées, au-dessus du plateau ; aucun pied invitant à tourner pendant le trajet. Reprise prête explicitement annoncée, pluriels naturels. | [Transport](evidence/after/1080x2400/transport.png), [reprise](evidence/after/1080x2400/restored.png), [bilan](evidence/after/1080x2400/won.png). Le vrai chargement de fichier et les bornes natives sont vérifiés, pas seulement les chaînes de texte. |
| P1 — ombres noirâtres/crénelées et matières trop plates | Ombre directionnelle orthogonale courte, opacité 0,24, éclairage plus diffus ; pétales sans ombres portées polygonales. Coque céladon et cap glacé encastré, normales de biseau lissées, rugosités séparées porcelaine/papier/kraft. Réflexion native statique 128×128, sans changer le ciel de décor. | [Planche avant/après](evidence/diagnostics/comparison-planning-1080x2400.png). Pas de nouvelle texture ou poster ; la richesse du concept n'est pas déclarée entièrement atteinte. |
| P2 — traverses trop dominantes | Profils épaissis ; quatre traverses fines chaudes au lieu de huit plus contrastées ; même teinte de rail dans la station et le raccord adjacent. | [Réseau préparé](evidence/after/1080x2400/prepared.png), [diagnostic gris](evidence/diagnostics/after-prepared-grayscale.png). Ports et résultats du solveur inchangés. |
| P2 — arrivée surtout communiquée par le compteur | Clapet ouvert en approche, entrée locale du colis en 240 ms, fermeture et sceau de réception ; ensemble environ 380 ms après livraison logique. Réduit : mêmes états finaux instantanés. | [Vidéo Android 720×1600](evidence/regression/android-gameplay.mp4), [film natif 1080×2400](evidence/after/1080x2400/arrivals.mp4), [état reçu](evidence/after/1080x2400/won.png). Rejouer reste immédiatement disponible ; la satisfaction humaine du geste n'est pas certifiée. |
| P3 — HUD lourd et pied près du bord | Marque secondaire, objectif prioritaire, compteurs compacts ; actions nominales 48 unités et marge de 16 unités dans la safe area calculée ; aide hors du bord inférieur. Actions de préparation cachées en victoire, réaffichées au replay. | [Compact 360×640](evidence/compact/after-360x640-planning.png), [tablette victoire](evidence/after/1200x1600/won.png). Les grands espaces de ciel restent un choix de composition ouvert ; pas de preuve de confort au doigt sur téléphone. |

Les [notes d'assets](../../assets/archipel/POLISH_NOTES.md) donnent dimensions, pivots, rugosités et provenance. La lumière utilise les propriétés documentées de [Light3D](https://docs.godotengine.org/en/4.7/classes/class_light3d.html), [DirectionalLight3D](https://docs.godotengine.org/en/4.7/classes/class_directionallight3d.html) et [Environment](https://docs.godotengine.org/en/4.7/classes/class_environment.html). Aucun effet Forward+ indisponible en Compatibility n'est présenté comme actif. L'image de ciel reste le décor existant ; la réflexion est un `Sky` natif distinct.

## Avant/après et cadrages authentiques

Les deux APK ont été réellement exécutés sur **Studio_API_36, Android 16/API 36 x86_64**, serveur ADB 5041, `emulator-5580`, GPU host NVIDIA RTX 4060 Laptop / OpenGL ES 3.1 traducteur d'émulateur. Même niveau, mêmes ports/caméra et densité 420 ; tailles d'écran identiques entre avant/après. Le HUD est volontairement réagencé. Les positions pendant le transport viennent de l'exécution ADB et ne sont pas artificiellement alignées au même tick.

| Format / état | Avant original | Après original |
|---|---|---|
| 1080×2400 — préparation | [PNG](evidence/before/1080x2400/planning.png) | [PNG](evidence/after/1080x2400/planning.png) |
| 1080×2400 — transport | [PNG](evidence/before/1080x2400/transport.png) | [PNG](evidence/after/1080x2400/transport.png) |
| 1080×2400 — réussite | [PNG](evidence/before/1080x2400/won.png) | [PNG](evidence/after/1080x2400/won.png) |
| 1080×2400 — reprise de processus | [PNG](evidence/before/1080x2400/restored.png) | [PNG](evidence/after/1080x2400/restored.png) |
| 720×1280 — préparation / transport | [préparation](evidence/before/720x1280/planning.png), [transport](evidence/before/720x1280/transport.png) | [préparation](evidence/after/720x1280/planning.png), [transport](evidence/after/720x1280/transport.png) |
| 720×1280 — réussite / reprise | [réussite](evidence/before/720x1280/won.png), [reprise](evidence/before/720x1280/restored.png) | [réussite](evidence/after/720x1280/won.png), [reprise](evidence/after/720x1280/restored.png) |
| 1200×1600 — préparation / transport | [préparation](evidence/before/1200x1600/planning.png), [transport](evidence/before/1200x1600/transport.png) | [préparation](evidence/after/1200x1600/planning.png), [transport](evidence/after/1200x1600/transport.png) |
| 1200×1600 — réussite / reprise | [réussite](evidence/before/1200x1600/won.png), [reprise](evidence/before/1200x1600/restored.png) | [réussite](evidence/after/1200x1600/won.png), [reprise](evidence/after/1200x1600/restored.png) |
| Windows compact 360×640 | [PNG natif conservé](evidence/compact/before-360x640-planning.png) | [PNG natif final](evidence/compact/after-360x640-planning.png) |

Les PNG Android viennent de `screencap -p`, les vidéos de `screenrecord`. Les originaux ne sont ni recadrés, ni retouchés, ni réencodés. Les planches côte à côte sont des **assemblages de diagnostic**, pas de nouvelles captures du moteur. Les deux images en gris sont des **dérivés analytiques**, pas une simulation médicale de vision ni une mesure WCAG. Lettres A/B, flèches, enveloppes et parcours restent identifiables à l'inspection ; les formes derrière les lettres demeurent petites et sont à évaluer physiquement.

## Tests exécutés et défauts réellement trouvés

| Contrôle | Résultat |
|---|---|
| Bootstrap conservé | **36/0** |
| Modèle conservé | **137/0**, dont 1 000 couples rotation/annulation |
| UI conservée | **471/0**, fichier du runner inchangé ; cinq assertions conditionnelles de visibilité en moins parce que le footer est masqué |
| Nouveau runner d'états | **1 758/0** sur cinq formats ; contrôle négatif **1 758/1**, code 1 attendu |
| Famille géométrique | **467/0**, 111 meshes et 12 051 triangles custom inspectés ; ce n'est pas le coût du plateau complet |
| Compilation / chemins | **13 scripts, 0 cassé** ; contrôle de ressources **0 erreur, 0 avertissement** au passage exécuté |
| Comparaison ADB | [Avant **101/0**](evidence/before/receipt.json), [après **113/0**](evidence/after/receipt.json), trois ratios ; bornes et deux lignes réellement visibles de la consigne contrôlées dans l'APK final |
| Régression Android complémentaire | [**67/67**](evidence/regression/receipt.json) sur le même APK final : Home pendant trajet, reprise, nouveau processus, annulation, préférences et absence d'erreur Godot détectée |

Ces comptes sont des assertions et contrôles, **pas des joueurs**. Les suites et leur évolution sont dans [TESTS.md](TESTS.md). Aucune assertion ancienne n'a été supprimée pour obtenir les résultats.

La recette visuelle a trouvé des défauts que les premières suites ne couvraient pas :

- Minimum d'autowrap du bilan caché : panneau de 560 unités. Corrigé par deux lignes bornées sans autowrap ; contrôle immédiat des bornes, sans attente pour masquer un dépassement.
- Dans le candidat APK `a17bed94…`, la restauration écrivait la consigne avant son premier layout : largeur nulle, hauteur d'autowrap gonflée, texte déporté au bas de l'écran. [Preuve rejetée](evidence/candidates/a17bed94-restored-rejected.png). Premier layout avant chargement, textes explicites de deux lignes, zone 44 unités pour un minimum réel de 43 ; quinze fixtures de chargement précoce ajoutées sur cinq formats. Le premier test de cette régression est postérieur au fix : aucun échec headless pré-fix n'est inventé.
- Un diagnostic JSON trop long était tronqué dans le journal Android. Les diagnostics de guidage sont désormais séparés du plan des coordonnées. Cela corrige l'outil de recette, sans changer le jeu.
- Sur la tablette V5, des morceaux de boutons désactivés dépassaient du bilan : [preuve](evidence/candidates/v5-1200x1600-won.png). Ils sont cachés en victoire dans V6, vérifiés dans les trois formats et au retour par Rejouer.

Les anciens candidats/patches et journaux restent sous `artifacts/polish/` et `build/android/candidates/`. Ils ne sont pas étiquetés comme livrables validés.

## Performances : comparaison mesurée, portée limitée

Chaque point utilise un nouveau processus en préparation restaurée, onze secondes d'observation idle, 540 intervalles muraux après 60 images d'échauffement. Le moteur est plafonné à 60 FPS. Série unique sur hôte partagé, sans protocole statistique de non-infériorité.

| Écran | FPS avant / après | p95 mural avant / après | Draw calls idle avant / après | PSS KiB avant / après |
|---|---:|---:|---:|---:|
| 1080×2400 | 60 / 60 | 17,720 / 17,589 ms | 24 / 27 | 187 479 / 185 280 |
| 720×1280 | 60 / 60 | 18,190 / 18,138 ms | 24 / 27 | 180 471 / 184 494 |
| 1200×1600 | 60 / 60 | 18,077 / 18,196 ms | 24 / 27 | 182 037 / 185 938 |

Aucune chute du compteur idle n'est observée ; les écarts p95 de cette série sont petits. Cela ne démontre ni 60 FPS constants pendant toute animation, ni absence statistique de régression, ni performance d'un téléphone. Le cap ajoute un mesh par tuile ; le plateau reste mis en cache entre actions. Batterie, température, endurance, GPU pur et ARM64 physique ne sont pas mesurés.

Le film natif **1080×2400** dure **9,54 s**, 243 images, cadence de capture médiane 34,006 ms / p95 67,178 ms : l'enregistrement haute résolution est coûteux sur cet émulateur. Une vidéo complémentaire **720×1600** du même APK, non réencodée, dure **7,97 s**, 427 images ; intervalles encodés médian **16,695 ms**, p95 **34,345 ms**, maximum **99,634 ms**. Les deux films sont muets. Leurs pistes ont été décodées complètement puis examinées par échantillons : entrée partielle dans les boîtes puis sceaux fermés visibles. **Ces cadences ne sont pas des mesures de latence tactile ou de temps GPU.** Le fichier 720 est le support de revue temporelle recommandé.

Les avertissements natifs de cache shader/ashmem, quand présents, sont conservés dans les journaux. Le passage complémentaire ne détecte aucun `ERROR:` Godot, `SCRIPT ERROR` ou `FATAL EXCEPTION`. Aucune garantie zéro bug ou zéro avertissement n'est donnée.

## Reproduire et statuer

Depuis la racine, les commandes `Slice.ps1` réutilisent le moteur/SDK existants ; F6 sur `scenes/archipel_postal.tscn` lance le jeu, F5 conserve la mire.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action Run
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action Test
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action ExportAndroid
python games/001-switchworks/tools/capture_polish_android.py --label after --apk games/001-switchworks/build/android/switchworks-archipel-polish-debug.apk
python games/001-switchworks/tools/verify_android_slice.py --apk games/001-switchworks/build/android/switchworks-archipel-polish-debug.apk
```

Démarrer auparavant l'AVD dédié avec `tools/Start-StudioEmulator.ps1 -Action Start`. Ne pas chaîner la recette à la sortie d'une enveloppe en pipe qui resterait ouverte après le boot : dans ce poste, `BootCompleted` était atteint mais une enveloppe PowerShell restait en attente ; seule cette enveloppe a été fermée puis la recette lancée séparément. La taille initiale de l'AVD est restaurée et son serveur 5041 est arrêté après les tests ; le serveur partagé 5037 n'est pas touché.

L'[audit d'intégrité](INTEGRITY.md) couvre APK, signatures, ressources, licences, secrets et références préservées. Les trois textures générées et la fonte sont inchangées ; aucune nouvelle image générée ni modèle externe n'est ajouté. Les conditions commerciales des images générées restent à confirmer avant diffusion commerciale.

**Décision QA : GO pour remettre cette correction expérimentale et la faire évaluer ; HOLD pour l'acceptation artistique globale et le marché.** La [seconde lecture visuelle](VISUAL_QA_FINAL.md) confirme des améliorations réelles. Restent une matérialité plus sobre que le concept, la composition très aérée et les petits indices de forme à valider en conditions physiques. Le bilan peut recouvrir la dernière rangée vide/décor, sans masquer les réceptions ; aucun contrôle de préparation résiduel ne dépasse.

Faire valider humainement le rendu et les cinq tâches non guidées avant toute extension de contenu. Le seuil proposé quatre personnes sur cinq n'est pas atteint par substitution d'agents IA : aucun participant n'a été testé, aucun recrutement ou envoi n'a été fait. iOS, appareil physique, confort à une main et écoute audio restent non vérifiés.
