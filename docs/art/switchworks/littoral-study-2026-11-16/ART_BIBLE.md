# Archipel Postal — étude Céramique littorale

16 novembre 2026. **Candidate à approuver, pas art bible finale.** Une seule composition : le niveau existant `archipel-double-flux-01`, mêmes ports, commandes et règles. Base locale `af5cc28`, branche `art/archipel-postal-littoral-study`. Les anciennes sources et captures restent conservées. Budget additionnel : 0 €.

## Contrat visuel

Un petit bureau de poste littoral construit en céramique, pierre et papier, dont on lit immédiatement les deux tournées.

Trois priorités : **raccords avant décor ; façades et relief réellement modélisés ; objets postaux distincts par rôle**. La richesse porte sur les biseaux, les toitures à éléments courbes, l'auvent, les jambages et les ferrures ; pas sur un bruit de texture à peine visible. Les ombres sont courtes, sous une lumière unique chaude et un remplissage froid faible. Pas de bloom/SSAO requis.

Les lettres A/B/C des variantes de la nouvelle planche 02 ne sont pas les trois directions initiales Atelier 17 / Archipel Postal / Nuit de Service. « Céramique littorale » est ici une sous-piste d'**Archipel Postal, ancienne direction B**, pas une sélection d'Atelier 17. Ni la mention « recommandée » de l'image ni cette étude ne remplacent l'approbation du propriétaire.

## Lecture contradictoire des deux planches

| Référence | Inspiration retenue | Incohérence / correction de conception |
|---|---|---|
| 01, stations et matériaux | Guichet à auvent, boîte voûtée, émail, socle clair | « A départ / B réception » dans les titres ne définit pas les adresses : le jeu a **deux départs et deux réceptions**, A et B |
| 01, rails | Deux files, traverses régulières, courbes continues | T, croisement et grand rayon ne sont pas des pièces disponibles dans ce niveau ; aucun ajout de règle |
| 01, vue mobile | Plateau central, commandes distinctes | Raccords interrompus, rails qui changent d'écartement et de continuité : reconstruire depuis les masques N/E/S/W, jamais depuis les pixels |
| 02, Céramique littorale | Toiture bleue/corail, pierre et enseigne, boîte distincte du guichet | Mention « recommandée » illustrative : choix de cette étude motivé par la continuité avec Archipel Postal et les critiques du propriétaire, pas par le badge |
| 02, orthographies | Modularité et variations d'états | Les vues ne sont pas cotées et ne sont pas toujours cohérentes ; reconstruire des volumes fermés et des pivots exacts |
| 02, échelle | Lecture tactile et volumes compacts | Bâtiments de 2–2,5 tuiles incompatibles avec les 36 cases : empreinte **< 0,92 case**, hauteur < 0,95 ; signalétique élargie sans chevaucher les ports |
| 02, réception | Clapet, disparition locale du colis, sceau | La façade illustrée regarde le bas alors que l'arrivée réelle vient de l'ouest : ouverture fonctionnelle à l'ouest ; l'enseigne frontale n'est pas une fausse entrée |
| Deux planches | Végétation périphérique et ambiance littorale | Pas de phare, pont, château ou jardin derrière chaque case. Un soubassement insulaire et quelques plantations périphériques suffisent à cette étude |

Les références de conventions déjà étudiées sont reprises de [REFERENCES_ET_CONVENTIONS.md](../REFERENCES_ET_CONVENTIONS.md) : Railbound (réseau avant décor), Mini Motorways (espaces négatifs et masses), inbento (problème / objectif / actions). Ce sont les observations documentées du 14 novembre, pas de nouveaux playtests. Pas de chiens, cartes de métro, boîte-repas, architecture impossible ou atelier de Parcel Flow. La page Afterburn a de nouveau refusé l'accès HTTP 403 ; aucune nouvelle observation n'en est déduite.

## Système de formes, échelle et matières

1 unité = 1 case. Pivot de voie au centre, sol à Y=0, rails au même Y sur chaque bord. Axes +X est, -Z nord. Caméra orthographique oblique, fixe pendant l'action ; elle doit montrer les façades sans cacher les sorties des cases.

