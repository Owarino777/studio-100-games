# SWITCHWORKS — Préqualification produit et concurrence

- Collecte : 14 novembre 2026.
- Décision : **TEST**, conforme à la présélection historique ; **HOLD pour la production commerciale**. La mission actuelle autorise la préparation des directions visuelles.
- Confiance : raisonnable sur l'existence d'une offre de puzzles ferroviaires mobiles ; faible sur la demande pour SWITCHWORKS, son prix et son économie.
- Méthode : `studio-product-discovery`, puis `puzzle` et `level-design` pour distinguer une mécanique testable d'un simple habillage.

## Sources retrouvées et chronologie

Lors du premier inventaire de cette phase, seuls le cadrage technique, l'audit, la recette du bootstrap, l'ADR 0001 et la mire Godot étaient disponibles ; `imports/` était vide. Des archives ont ensuite été ajoutées par le propriétaire sous `docs/historique-projet/`. L'absence d'étude retrouvée au premier passage n'est donc **plus l'état courant**. Les archives sont conservées intactes et les décisions techniques plus récentes ne sont pas écrasées.

Avant cet apport, des recherches connectées en lecture seule ont été effectuées : Drive avec `SWITCHWORKS`, `100 jeux`, `Studio 100`, `SWITCH`, sans résultat pertinent ; Pages n'a proposé que des pages sans rapport, non ouvertes. Ce constat borné ne valait pas preuve d'absence ailleurs. Le dossier d'archives fourni est désormais la source historique retrouvée.

Lecture intégrale effectuée pour `02-marche` : les **41 pages des quatre PDF**, les deux Markdown, le JSON et les deux CSV. Les pages de tableaux déterminantes ont aussi été inspectées en rendu. Les pages citées ci-dessous sont les pages physiques des PDF, dont le texte et les rendus ont été extraits sous les outils locaux ignorés.

| Source historique | Pages / sections déterminantes | Faits, hypothèses et décision à conserver |
|---|---|---|
| [Étude stratégique](../historique-projet/02-marche/Etude_Strategique_Marche_2026.pdf) | p. 1–2, 7–11 | Étude secondaire ; objectif de portefeuille et diffusion éditoriale, pas obligation de publier sans potentiel. Aucun jeu validé. Les repères CPI/rétention utilisent des populations externes différentes ; aucune économie SWITCHWORKS mesurée. |
| [Préqualification du jeu 001](../historique-projet/02-marche/Prequalification_Commerciale_Jeu_001.pdf) | p. 1–5, notamment 1 et 4 | Cette fiche traite d'abord **PHASE SHIFT**, classé HOLD, puis de trois familles à comparer. Elle n'est pas une validation de SWITCHWORKS. |
| [Benchmark des cinq concepts](../historique-projet/02-marche/Benchmark_5_Concepts_Jeux_Mobiles_2026.pdf) | p. 2–3, 6, 11–17, 20 | SWITCHWORKS priorité 1 TEST ; FOLDSPACE priorité 2 TEST. Les scores sont des jugements pondérés C/D, pas des probabilités ni un A/B réalisé. Les flèches et blocs sont écartés en leur forme actuelle malgré leurs scores. |
| [Protocole terrain G1](../historique-projet/02-marche/Protocole_Validation_Terrain_G1.pdf) | p. 1–4 | Deux concepts à comparer, trois mini-scènes par concept, ordres AB/BA, entretiens et tests envisagés ; aucun test réalisé dans ce lot. |
| [DEC-001](../historique-projet/02-marche/DEC-001_selection_commerciale.md), [JSON de décision](../historique-projet/02-marche/Protocoles_choix_et_mesure.json), [matrice CSV](../historique-projet/02-marche/Matrice_decision_5_concepts.csv) | Décisions 1–7 ; `research`, `weights`, `concepts` ; cinq lignes | La sélection commerciale reste provisoire. Recalcul indépendant : poids total 100, scores 81 / 78,5 / 77,5 / 70 / 67 tous conformes ; aucune réévaluation subjective silencieuse. |
| [Grille de collecte vierge](../historique-projet/02-marche/Grille_collecte_G1_vierge.csv) | En-tête seul | **Zéro ligne de participant** ; le JSON confirme zéro entretien, zéro campagne, rétention non mesurée. Un protocole fourni n'est pas un protocole exécuté. |

Les anciens documents citent parfois les noms `Benchmark_Expert_5_Concepts_Jeux_Mobiles_2026.pdf` et `Protocole_Terrain_G1_et_Scripts_Creatifs.pdf`. Dans le lot archivé, les fichiers correspondants sont nommés `Benchmark_5_Concepts_Jeux_Mobiles_2026.pdf` et `Protocole_Validation_Terrain_G1.pdf`. Cette correspondance documentaire est signalée ; les liens internes historiques ne sont pas réécrits dans les sources.

