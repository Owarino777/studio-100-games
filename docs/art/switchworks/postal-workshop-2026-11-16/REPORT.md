# Recette critique — refonte UI/UX Comptoir maritime

Exécution des **16–17 novembre 2026**. Brief de référence : PDF du 16 novembre, **16 pages lues intégralement et rendues**, SHA256 `8fe437351807bf980422c7d7d9bb89720c5582e891e8b9beccb3faa1d1caa8af`. Les instructions « PROMPT CODEX » p.11–15 sont appliquées ; la validation artistique finale appartient au propriétaire. Budget additionnel **0 €**, aucun appel payant, crédit consommé ou push.

## Périmètre et décision

**GO pour examiner la refonte UI exécutée ; REWORK ciblé sur la stabilité des performances Android avant GO technique global. HOLD pour acceptation artistique finale, tests physiques et commercialisation.** Le gain observé porte sur la hiérarchie, la reconnaissance des fonctions postales, l'absence d'occlusion en jeu et la cohérence des couches. Il ne vaut ni préférence des joueurs, ni certification de performance ou d'accessibilité.

Branche `feat/switchworks-postal-ui-ux`, base **2b53f3a**. Scène nouvelle `res://experiments/postal_workshop/game.tscn`. Les scènes et assets antérieurs restent disponibles ; `main`, la finition `108e2b04`, le Web `af5cc28` et l'étude `2b53f3a` restent des références. Le modèle, les données du niveau, les ports, compteurs, ordre de simulation, undo et schéma de sauvegarde sont conservés. APK et Web de recette séparés des anciens exports.

Le PDF cite sept captures, mais intègre six images uniques : ses commentaires sur la deuxième rotation ne sont pas transformés en image supposée. Une baseline des **sept états** a été exécutée dans Godot avant modification. Le [contrat de conception](DESIGN_CONTRACT.md), la [porte du banc](GATE_BENCH.md) et l'[ADR 0004](../../../decisions/0004-comptoir-maritime-ui-etats.md) expliquent les décisions.

## Correspondance au brief

| Pages / exigence | Réalisation contrôlable |
|---|---|
| 2–3,11 : identifier le bandeau | Reproduction par survol après rotation ; texte identique à l'infobulle du plateau. Contrôle A/B avec cette seule propriété neutralisée : bandeau absent. Correctif dans la vue de base ; la description clavier/toucher reste accessible |
| 5,7,12 : matières et mini-kit | Banc limité exécuté avant intégration ; tuile, voie, guichet/boîte et HUD. Dix modèles source TSCN/GLB, thème et tokens natifs, quatre SVG originaux ; aucun pixel du PDF utilisé comme texture |
| 6,13 : hiérarchie | Une marque secondaire, objectif et progression principale ; plateau pleine largeur sûre sans ciel ni grand cadre ; chiffres de rotations/essais secondaires et toujours consultables |
| 8,13 : états | Préparation, rotation/undo, prêt, transport, réception, résultat intégré, rejouer et pause contextuelle dérivés du contrôleur existant ; pas seconde logique métier |
| 4,8,14 : fin et pause | Bilan sous le plateau après les présentations locales ; victoire logique/Rejouer non retardés. Pause = seul calque modal actif, options et focus, résultat caché pendant cette modalité |
| 9,14–15 : recette et preuve | Parcours automatisé natif et navigateur, sept états avant/après, multi-ratios, texte agrandi, gris, métriques contextualisées, exports et historique conservés |

## Voir les captures réellement exécutées

Les liens suivants pointent vers des PNG bruts du viewport, pas des concepts. Les formats Windows **390×844 et 360×640** sont identiques avant/après ; seules les vues ont changé. Le rendu gris est une passe QA du moteur, annoncée comme telle ; les preuves couleur ne sont pas retouchées.

| État | Avant 390×844 | Après 390×844 |
|---|---|---|
| Préparation | [PNG](evidence/before/390x844/01-preparation.png) | [PNG](evidence/after/390x844/01-preparation.png) |
| Rotation 1 / survol | [Bandeau reproduit](evidence/before/390x844/02-rotation-hover.png) | [Sans recouvrement](evidence/after/390x844/02-rotation-hover.png) |
| Rotation 2 | [PNG](evidence/before/390x844/03-rotation-two.png) | [PNG](evidence/after/390x844/03-rotation-two.png) |
| Réseau prêt | [PNG](evidence/before/390x844/04-ready.png) | [PNG](evidence/after/390x844/04-ready.png) |
| Transport | [PNG](evidence/before/390x844/05-transport.png) | [PNG](evidence/after/390x844/05-transport.png) |
| Réussite | [PNG](evidence/before/390x844/06-won.png) | [PNG](evidence/after/390x844/06-won.png) |
| Pause depuis réussite | [Double couche](evidence/before/390x844/07-paused-won.png) | [Modalité cohérente](evidence/after/390x844/07-paused-won.png) |

