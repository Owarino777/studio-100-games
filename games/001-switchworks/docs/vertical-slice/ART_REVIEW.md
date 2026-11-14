# Archipel Postal — Revue artistique du rendu Android expérimental

Date : **14 novembre 2026**. Décision de périmètre : B — Archipel Postal est une direction candidate pour une tranche native, sans validation artistique ou commerciale définitive. Cette relecture est séparée de la recette principale ; son auteur a également contribué aux assets. Ce n'est donc ni un avis de joueurs indépendants, ni une acceptation humaine du propriétaire.

## Sources réellement inspectées

Référence conceptuelle : [B v3 — Archipel Postal](../../../../docs/art/switchworks/concepts/b-archipel-postal-v3.png), image générée **non implémentée**, 830 × 1894. La [QA préparatoire](../../../../docs/art/switchworks/QA_CONCEPTS_2026-11-14.md) signalait notamment le sceau B incohérent et les validations natives encore absentes.

Captures natives ouvertes et inspectées avec `view_image` : lot local `artifacts/slice-android/final-20261114T034540868917Z/`, dans ce jeu. Les [copies de preuve durables](evidence/android/receipt.json) sont conservées octet pour octet sous `docs/vertical-slice/evidence/android/` ; les liens ci-dessous permettent de les consulter. Le [rapport de recette principal](REPORT.md) rassemble les contrôles fonctionnels et les mesures séparées de cette revue.

| Image inspectée | Observation dans l'image |
|---|---|
| [Préparation initiale](evidence/android/planning.png) | Grille 6 × 6 non résolue, sources et réceptions A/B, deux colis, commandes et compteurs initiaux lisibles |
| [Réseau préparé](evidence/android/prepared.png) | Routes raccordées après six rotations ; sélection locale et état de préparation identifiables, 0/2 livraison |
| [Colis en route](evidence/android/in-motion.png) | Les deux colis sont visibles à des positions intermédiaires distinctes ; commandes inactives mais noms conservés ; état « en route » explicite |
| [Réussite](evidence/android/won.png) | Colis aux réceptions, compteur 2/2, bilan « Deux colis livrés ! », rotations/essais et relance visibles |
| [Reprise mise en pause](evidence/android/running-resumed-paused.png) | Plan supérieur de pause lisible et contenu dans l'écran, reprise/redémarrage/options identifiables ; contexte de partie conservé derrière |
| [Échec — contrôle complémentaire](evidence/android/failed.png) | Rail concerné encadré en corail et cause en texte ; l'échec ne dépend pas de la seule couleur et les commandes de correction sont présentes |

Le `receipt.json` du même lot identifie l'APK SHA256 **`7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1`**, package `org.studio100games.switchworks.archipel.slice`, émulateur `Studio_API_36`, Android 16/API 36, affichage 1080 × 2400. Le log `app-5236.log` confirme **Godot 4.7.2.stable.official.ed1daf0bf**, renderer Compatibility et OpenGL ES 3.1 via le traducteur de l'émulateur/NVIDIA. Ces métadonnées ont été lues ; cette revue ne constitue pas une nouvelle mesure de performance ou de latence.

Aucun code, asset, réglage d'export ou paquet n'a été modifié pendant cette revue. Les images sont des captures du vrai build ; aucun concept ou rendu de maquette n'est substitué à ces preuves Android.

## Comparer l'intention, sans prétendre à une équivalence pixel à pixel

Le concept présente une préparation graphique à deux rotations, alors que le niveau expérimental natif commence avec six rails désorientés. Les positions de certains colis, la sélection et les nombres d'essais diffèrent donc selon les états capturés. La comparaison porte sur l'identité, les matières et la lecture des règles ; elle ne prétend pas reconstituer un niveau historique ou un état identique au dessin.