La fondation Godot opérationnelle prouve une capacité de démarrage technique. Elle ne prouve ni l'amusement, ni l'intention d'achat, ni la capacité d'acquisition de joueurs. Aucune recherche ci-dessous ne doit être présentée comme une validation commerciale du jeu.

## Segment et promesse à tester

**Hypothèse de segment :** adultes jouant sur téléphone à des puzzles de logique courts, qui apprécient l'anticipation d'un système et la possibilité de corriger une décision sans pression de réflexe. Le benchmark historique propose France puis extension internationale, portrait et sessions courtes (p. 3) ; ce point d'entrée reste exploratoire. Sous-segments à comparer : habitués des puzzles de trajet et joueurs occasionnels attirés par une scène logistique compréhensible. Le profil précis, le volume accessible et la disposition à payer ne sont pas établis.

**Promesse candidate alignée sur les prototypes documentés :** « Tournez les rails, reliez les deux bouts du trajet, puis expédiez le colis au bon quai. » Le plaisir supposé est de comprendre une petite machine et de corriger l'orientation des voies. La préférence pour ce rythme face à un jeu en temps réel doit être observée, pas présumée.

## Sept références commerciales mobiles vérifiées

Sources primaires consultées : descriptions de développeurs et fiches officielles Google Play/App Store. Les modèles ci-dessous sont ceux affichés lors de la collecte, principalement sur les vitrines en anglais des États-Unis. Les prix exacts, promotions, notes et classements ne sont pas utilisés : ils varient selon région et date et ne mesurent pas les ventes du studio. Aucun jeu concurrent n'a été acheté ou installé pour cette étude.