Autres preuves : [compact](evidence/after/360x640/01-preparation.png), [gris natif](evidence/grayscale/01-preparation.png), [banc avant/après](evidence/bench/rest.png), [Android](evidence/android/1080x2340/planning.png), [vrai paysage Android](evidence/android/2340x1080/planning.png), [Web réellement exécuté](evidence/web/01-preparation.png).

[Vidéo PC](evidence/desktop-gameplay.mp4) : Movie Maker à la taille réellement configurée 450×800, 30 images/s de simulation, AVI encodé H.264 avec FFmpeg déjà installé. Le parcours couvre les sept états, reprise, rejouer, indice, erreur et pause de préparation. Ce mode n'est pas un benchmark de FPS.

[Vidéo Android](evidence/android-gameplay.mp4) : `screenrecord` du jeu natif sur AVD, sans retouche ; ses dimensions/durée/cadence réelles sont consignées dans les métadonnées. La cadence d'encodage n'est pas le FPS de rendu. Pas de son évalué à partir d'une vidéo muette.

Le [manifeste](evidence/MANIFEST.json) identifie versions, sources runtime, dimensions, empreintes et contexte de chaque preuve. Les profils de navigateur, clés, caches, fichiers de signature et APK ne sont pas versionnés avec ces preuves.

## Vérifications

- Suites historiques conservées : **36/0**, **137/0** avec 1 000 essais d'annulation, **471/0**, **1 758/0** ; étude antérieure **1 107/0**.
- Nouvelle recette UI : **1 304 réussis / 0 échec**, contrôle négatif **code 1 / échec intentionnel**. Huit profils, dont 320×568, 360×640, 390×844, 430×932, 844×390, 800×1067 ; texte 125 % et 150 % selon profil. Raccords, projection des 36 cellules, undo exact, indice, erreur, prêt sans incrément d'essai, réception, victoire, rejouer, pause/focus, mouvement réduit et restauration d'un snapshot du schéma existant.
- Compilation : **29 scripts, 0 cassé** ; vérificateur de ressources **484 fichiers, 0 erreur et 0 avertissement** dans ce passage.
- Assets : **10 GLB** relus par Godot et inspectés indépendamment en Python ; dépendances embarquées, normales, triangles et sorties physiques. Aucun problème détecté dans ce périmètre, pas certification Khronos exhaustive. Quatre SVG structurés et sources éditables conservés.
- Contrastes sémantiques : texte/surface **10,76:1**, texte/fond **9,95:1**, action primaire **8,05:1**, secondaire/fond **5,21:1**, étiquettes A **5,22:1**, B **4,62:1**. Ces ratios concernent les tokens sRGB ; ils ne certifient ni chaque pixel 3D éclairé ni WCAG/RGAA.

La recette Android utilise seulement `org.studio100games.switchworks.postal.ui`, AVD `Studio_API_36`, ADB dédié 5041, API 36/GPU host. Trois fenêtres réellement vérifiées : **1080×2340 à 480 dpi**, **720×1280 à 320 dpi**, **2340×1080 à 480 dpi**. Les minima de commandes visibles ont été calculés à partir des pixels et du DPI rapporté : **48 dp au moins dans ces profils**. Cela ne prouve pas leur confort sur un appareil physique. Taille et densité de l'AVD sont restaurées en sortie.

Les captures sont produites après de vrais appuis : une touche = une rotation, stations fixes, undo fidèle, initial non résolu puis deux réceptions via le témoin existant. Home/reprise et arrêt/redémarrage du processus retrouvent la préparation. Aucun `clear`, désinstallation ou nouvelle règle. La première tentative de « paysage » était encore une fenêtre portrait : elle n'est pas comptée comme validation paysage. Le nouveau seul preset/écran utilise l'orientation capteur ; les exports historiques gardent leur comportement.

## Web, stockage et chargement

Le nouveau Web est un **export Godot release Compatibility**, modèles 4.7.2 installés, `thread_support=false`, sans extension/PWA ; pas maquette HTML. Neuf fichiers clients, WASM **39 514 754 octets**, PCK d'environ **5,32 Mo** (empreinte exacte dans le manifeste). Le MIME WASM et le contenu réellement servi sont vérifiés par comparaison SHA.

