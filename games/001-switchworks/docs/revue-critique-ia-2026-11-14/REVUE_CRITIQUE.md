# SWITCHWORKS — Revue critique externe de la tranche « Archipel Postal »

**Date :** 14 novembre 2026  
**Évaluateur :** ChatGPT, distinct de l'agent ayant réalisé la tranche, mais **pas** évaluateur humain externe ni joueur testé.  
**Périmètre :** archive `switchworks-archipel-revue-externe-20261114.zip`, référence Git `d36af097ff169a807639b6ce9c50a9149b91ba3e`, captures Android, concept B, vidéo H.264 de 7,95 s, capture de reprise, notes et matrice d'observation.  
**Décision : HOLD pour acceptation artistique / GO pour une seule passe de correction ciblée.** Statut commercial inchangé : **TEST / HOLD**.

## 1. Contrôles réalisés

- Lecture des documents du ZIP (README, anomalies, performances, décisions, provenance, grille et référence Git).
- Affichage du concept B et des captures non retouchées `01-entree-preparation.png`, `02-gameplay.png`, `03-reussite.png`, `reprise-preparation.png`.
- Inspection de dix images réparties sur la vidéo Android aux temps 0,15 ; 0,50 ; 0,95 ; 1,40 ; 1,75 ; 2,00 ; 2,40 ; 2,80 ; 4,00 et 7,00 s ; vérification de la durée avec `ffprobe`.
- Vérification locale des 11 empreintes SHA-256 et tailles de `PROVENANCE.json` : **11/11 conformes**.

**Non testés ici :** le code Godot, l'APK (absent de l'archive), le toucher réel, les performances GPU, le mode mouvement réduit, la sauvegarde lors d'une exécution, l'accessibilité système et l'expérience sur téléphone physique. Les 36 + 137 + 476 tests proviennent du compte rendu de Codex et ne sont pas réexécutés dans cette revue.

## 2. Notes par critère — appréciation experte sur médias uniquement

Échelle de la grille fournie : 0 impossible, 1 défaut majeur, 2 réserve nette, 3 clair et cohérent, 4 finition convaincante. Ces notes **ne constituent pas des résultats de participants**.

| Critère | Note | Observation contrôlable |
|---|---:|---|
| C01 — But et première action | **2/4** | Instruction pour tourner en dessous du plateau ; aucun objectif initial immédiat « A → A, B → B » assez explicite ; identité « SWITCHWORKS » très dominante. `01-entree-preparation.png`. |
| C02 — Départs et réceptions | **2/4** | Pavillons des deux côtés très similaires ; les colis posés à gauche suggèrent le départ, mais le rôle n'est pas distingué par une signalétique propre. `01-entree-preparation.png`. |
| C03 — Parcours et raccords | **3/4** | Réseaux A bleu et B brun distincts et suivables ; les traverses répétées renforcent le bruit graphique et concurrencent les courbes. `02-gameplay.png`. |
| C04 — Colis A/B | **3/4 provisoire** | Lettres et couleurs visibles sur la capture 1080 px. Validation à taille physique et sans dépendance aux couleurs encore nécessaire. |
| C05 — Hiérarchie du HUD | **2/4** | Marque, sous-titres et bande de compteurs volumineux ; plateau visuellement moins prioritaire que souhaitable ; textes d'aide en doublon, très proches de la bordure inférieure. |
| C10 — Familles et matières | **2/4** | Ciel illustré, tuiles presque uniformes, structures facettées et panneaux plats présentent des traitements incompatibles. Les matières papier/porcelaine/kraft du concept sont peu incarnées dans le moteur. |
| C11 — Ombres et contours | **1/4** | Ombres de pavillons et fleurs très dures, polygonales, avec de forts bords sombres ; elles rompent la douceur voulue. `01-entree-preparation.png`. |
| C12 — Transport et réception | **2/4** | Deux colis se déplacent effectivement sur les rails dans la vidéo, mais l'arrivée se lit principalement au passage `0/2 → 2/2` et au panneau final ; retour local de dépôt insuffisamment distinct. Vidéo vers 1,75–2,40 s. |
| C14 — Identité Archipel Postal | **2/4** | Palette et métaphore présentes, mais la différence de richesse et de finition entre concept et rendu est forte. |
| C06–C09, C13 | **CN/NE** | Nécessitent l'APK sur vrai appareil ou l'interaction non montrée, en particulier l'annulation, la pause/reprise, les safe areas et le mouvement réduit. |

**Il n'est pas pertinent de calculer une moyenne :** les ombres et la compréhension des rôles restent des risques de qualité, indépendamment des bonnes notes de lisibilité des parcours.

## 3. Défauts à corriger — ordre recommandé

### P1. Clarifier les stations et l'objectif sans modifier la mécanique

**Constat :** les pavillons gauche/droite sont presque symétriques et les colis sont le principal indice de départ ; au premier regard, le joueur lit A/A et B/B mais peut manquer la relation expédier → recevoir.  
**Correction :** rendre systématiquement distinctes les stations de départ (guichet/rampe/colis à expédier) et les stations de réception (boîte aux lettres/portail de collecte/réceptacle), en conservant A, B, les indices de forme, l'emplacement et les ports ; utiliser une instruction d'ouverture courte et claire.  
**Acceptation :** sur une capture native présentée trois secondes et sans explication, au moins 4 des 5 testeurs proposés identifient le but, les deux départs et les deux arrivées. Seuil proposé, à valider avant le recrutement.