| Référence | Boucle et convention documentées | Modèle affiché | Conséquence pour SWITCHWORKS |
|---|---|---|---|
| **Mini Metro — Dinosaur Polo Club** | Tracer des lignes entre stations, réorganiser un réseau face à la croissance et gérer des ressources limitées ; modes de rythme différents et mode daltonien annoncés. | Achat initial, Play Pass ; la description annonce absence de publicité et d'achats intégrés. | La lisibilité du réseau et les options de rythme sont des conventions pertinentes. Reprendre ses cartes abstraites, symboles et composition distinctive ne définirait pas une identité propre. [Google Play](https://play.google.com/store/apps/details?hl=en_US&id=nz.co.codepoint.minimetro) |
| **Railbound — Afterburn** | Poser, enlever et rerouter les rails pour raccorder des wagons à la locomotive, avec aiguillages, barrières et tunnels. | Achat initial, Play Pass. | « Rails + aiguillages + bonne arrivée » est déjà occupé. Notre promesse ne peut pas se résumer à ce vocabulaire. [Google Play](https://play.google.com/store/apps/details?hl=en_US&id=com.Afterburn.Railbound) |
| **Cosmic Express — Draknek** | Planifier une route ferroviaire dans des colonies ; transport de passagers avec contraintes de séquence selon la progression. | Achat initial ; la fiche annonce absence de publicité et d'achats intégrés. | Le transport vers une destination et les contraintes d'ordre ne sont pas, seuls, une différenciation. [App Store](https://apps.apple.com/us/app/cosmic-express/id1152474226) |
| **Spooky Express — Draknek & Friends** | Dessiner un trajet, transporter différents passagers vers leur destination, capacité limitée et voie ne se croisant pas ; dioramas thématiques. | Essai gratuit puis déblocage complet par achat unique, sans publicité annoncé. | Un essai suivi d'un achat complet existe dans la catégorie ; il ne prouve pas que notre jeu convertirait. Un univers cosy et un thème de livraison ne suffisent pas à distinguer les règles. [Google Play](https://play.google.com/store/apps/details?id=express.spooky), [site du développeur](https://spooky.express/) |
| **Train Conductor World — The Voxel Agents** | Contrôler un trafic rapide, embranchements, destinations et collisions ; développement d'un réseau et personnalisation annoncés. | Installation gratuite, publicités et achats intégrés signalés. | Le risque de collision et l'aiguillage en temps réel existent déjà. Un rythme de planification pourrait se différencier en confort, si les joueurs le perçoivent. [Google Play](https://play.google.com/store/apps/details?hl=en_US&id=com.thevoxelagents.tc3) |
| **Railways — Infinity Games** | Arrêter temporairement un train au toucher et changer son trajet par glisser, collecter les passagers et éviter les collisions. | Achat initial, Play Pass. | La précision de la cible tactile doit être évaluée séparément de la difficulté du puzzle. [Google Play](https://play.google.com/store/apps/details?hl=en_US&id=com.infinity.railways) |
| **Parcel Flow: Route Puzzle — ByteEra Labs LLC** | Atelier miniature de colis vers des docks correspondants ; tracé continu du trajet puis relâchement ; mécanismes de voies et queues annoncés. La fiche confirme la proximité de thème et de geste signalée historiquement. | Publicités, achats intégrés et suppression de publicités annoncés ; aucun résultat économique du titre vérifié. | **Risque direct prioritaire** : ni « colis + atelier + portrait », ni tri par destination ne suffisent à différencier. Ne pas reprendre son geste de tracé, sa composition ou sa finition distinctive. [Google Play](https://play.google.com/store/apps/details?id=com.byteeralabs.parcelflow) |

Les monnaies, packs et offres internes n'ont pas été inspectés dans les applications. L'absence d'un badge de publicité sur une fiche n'est pas utilisée comme preuve générale d'absence de publicité ; seules les déclarations explicites ci-dessus sont reprises.

## Avis consultés : signaux qualitatifs, sans généralisation

Échantillon de convenance : uniquement les avis visibles sur les fiches accessibles, aucun échantillonnage représentatif. Ils décrivent une expérience datée et ne prouvent pas l'état actuel de l'application. Les observations ci-dessous sont paraphrasées, sans note de sentiment calculée.

| Référence / avis visible | Signal favorable | Friction ou limite à investiguer chez nous |
|---|---|---|
| Mini Metro — avis des 30 août et 15 septembre 2022 | Apprentissage rapide, réflexion et intérêt du paiement sans publicité appréciés. | Demande de davantage de variété exprimée ; ne pas confondre niveaux terminés et rejouabilité prouvée. [Fiche et avis](https://play.google.com/store/apps/details?hl=en_US&id=nz.co.codepoint.minimetro) |
| Railbound — avis des 7 septembre et 2 novembre 2022, réponses développeur en 2022–2023 | Satisfaction à résoudre et cohérence artistique appréciées. | Chaleur et batterie signalées sur certains appareils ; réponses du développeur évoquant réglages/optimisations. Ce n'est pas un diagnostic du build actuel. [Fiche et avis](https://play.google.com/store/apps/details?hl=en_US&id=com.Afterburn.Railbound) |
| Cosmic Express — avis des 28 octobre et 30 décembre 2017 | Satisfaction d'une solution difficile pour certains joueurs. | D'autres rejettent une montée de difficulté trop forte et l'absence d'aide ; segmenter les attentes avant de fixer la courbe. [Fiche et avis](https://apps.apple.com/us/app/cosmic-express/id1152474226) |
| Spooky Express — avis Google Play des 20 août et 24 septembre 2026 | Thème, contraintes simples et aide partielle appréciés. | Un joueur trouve le contenu trop court ; un avis App Store à date abrégée évoque des crashes, sans version vérifiable. La date abrégée n'est pas convertie en date complète inventée. [Google Play](https://play.google.com/store/apps/details?id=express.spooky), [App Store](https://apps.apple.com/us/app/spooky-express/id6738424828) |
| Train Conductor World — avis des 22 mai et 24 octobre 2026 | Retour au jeu et nouveaux contenus appréciés. | Un avis décrit des collisions ressenties comme inévitables et une progression lente ; c'est un signal pour tester justice perçue et lisibilité des causes. [Fiche et avis](https://play.google.com/store/apps/details?hl=en_US&id=com.thevoxelagents.tc3) |
| Railways — avis du 3 juin 2024 et du 16 novembre 2021 | Principe de gestion jugé plaisant. | Des joueurs associent leurs échecs à des commandes manquées et des voies trop proches ; mesurer les erreurs de manipulation plutôt que les appeler « difficulté ». [Fiche et avis](https://play.google.com/store/apps/details?hl=en_US&id=com.infinity.railways) |

## Différenciation candidate à vérifier

Les éléments suivants forment une **hypothèse de combinaison**, pas une revendication d'invention mondiale :

1. Un petit atelier de tri de **colis**, avec destinations identifiées par couleur **et symbole**, plutôt qu'une carte de transports de voyageurs.
2. Une grille **6 × 6**, avec rails droits ou coudés à **deux ports**, tournant de **90°** au toucher ; sources et destinations restent fixes. Le geste ne consiste ni à tracer une voie libre ni à choisir une branche Y/T.
3. Une phase de préparation des orientations puis une expédition volontaire et déterministe ; un ou deux flux A/B selon le district. Le joueur doit pouvoir expliquer la continuité du trajet avant d'envoyer les colis.
4. Une correction locale avec annulation et reprise, accompagnée d'un retour visuel indiquant la cause du mauvais acheminement.
5. Une satisfaction matérielle de réception au quai qui récompense la compréhension, sans exiger de longue animation ou de réflexe.

Le benchmark p. 6 décrivait largement une configuration d'« aiguillages » puis une simulation simultanée réversible, en demandant d'éviter le dessin de trajet de Parcel Flow. Les dossiers ultérieurs précisent la règle : [G1, p. 2](../historique-projet/03-prototypes/Specifications_SWITCHWORKS_G1.pdf), [G2, p. 3](../historique-projet/03-prototypes/Conception_Recette_SWITCHWORKS_G2.pdf), [G3, p. 2](../historique-projet/03-prototypes/Conception_Recette_SWITCHWORKS_G3.pdf). **Le terme générique du benchmark n'autorise pas à remplacer les rails rotatifs par des embranchements.** Notre préparation ne revendique pas une nouvelle découverte de cette mécanique. Le point à défendre reste sa qualité de lecture et de correction. Les trois directions artistiques doivent montrer le même problème, avec au maximum deux flux et les mêmes règles.

| Périmètre documentaire actuel | Extension hypothétique, non incluse d'office |
|---|---|
| Droites/coudes à deux ports, rotation 90°, grille 6 × 6, sources/destinations fixes. | Pièces Y/T, bascule de branche ou placement libre de rails : changement de mécanique à justifier et tester séparément. |
| District 01 : un colis ; district 02 : deux flux A/B. | Un troisième colis/flux ou de nouveaux types d'objet : non représentatifs du niveau de référence. |
| District 03 : croisement **fixe** et départ décalable de **0 à 4 temps** (G2 p. 3). | Prévisualisation temporelle au pas, curseur de temps ou pause pendant la résolution : extension non prouvée par ces dossiers. |
| Annuler la dernière action et relancer une tentative. | Retour temporel à n'importe quel instant de simulation : ne découle pas de l'annulation des rotations. |

Les versions visuelles préparées avant lecture des archives qui montrent trois flux ou une branche Y/T doivent être conservées comme essais écartés, pas utilisées pour tester la compréhension du cœur documenté. Une illustration conforme ne prouve toujours pas un portage fonctionnel dans Godot.

La fiche actuelle Parcel Flow confirme le besoin d'une comparaison directe avant production. Son existence ne prouve ni son succès, ni une absence de place pour SWITCHWORKS ; elle retire simplement toute justification à présenter le thème comme une preuve d'originalité.

## Hypothèses commerciales encore non démontrées

- Il existe une audience accessible pour notre combinaison, au-delà des amateurs de trains déjà servis.
- Le thème des colis attire ce public et ne fait pas percevoir le jeu comme une simulation de travail répétitive.
- L'observation des rails et leur rotation produisent des choix intéressants plutôt qu'une procédure évidente ; une éventuelle prévisualisation temporelle au pas demeure une extension à tester séparément.
- Le confort d'un rythme posé crée une préférence mesurable face aux alternatives existantes.
- Une personne comprend l'intérêt depuis un écran ou une courte séquence sans explication orale.
- Le plaisir tient au-delà des premiers niveaux et justifie une intention de revenir.
- Un modèle commercial acceptable pour le public finance contenu, acquisition, support et maintenance.
- La production de niveaux et d'assets conserve une qualité stable à un coût soutenable pour ce studio.

Aucun CPI, CAC, revenu, conversion d'achat, rétention, LTV ou volume de marché SWITCHWORKS n'a été mesuré. Aucune estimation de tiers n'est substituée à ces mesures. Les données de concurrents ne permettent pas de calculer nos revenus ou notre rentabilité.

## Décision et prochaines preuves

**TEST** : conserver trois propositions visuelles selon la mission actuelle, tester la compréhension et préparer le périmètre d'une tranche native limitée. **HOLD commercial** : jeu complet, plan de revenus, campagnes payantes, achats intégrés, production massive de niveaux et engagement irréversible du programme des 100 jeux.

Le benchmark p. 6 envisageait indices vidéo volontaires et cosmétiques ; notre revue ajoute comme options à étudier l'achat initial et l'essai avec déblocage unique. Ce sont des hypothèses commerciales concurrentes, **pas un changement de modèle approuvé**. Le besoin d'un SDK monétaire n'est pas démontré. Les chiffres sectoriels des archives ne sont pas repris comme prévision : le rapport AppMagic courant confirme une méthodologie d'estimation sur App Store/Google Play et des données 2023–2025 enregistrées au 15 janvier 2026 ; l'URL AppsFlyer historique n'a pas pu être relue lors de cette passe. Les valeurs archivées restent des repères externes à revalider avant usage économique. [Méthodologie AppMagic](https://appmagic.rocks/files/view/upload/Reports/EN_MobileMarkeLandscape2026.pdf)

Le [registre de tests](SWITCHWORKS_HYPOTHESES_ET_TESTS_2026-11-14.md) précise les questions, tâches, seuils internes et règles de décision à figer avant collecte. Les résultats utilisateurs sont pour l'instant **non réalisés**. Une préférence esthétique, un build qui démarre et les fiches de concurrents ne constituent pas une preuve de vente de SWITCHWORKS.