Trois profils Chrome Windows avec toucher/DPR émulés ont exécuté préparation → rotation → reload exact → indice/échec → prêt → transport/réceptions → pause → rejouer. **Chrome n'est ni Safari ni un iPhone.** La callback blur/focus est testée synthétiquement et explicitement étiquetée ; elle ne démontre pas Home iOS.

Premier chargement local en profil vierge : environ **8–10 s** ; rechargement même origine : environ **1,3–1,5 s** dans les premiers passages. Le reçu final donne chaque valeur. HTTP observé : JS revalidé en **304**, WASM et PCK redemandés en **200** par le chargeur. Le gain à chaud ne doit donc pas être vendu comme une suppression de ces transferts. Le coût réseau réel et Safari restent à mesurer ; le démarrage lent signalé sur iPhone n'est pas déclaré résolu.

Stockage : schéma et écritures inchangés. Rechargement exact vérifié ; redémarrage complet confirmé après écriture **observée par l'API IndexedDB publique en lecture seule** (environ 1,5 s sur un passage). Aucun appel privé FS ni sauvegarde écrite par le test. Un essai de fermeture rapide a perdu la dernière rotation ; une comparaison dédiée à 280 ms/2 s sur l'ancien et le nouveau build a ensuite restauré la rotation dans les quatre cas. C'est une limite temporelle à conserver, pas un succès garanti ou une régression définitivement exclue. Fermer une page avant sa synchronisation reste un cas de risque Web, notamment sur iOS.

Les serveurs locaux écoutent uniquement 127.0.0.1 et n'exposent que les neuf fichiers autorisés. Aucun nouveau build n'a été diffusé sur le tunnel ou un service externe. **Safari physique de cette refonte non exécuté**, Android physique non exécuté ; les observations propriétaires anciennes ne sont pas réattribuées à ce build.

## Performance : ce qui est effectivement mesuré

La scène compte environ **50 141 triangles soumis en comptant les instances**, contre 76 863 pour la composition antérieure, sans changer le 6×6. Pendant les livraisons observées : environ **205–207 appels de dessin**, contre 250–251 dans l'étude précédente. Les compteurs incluent le rendu de présentation et les ombres ; ce n'est pas le nombre d'objets visibles ni une promesse de gain FPS sur téléphone.

Android émulé : mémoire statique Godot d'environ **42–44 Mo décimaux**, hors Java/GPU/surcoût de l'émulateur. Des premiers passages étaient proches de 16,6–17 ms en médiane et 18–21 ms de P95. Le passage final enregistré a aussi présenté une médiane autour de **45,2 ms et un P95 à 84,1 ms** sur 1080×2340 ; les formats suivants étaient proches de 33 ms. Ces valeurs défavorables restent dans les preuves.

Un contrôle sans vidéo ni navigateur, puis un autre après redémarrage du seul AVD, n'a pas permis de conclure à une stabilité : trois médianes autour de 32,4–33,1 ms/P95 36–37 ms avant redémarrage ; ensuite environ 16,7 / 17,7 / 28,3 ms de médiane et **24,1 / 37,8 / 78,0 ms de P95**. L'écran virtuel déclare 60 Hz et l'économie de batterie n'était pas activée. Ce constat ne prouve pas la cause CPU/GPU ni un comportement physique. **Pas de 60 FPS stables déclaré : investigation ciblée de rendu/profiling à poursuivre avant un GO technique global.** Les valeurs détaillées sont conservées, sans sélection d'un seul résultat favorable.

Première image depuis `_ready` généralement entre 1,4 et 3,3 s dans les passages Android, avec caches/chargement/fontes/driver variables ; un premier essai a été plus lent. Cela exclut une partie du lancement du processus et n'est pas un temps froid réseau. Les sorties `am start -W`, marqueurs, tailles d'exports et métriques brutes accompagnent les reçus.

Pas de mesure thermique, batterie, GPU mobile réel, mémoire totale Web ou latence doigt-écran physique. Les valeurs de mémoire 0 du monitor Web ne signifient pas zéro consommation. Les profils vidéo/émulateur et activités parfois simultanées sont des limites de mesure, pas des benchmarks laboratoire.

## Matrice des anomalies et corrections