### P1. Corriger les consignes contextuelles et la reprise

**Constat vérifié :** la vidéo affiche « Touchez une voie pour la tourner de 90° » alors que les commandes d'édition sont désactivées pendant le transport. La capture de reprise affiche « Tournez les voies » après six rotations, alors que le réseau est déjà raccordé.  
**Correction :** états textuels distincts : préparation neuve, préparation restaurée, trajet, erreur, réussite ; afficher une seule instruction pertinente par état ; corriger « essai(s) » en une formulation plurielle naturelle.  
**Acceptation :** tests unitaires sur chaque état + captures Android avant/après ; aucune invite à interagir avec un contrôle verrouillé.

### P1. Refaire le traitement des ombres et unifier les matières

**Constat :** ombres de toit/fleur abruptes et noirâtres, formes facettées. Le concept montre des matériaux doux et plus détaillés que les assets natifs.  
**Correction :** une direction d'éclairage cohérente ; ombres plus douces et contenues sans perte des ports ; amélioration d'une famille de tuiles, d'un toit et d'un colis comme « référence qualité », avant duplication ; ne pas simuler le matériau par un bruit excessif.  
**Acceptation :** comparaison native avant/après au même cadrage sur les ratios de recette ; aucune dégradation mesurable de lisibilité et de performance sur l'émulateur ; test sur téléphone physique ensuite.

### P2. Apaiser et harmoniser les rails

**Constat :** la répétition des traverses blanches est plus visible que le relief des voies ; les deux rails n'ont pas le même rapport aux toitures et aux ports.  
**Correction :** réduire le bruit des traverses, hiérarchiser la voie principale, augmenter la continuité des segments et harmoniser les matériaux des parcours A et B ; préserver les indices de forme.  
**Acceptation :** trajet suivi sans ambiguïté à la taille réelle sur Android, sur les deux flux et avec une capture en niveaux de gris ; aucune altération de la topologie.

### P2. Donner une réception lisible à chaque colis

**Constat :** les colis arrivent au porche, restent visibles devant les pavillons et le passage au bilan final est plus expressif que la réception elle-même.  
**Correction :** feedback local bref (entrée dans la boîte/quai, tampon, petite impulsion de réception et confirmation), indépendant du texte de victoire ; garder une option mouvement réduit.  
**Acceptation :** dans une vidéo en condition normale, arrivée A et arrivée B sont identifiables sans lire le compteur ; les animations ne retardent pas les actions.

### P3. Rééquilibrer l'écran, sécuriser la lisibilité des aides

**Constat :** marque et bande des compteurs attirent beaucoup l'attention ; les zones de ciel entre HUD et plateau sont vastes ; une ligne d'instruction est placée au bord inférieur, près des actions.  
**Correction :** donner plus de place perceptive au puzzle ; réduire le poids de la marque pendant le jeu ; éviter les textes redondants ; positionner les indications dans une zone sûre, compatible avec la navigation gestuelle.  
**Acceptation :** aucun texte collé aux bords ou masqué, sur 1080×2400, 720×1280, 1200×1600 et un Android physique ; cibles tactiles préservées.

## 4. Analyse de la vidéo

- **0,15–1,75 s :** les deux colis avancent distinctement sur leurs parcours, sans confusion majeure de couleur ou de trajectoire dans l'enregistrement. L'indication de rotation est toutefois inadaptée pendant le trajet.
- **1,75–2,40 s :** les colis atteignent les pavillons droits ; le compteur passe ensuite à 2/2 et le panneau de réussite apparaît. L'acte de réception manque de personnalité et le résultat « Réjouer cette tournée » arrive très rapidement.
- **2,40–7,00 s :** écran de réussite immobile dans l'enregistrement ; cela n'établit pas la possibilité ou l'impossibilité de rejouer. Absence de piste audio : aucun avis sur le son.
- **Cadence :** la vidéo est en 720×1600, dure environ 7,95 s et présente des intervalles d'encodage variables. Aucun verdict de 60 FPS constants ou de latence tactile ne peut être inféré.

## 5. Comparaison au concept B

**Conservé :** palette douce bleu/corail/crème, quatre maisons, deux réseaux et boutons du bas, structure générale d'un puzzle à deux colis.  
**Non atteint :** le relief et les matières (glaçure, papier, kraft), la cohérence des ombres, la finition des stations/rails, le charme des interactions et la hiérarchie élégante des commandes.  
**Arbitrage :** le concept B est une illustration de référence et n'est pas une spécification pixel à pixel ; viser une interprétation native cohérente, pas une reproduction exacte. Le rendu actuel évoque davantage une démonstration fonctionnelle stylisée qu'un jeu prêt à commercialiser.

## 6. Décision de jalon

- **GO limité :** autoriser une seule passe de correction des priorités P1 et P2 sur ce niveau, sans ajouter de contenus ni modifier la topologie.
- **HOLD :** ne pas accepter l'identité et l'UX comme finies ; pas de progression vers 18 niveaux, monétisation ou lancement public.
- **Après correction :** réexécuter les tests existants, fournir les nouvelles captures Android strictement comparables et la vidéo, puis organiser un test non guidé sur cinq personnes indépendantes ; cette taille sert à détecter des confusions, pas à prouver une demande commerciale. La validation commerciale et iOS restent séparées.

**Conclusion :** la mécanique apparaît exploitable et les livraisons sont visibles, mais la facture graphique et la clarté de la communication des états sont encore nettement sous le concept retenu. Il est rationnel de corriger la même tranche avant toute extension.