| Critère | Constat sur les captures Android | Écart au concept / réserve |
|---|---|---|
| Lisibilité de l'objectif et du réseau | Mission à deux livraisons, compteurs, quatre stations A/B, pièces à deux ports et limites des 36 cases se lisent. Les chemins raccordés sont suivables dans `prepared` ; les ruptures sont visibles dans `planning` et `failed`. | L'image fixe ne mesure pas la compréhension spontanée d'un joueur. Les informations du bas restent proches de la bordure sur cet écran ; refaire un contrôle de safe area sur matériel physique. |
| Signalétique et colis | A est associé au cercle, B au triangle et à sa lettre, aux sources, sur les colis et aux réceptions. Les lettres sont nettement plus grandes que dans les premières captures PC. Un seul signe par station évite l'ancien empilement ; le sceau propre au colis reste utile pendant le transport. | Le texte et les formes restent à tester avec différentes capacités visuelles et luminosités. Les ratios calculés sur les tokens du HUD ne mesurent pas tous les pixels et éclairages 3D. Le glyphe natif ne doit pas être assimilé à un audit TalkBack ou à une conformité complète. |
| Proportions et hiérarchie mobile | Plateau central dominant, HUD séparé des connexions, commandes principales regroupées en bas. Les textes et actions essentiels des panneaux de pause et de victoire sont visibles et lisibles dans les images inspectées. Les colis ont une épaisseur visible et restent distinguables des petits pavillons. | Caméra plus verticale et volumes plus compacts que dans B v3, choix qui protège la grille et les cibles. Ce compromis rend les façades et les plis moins expressifs que dans le concept. |
| Matières | Porcelaine claire, toits de papier bleu/corail, cartons kraft et ciel de papier forment une famille perceptible. Le plateau et les objets ont une géométrie native, avec biseaux et ombres ; ce n'est pas un fond peint faisant semblant d'être jouable. | La porcelaine native est plus beige/mate et son grain moins riche que celui de B v3. Les toits sont plus géométriques et les plis simplifiés. Le rendu n'est pas équivalent au concept haute définition. |
| Cohérence | Même lumière, échelle et langage pour les pièces, colis et stations. Le sceau B rond du concept a été remplacé par un triangle cohérent. Le sens d'arrivée aux réceptions est porté par les rails latéraux et par le repère A/B ; aucun Y/T nouveau n'est montré. | Les détails décoratifs peints, l'ornement floral et la volumétrie fine du concept sont volontairement réduits. Ne pas les déclarer déjà intégrés. |
| Finition | Aucun texte majeur superposé au réseau ou occulté par un toit dans les états inspectés. Les actions et bilans se distinguent ; le cadre sélectionné/invalide utilise une forme locale, pas un flash d'écran. | Ombres assez dures et quelques contours en escalier visibles à la résolution native, surtout autour des pavillons/fleurs. Les doubles rails restent fins. Ce sont des points de polissage à reprendre sur la chaîne matérielle cible, sans défaut bloquant de lecture constaté ici. |
| Sensations visuelles | Les captures intermédiaires montrent que les colis et états visuels ne sont pas une simple image statique. La pause et le résultat possèdent un traitement cohérent avec le reste de l'écran. | Une série d'images fixes ne prouve ni fluidité ressentie, ni easing agréable, ni latence tactile, son ou haptique. Cette relecture n'a pas écouté le son et ne convertit pas les résultats du receipt en avis sensoriel humain. |

## Évaluation dans le périmètre testé

Échelle de l'étude : 0 absent/illisible ; 1 défaut majeur ; 2 utilisable avec correction ; 3 cohérent et clair dans le périmètre observé ; 4 finition aboutie et vérifiée. **NT** signifie non testé, jamais une note favorable. Aucun total n'agrège les inconnues.

| Dimension | Avis expert sur ces images |
|---|---|
| Lisibilité | **3/4** — signes et parcours clairs dans le lot inspecté |
| Proportions / hiérarchie | **3/4** — plateau et commandes lisibles, compromis de caméra explicités |
| Matières | **3/4** — famille reconnaissable, écart de richesse et de glaçure au concept conservé |
| Cohérence des éléments | **3/4** — codes A/B et construction commune, ancienne incohérence de sceau corrigée |
| Finition expérimentale | **3/4** — pas de défaut bloquant nouveau observé, réserves de contours/ombres et détails |
| Fluidité ressentie, latence, son, haptique | **NT par cette revue statique** |
| Préférence des joueurs / acceptation du propriétaire | **Non mesurée / non prononcée** |
| Fidélité parfaite ou qualité commerciale | **Non revendiquée** |

## Verdict et suite

**Revue recevable pour la livraison de cette tranche expérimentale TEST, avec les réserves ci-dessus.** Aucun bloquant artistique nouveau n'a été relevé dans les six captures effectivement ouvertes. Les corrections principales demandées à B sont observables : colis présents, signe B triangulaire cohérent, texte/lettres natifs lisibles, répétition des badges réduite et ports latéraux raccordés.

Cette conclusion ne remplace pas la recette fonctionnelle, les mesures de performance, la vérification des licences ou les tests sur les autres tailles d'écran. Elle n'autorise pas une publication et ne déclare pas la direction définitivement validée. SWITCHWORKS reste **TEST / HOLD** jusqu'aux observations de joueurs indépendants et aux décisions produit nécessaires.

Avant un jalon de diffusion plus large : revoir les ombres/contours sur téléphone physique, vérifier luminosité et safe areas, mesurer les vrais contrastes de tous les états, puis observer rotation, expédition, échec, victoire et reprise en jeu réel auprès de personnes indépendantes. Ne pas ajouter du détail décoratif s'il dégrade la lecture des deux ports ou la taille des commandes.