| Famille | Silhouette et règle |
|---|---|
| Guichet | Corps maçonné bas, toiture courbe à tuiles, petit auvent rayé, comptoir. Colis préparé à droite, sortie **est** avec flèche. Ne pivote pas |
| Boîte | Corps étroit et voûté, pas d'auvent ; bouche et clapet **ouest**, enveloppe, sceau après réception. Ne pivote pas |
| Voie | Droite N/S ou E/O et coude à 90° uniquement ; deux files et même écartement, extrémités exactement sur les milieux de côtés. La couleur ne décide pas du trajet |
| Tuile | Pierre crème à arête émaillée arrondie ; joint sombre étroit, dessus calme, sélection externe indépendante du rail |
| Colis | Petit carton à rabats/ruban. A : bleu + cercle + lettre ; B : terre cuite + triangle + lettre. Aucun wagon, fumée ou train inventé |

Palette : encre `#173B54` (texte/rails), crème `#F5E7C9` (sol/étiquettes), pierre `#D9C6A6` (soubassement), bleu émail `#347AA6` (A), terre cuite `#C96D4B` (B), abricot `#F4B56A` (action), sauge `#759A70` (décor), succès `#3E7557`. A/B restent des adresses, pas des codes départ/arrivée.

Six familles PBR, valeurs de départ à contrôler dans Compatibility :

| Matière | Roughness | Metallic | Traitement |
|---|---:|---:|---|
| Émail de toiture / arêtes | 0,24 | 0 | Géométrie courbe segmentée, reflet de ciel doux, variation de teinte faible |
| Pierre calcaire | 0,82 | 0 | Biseaux et assises sculptés ; pas de craquelures sur chaque raccord |
| Bois miel | 0,65 | 0 | Petites pièces de comptoir et traverses, jamais fond d'atelier dominant |
| Métal peint | 0,34 | 0,12 | Rails et ferrures ; silhouette sombre sur le sol clair |
| Papier / carton / toile | 0,91 | 0 | Ruban et plis modélisés ; auvent opaque, pas d'alpha coûteux |
| Feuillage | 0,85 | 0 | Quelques feuilles simples à l'extérieur du réseau, saturation modérée |

Les détails de construction sont originaux, rédigés en géométrie et paramètres. Aucun pixel des deux planches n'entre dans les modèles. Aucun service de génération d'images ou DCC payant n'est utilisé. Sources natives Godot `.tscn` + script d'auteur ; échange `.glb`. **Blender non retenu : pas de faux `.blend` livré.**

## HUD et états

Nunito Sans OFL déjà embarquée. Texte natif encre, titre 22–26 unités, mission 16, aide 14, boutons 16–20 ; aucune inscription générée peinte dans le HUD. Une zone de mission, un plateau dominant, une rangée basse d'actions (Annuler / Expédier / Indice) et une pause accessible. Cibles de commandes ≥48 unités logiques ; les cases se mesurent après projection : ne pas promettre 48 si le format compact ne les offre pas. Les petits pictogrammes complètent des libellés, sans les remplacer.

Repos : matières stables ; sélection : coins encre et soulèvement local limité ; rotation : quart de tour 160 ms, arrêt exact ; erreur : case encadrée et message existant ; réception : ouverture puis entrée du colis, fermeture et sceau ; pause : simulation et tweens arrêtés ; mouvement réduit : changement instantané. Aucun mouvement de caméra ni effet qui cache le réseau.

## Critères avant généralisation

- Même niveau et mêmes états logiques ; aucune jonction trompeuse et aucun rail hors de sa case à l'arrêt.
- Guichet/boîte distinguables à 390×844 et 360×640 ; façades visibles, ports non masqués, lettres et formes cohérentes.
- Préparation, échec, réception, réussite et pause capturés dans le moteur ; images brutes, dimensions et scène consignées.
- Une séquence réelle montre rotation et réception ; contrôle de réduction du mouvement et pause/reprise.
- Sources modifiables, exports GLB réellement relus, pivots, matériaux, licence et provenance documentés.
- Mesurer temps de chargement, intervalles de frames, mémoire, triangles et draw calls dans les contextes disponibles. Aucun FPS Android/Safari physique déduit du PC ou de l'émulateur.
- Chaque défaut majeur repéré est corrigé ou entraîne **REWORK** ; résultat visuel = jugement expert à soumettre au propriétaire, pas validation commerciale ni cinq sessions humaines.

Le dernier retour propriétaire sur iPhone (14 novembre) est une entrée critique : matières/relief, rails/bâtiments, interface et démarrage jugés insuffisants. Cette étude vise les premiers points ; elle ne peut déclarer le démarrage Safari corrigé sans mesure sur téléphone. L'utilisateur valide cette composition avant toute extension de la famille ou refonte complète.