| ID / priorité | Défaut, reproduction ou limite | Résultat |
|---|---|---|
| UI-01 / P0 | Bandeau après rotation et survol > délai d'infobulle | Cause isolée par contrôle A/B, infobulle supprimée ; description d'interaction préservée, sept états sans recouvrement |
| UI-02 / P1 | En-tête/cadres concurrents, grands vides internes | Nouveau thème/containers, progression principale, consigne séparée, plateau sans ciel ni grand cadre. Les marges externes des écrans très hauts restent assumées plutôt qu'un étirement du puzzle |
| UI-03 / P1 | Rôles postaux petits et similaires | Guichet ouvert à flèche, boîte fermée à enveloppe, lettres/formes A/B ; banc et formats mobiles émulés inspectés. Reconnaissance humaine rapide non démontrée |
| UI-04 / P1 | Victoire et pause superposées | Bilan intégré après réceptions, seul calque modal de pause et focus ; retour au résultat cohérent |
| UI-05 / P1 candidat rejeté | Pause hors écran et minima de texte formés à largeur zéro | Ancrages corrigés et largeur initiale des textes amorcée avant tri des containers ; compact/texte agrandi recontrôlés |
| UI-06 / P1 candidat rejeté | Blancs brûlés puis stries de dalles compactes | Albedos à marge LDR ; suppression de projection d'ombre des dalles statiques, ombres des objets conservées ; preuve compacte et grise |
| UI-07 / P2 | Bouton actif pendant le bref verrouillage d'une rotation | État central montre l'indisponibilité et se réactive au changement du verrou, sans modifier la durée ou la règle |
| QA-01 / outillage | Coordonnées avant tri des containers, appui Android manqué | Observation des rectangles réellement réagencés ; ancien pack Web figé également remplacé pour les tests suivants |
| QA-02 / outillage | Constante JS testée comme propriété de window | Assertion corrigée sur la portée lexicale ; le moteur était bien sans threads |
| QA-03 / outillage | Processus screenrecord interrompu lors d'une perte de connexion ADB | Essai conservé, parcours rejoué après rétablissement ; pas requalifié en succès |
| WEB-01 / réserve | Synchronisation IndexedDB non garantie à fermeture très rapide | Comportement observé et comparaison archivés ; logique conservée, limitation Web à valider physiquement |
| PERF-01 / P1 ouvert | Variabilité Android émulé, jusqu'à 84,1 ms P95, reproduite partiellement sans enregistrement et après redémarrage | **REWORK de stabilité/performance** ; cause non établie, aucun gain FPS physique inventé, pas de changement du solveur pour masquer le résultat |
| ART-01 / réserve | Sobriété matérielle, petits détails de façade et préférence esthétique | Sources modifiables et preuve à taille mobile livrées ; aucune prétention de finition commerciale ou de préférence indépendante |

## Évaluation critique et convergence

Appréciation experte du producteur, grille 0–4 sans total masquant les limites : hiérarchie **4**, réseau **3**, distinction fonctionnelle **3**, cohérence des matières **3**, couches d'état **4**, confort physique **NT**. Le banc et la scène améliorent visiblement le prototype inspecté : ce jugement ouvre une revue de la refonte, pas une acceptation artistique indépendante.

La prochaine décision humaine porte sur cette direction unifiée et ces preuves, pas sur de nouveaux concepts concurrents. Une convergence autorisée pourra cibler finesse des stations à taille téléphone, comportement en lumière réelle et ressenti de rotation/réception. Aucun niveau, progression, compte ou refonte générale supplémentaire n'est engagé. Les cinq joueurs indépendants restent à recruter/exécuter ; aucune session humaine réussie n'est inventée.

Reproduction et édition : [README](README.md). Les conditions des modèles, SVG, grain et fontes sont dans [PROVENANCE](../../../../games/001-switchworks/assets/postal-workshop/PROVENANCE.md). SWITCHWORKS demeure **TEST / HOLD commercial**.

## Livraison reproductible

Archive locale : `games/001-switchworks/build/delivery/switchworks-postal-ui-source.zip`, **412 fichiers, 66 876 914 octets**, SHA256 `62d5f5ca820f9d4115995aa3337e084a8f14178476ae5c7171eca3c0b7a251e2`. Snapshot des sources runtime, assets et preuves au moment de l'emballage ; pas monorepo complet, moteur/SDK/APK/cache ou secret.

L'archive a été contrôlée, extraite dans un dossier neuf sous le workspace puis importée et sa scène démarrée avec Godot 4.7.2 : **codes 0, sans erreur détectée**. `START_HERE.md` donne les commandes directes avec un Godot installé séparément, sans chemin local implicite vers l'installation portable. Les preuves d'archivage sont ajoutées séparément pour éviter une empreinte auto-référente. Ce smoke headless valide le chemin de livraison, pas une performance GPU ni une acceptation artistique.
