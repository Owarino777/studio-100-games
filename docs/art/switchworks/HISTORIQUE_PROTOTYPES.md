# SWITCHWORKS — Reconstitution des prototypes G1, G2 et G3

Date : **14 novembre 2026**. Statut : lecture historique traçable, avant arbitrage produit et direction artistique. Les trois PDF ont été lus **en entier**, texte et pages rendues, après le README des archives. Les sources originales n'ont pas été modifiées. Une spécification ou un compte rendu antérieur décrit une réalisation ; il ne suffit pas à reproduire cette réalisation aujourd'hui.

## Sources et couverture de lecture

| Source archivée | Couverture | Nature |
|---|---|---|
| [Specifications_SWITCHWORKS_G1.pdf](../../historique-projet/03-prototypes/Specifications_SWITCHWORKS_G1.pdf) | Pages 1–4, version 0.1.0, 12 novembre 2026 | Spécification de prototype HTML autonome et première observation prévue |
| [Conception_Recette_SWITCHWORKS_G2.pdf](../../historique-projet/03-prototypes/Conception_Recette_SWITCHWORKS_G2.pdf) | Pages 1–9, version 0.2.0, 13 novembre 2026 | Conception, recette déclarée et protocole de playtest |
| [Conception_Recette_SWITCHWORKS_G3.pdf](../../historique-projet/03-prototypes/Conception_Recette_SWITCHWORKS_G3.pdf) | Pages 1–6, 14 novembre 2026 | Dernier dossier web, évolution visuelle et rappel des conditions commerciales |

Les extractions et rendus de travail sont ignorés par Git. Dans les archives examinées, les fichiers `engine.js`, `app.js`, `levels.json`, HTML autonome, tests Node/Playwright et exports de joueurs **ne sont pas fournis avec ces trois PDF**. Les chiffres de tests ci-dessous sont donc des résultats **rapportés dans les documents**, pas des tests réexécutés pendant cette phase. Les captures présentes dans les PDF sont présentées par leurs auteurs comme issues du prototype exécuté ; leur présence a été inspectée, mais leur provenance d'exécution ne peut pas être reconstituée sans les artefacts et sources correspondants.

## Lecture page par page

| Document / page | Contenu et conséquence pour la suite |
|---|---|
| G1 p.1 | Prototype hors ligne, six niveaux, résultats locaux et avis ; nom non vérifié, stores interdits. Le but est d'observer compréhension et envie de rejouer, pas de prouver une demande commerciale |
| G1 p.2 | Grille **6 × 6**, rails droits/coudes pivotant de **90°**, départs et arrivées fixes, résolution déterministe ; deux flux sur niveaux avancés. Boucle ou connexion ouverte provoque un échec. Architecture web séparant moteur et interface |
| G1 p.3 | Première vague de 5–10 adultes indépendants, observation initiale de 30 s, continuation libre, export volontaire et comparaison alternée avec FOLDSPACE. Pas de rétention/CPI/rentabilité inférables |
| G1 p.4 | Six tests Node et parcours Chromium déclarés ; aucun testeur extérieur ni publication déclaré. Collecte locale, commentaire facultatif limité, pas de récompense sécurisée ; gates stores encore ouvertes |
| G2 p.1 | Passage déclaré à **18 niveaux, 3 districts, 79 tests** ; statut GO pour playtest contrôlé et HOLD Android/iOS |
| G2 p.2 | Adultes occasionnels sur smartphone comme cible hypothétique. Différenciation, plaisir, demande et économie restent à démontrer ; GO/PIVOT/KILL conditionnels |
| G2 p.3 | Un flux puis deux flux A/B, puis **croisement fixe** et **délai de départ 0–4 temps**. PAR est calculé à partir des perturbations de départ, sans preuve d'optimalité globale. Étoiles sensibles aux essais/indices/rotations |
| G2 p.4 | Intention de petite ville de fret nocturne : bleu nuit, voie azur, corail et signal ambré. Contrôles clavier/tactile et lettres A/B, mouvement réduit, son optionnel ; aucune conformité complète revendiquée |
| G2 p.5 | Moteur déterministe, contenu figé, Canvas + boutons HTML, localStorage et export volontaire. Services distants, comptes, monétisation et natif exclus ; confiance locale assumée |
| G2 p.6 | 79 tests et 18 parcours réussis déclarés. **HTML injecté par `page.set_content` et stockage simulé** : cela ne prouve ni le démarrage du fichier livré par un utilisateur ni la persistance après redémarrage |
| G2 p.7 | Protocole de 8–12 volontaires, ordre alterné, premier geste sans aide, arrêt autorisé, notes et verbatim volontaires. Majorité comprenant/souhaitant continuer comme condition exploratoire ; aucune donnée de terrain fournie |
| G2 p.8 | Leçon d'un « premier testeur » qui aurait résolu six niveaux sans erreur ; ne pas assimiler facilité ou code fonctionnel à qualité produit. Ajout de repères non exclusivement colorés |
| G2 p.9 | Développement commercial natif conditionné à un GO externe documenté ; contrats, sécurité, tests physiques et preuves à préparer. Pas une autorisation automatique à industrialiser les 100 jeux |
| G3 p.1 | Jeu de livraison miniature présenté comme prototype web autonome jouable, 18 niveaux ; ni validation commerciale ni prêt stores |
| G3 p.2 | Maintien de la grille 6 × 6 et des pièces à **deux directions** pivotant à 90°. Expédier lance une tentative ; tous les colis doivent atteindre leur bon terminal sans collision. Annulation sans pénalité supplémentaire ; **pas de chronomètre imposé** |
| G3 p.3 | Nouvelle intention chaude : céramique, jardins, maisons, conduits en relief. Palette forêt `#193D3C`, ivoire `#FFF9ED`, sauge `#8CBA9E`, terre cuite `#E58763`, lagon `#44CBBD`. Plateau dès l'entrée, commandes basses sur mobile. Captures mobile et double flux présentées dans le document |
| G3 p.4 | Moteur et niveaux indépendants du Canvas ; progression locale et export volontaire. Clé de sauvegarde G2 préservée **sur une même origine web**. Zéro réseau rapporté pour le scénario, pas garantie anti-triche |
| G3 p.5 | 79 tests, 18 missions, annulation/Ctrl+Z, migration G2 et largeurs 320–1440 déclarés. Limites explicites : pas preuve de terrain, de Safari exhaustif, de performance physique ni de conformité globale |
| G3 p.6 | Tests indépendants toujours à faire ; comparer des concepts avant investissement commercial. Préserver niveaux/sauvegardes/tests, pas 99 déclinaisons ni boutique/publicité/compte sans décision étayée |

## Base de gameplay à conserver pour la préparation artistique

La base historique commune est un **puzzle de préparation d'itinéraires**, pas une simulation de construction ferroviaire libre : observer un plateau, tourner des pièces existantes, expédier, lire le résultat, corriger ou continuer. Les sources et destinations sont fixes ; les raccords valides résultent des deux extrémités de chaque rail droit ou coude. Les trois districts ajoutent progressivement un trajet, un second trajet A/B, puis la synchronisation d'un croisement partagé. Références : G1 p.2 ; G2 p.3 ; G3 p.2.

Le passage de « rails » à « conduits » est un changement de métaphore visuelle entre les documents ; il n'autorise pas à ajouter des embranchements libres. Les termes aiguille/aiguillage employés dans G2 ne suffisent pas à déduire des pièces T ou Y à trois sorties : G3 précise deux directions par conduite. Un croisement fixe du district 03 n'est pas une rotation arbitraire de carrefour.

Pour comparer les trois directions, utiliser un **même plateau 6 × 6** et le même état de jeu, avec deux flux A/B au maximum dans le scénario de référence. Les colis, gares et connecteurs doivent exprimer la rotation de 90°, les cases fixes et la préparation avant expédition. Le délai de départ ne doit apparaître que sur une mission de synchronisation clairement identifiée. Un écran de sélection artistique ne constitue pas un niveau jouable validé ou résolu par un solver.

## Divergences, incertitudes et résolution proposée

| ID | Écart ou point à ne pas confondre | Traitement de référence |
|---|---|---|
| H-P01 | G1 prévoit 6 niveaux (p.1–2), G2/G3 en rapportent 18 (G2 p.1/3, G3 p.2/5) | Évolution de périmètre, pas coexistence de deux cibles ; conserver la progression 3 × 6 comme hypothèse héritée à vérifier sur les fichiers de niveaux quand ils seront disponibles |
| H-P02 | G1 p.4 dit aucun joueur extérieur ; G2 p.8 mentionne un premier testeur sans statut ni relevé | L'observation peut concerner l'auteur ou un test antérieur non documenté. Ne pas l'appeler validation indépendante ni déduire la difficulté ressentie d'un échantillon inconnu |
| H-P03 | G2 p.4 choisit nuit/azur/corail ; G3 p.3 choisit ville chaude/céramique/forêt/ivoire | G3 est la dernière intention archivée. La piste nocturne reste une alternative à comparer, pas le style historique définitif ; une refonte doit expliquer le gain attendu |
| H-P04 | G2 p.6 décrit des tests par injection et stockage simulé ; G3 p.5 annonce reprise G2 sans décrire ici le support d'exécution | Conserver les résultats comme recettes déclarées, avec leur portée. Ne pas transformer une déclaration G3 en preuve de persistance ou de distribution sur appareil réel |
| H-P05 | Les PDF parlent de 79 tests du moteur et 18 niveaux ; le dépôt Godot courant contient une mire et 36 contrôles de bootstrap | Les 36 contrôles ne sont pas un portage des 79 tests et ne prouvent aucune règle de routage. Ne pas afficher « 18 niveaux implémentés dans Godot » |
| H-P06 | G2 p.9 et G3 p.6 suspendent l'industrialisation native à des preuves produit ; la décision actuelle a choisi un socle Godot | La décision récente du propriétaire autorise le socle technique et la préparation artistique. Elle ne prouve pas le plaisir, la demande, la monétisation ni un GO commercial. Ne pas développer le jeu complet par déduction |
| H-P07 | G1 collecte un temps de réussite (p.1/3) ; G3 n'impose pas de chrono (p.2) | Une mesure d'observation n'est pas un compte à rebours de gameplay. Pas de timer de pression dans le HUD sans décision explicite |
| H-P08 | G2 définit PAR à partir du mélange initial (p.3) | Écrire « référence » plutôt que « minimum optimal » tant qu'un solver n'a pas certifié ce minimum |
| H-P09 | G3 p.4 conserve une clé localStorage sur même origine ; le futur natif utilise un autre stockage | Spécifier un import/export volontaire et une migration de schéma avant tout portage de sauvegarde. Aucune migration automatique navigateur → Godot n'est établie |
| H-P10 | Nom SWITCHWORKS déclaré non vérifié (G1 p.1), intérêts concurrentiels toujours hypothétiques (G2 p.2, G3 p.2) | Vérifier nom et positionnement séparément ; aucun verdict juridique ou d'originalité commerciale n'est déduit des propositions artistiques |

## Conséquences pour les trois directions

| Proposition | Héritage réutilisable | Transformation à expliciter | Points à bloquer avant une tranche native |
|---|---|---|---|
| **A — Atelier 17, finale v5** | Miniature logistique, relief des raccords, préparation/expédition | Instrument gris clair/cobalt en aluminium et polymère ; la première piste bois/laiton/émail a été abandonnée après comparaison concurrentielle | Pièces à deux connexions, rotation lisible, pas de levier T/Y qui change la règle ; renforcer la sélection claire sur rail et fond clairs |
| **B — Archipel Postal** | La céramique, la chaleur et l'idée d'un petit réseau de livraison prolongent G3 p.3 | Remplacer la ville/jardin par des quais de porcelaine et supports de papier ; ce déplacement d'univers est une proposition, pas une fidélité exacte au visuel G3 | Les ponts ne doivent pas suggérer des connexions absentes ou une physique aérienne ; la grille 6 × 6 doit rester perceptible ; pas d'architecture impossible empruntée à Monument Valley |
| **C — Nuit de Service** | Reprend l'hypothèse nocturne G2 p.4 avec une matérialité plus professionnelle | La nuit n'est pas le dernier choix G3 ; justifier son gain sur la lisibilité et le ton, sans se réduire au néon | Rails matériels et flux A/B, pas carte Mini Metro ; contrastes, motifs/lettres et états sans dépendance à une lueur ; pas de chrono de pression |

Les trois propositions peuvent renouveler palettes, matière, cadrage, HUD et animation sans modifier les contrats hérités. Toute troisième destination active, pose libre de voie, bifurcation T/Y pivotante, nouvelle ressource ou timer contraignant doit être étiqueté **nouvelle mécanique proposée**, puis arbitré et testé séparément. Une image attrayante dont les connexions ne peuvent pas exister selon les règles n'est pas un écran de gameplay de référence conforme.

## Planche originale de comparaison : NATIVE-EXEMPLE-01

Aucun fichier de niveau historique n'est récupérable dans les PDF. La [planche 6 × 6](EXEMPLE_PLATEAU_6X6.json) est donc une **proposition originale conforme aux règles documentées**, et non une reconstitution prétendument exacte du niveau 07 ou d'une capture G3. Lignes et colonnes sont numérotées de 1 à 6 ; `EW` est une voie horizontale, `SW` un coude reliant sud et ouest, etc. Les cases vides restent vides.

| Ligne | Col.1 | Col.2 | Col.3 | Col.4 | Col.5 | Col.6 |
|---|---|---|---|---|---|---|
| 1 | vide | vide | vide | vide | vide | vide |
| 2 | Source A fixe, EW | EW | SW | vide | SE | Destination A fixe, EW |
| 3 | vide | vide | NE | EW | NW | vide |
| 4 | vide | SE | EW | SW | vide | vide |
| 5 | Source B fixe, EW | NW | vide | NE | EW | Destination B fixe, EW |
| 6 | vide | vide | vide | vide | vide | vide |

Le tableau montre les orientations **après préparation, avant expédition** : zéro livraison accomplie sur deux, un colis A à sa source et un colis B à la sienne, case `(ligne 2, colonne 3)` sélectionnée. L'état initial du JSON remplace les deux coudes SW de `(2,3)` et `(4,4)` par SE. Une rotation horaire de 90° de chacun de ces deux coudes, puis « Expédier », produit les trajets suivants :

- A : `(2,1) → (2,2) → (2,3) → (3,3) → (3,4) → (3,5) → (2,5) → (2,6)`.
- B : `(5,1) → (5,2) → (4,2) → (4,3) → (4,4) → (5,4) → (5,5) → (5,6)`.

Le [validateur Python conservé](validate_reference_board.py) a contrôlé **7/7 assertions** : deux ports par pièce ; échec des deux trajets dans l'état initial ; A seul corrigé après la première rotation ; deux livraisons après les deux rotations ; routes disjointes ; retour à l'identique après quatre rotations ; refus de faire tourner une station fixe. Reproduction depuis la racine : `python docs/art/switchworks/validate_reference_board.py`, sans dépendance externe. Chaque route parcourt huit cases. La liste de commandes est un témoin de résolubilité ; aucune optimalité globale ou difficulté pour de vrais joueurs n'est démontrée. Aucun moteur de jeu complet n'est ajouté au projet Godot.

## Recette des concepts exploratoires v1 après lecture des archives

Les images [A v1](concepts/a-atelier-17-v1.png), [B v1](concepts/b-archipel-postal-v1.png) et [C v1](concepts/c-nuit-de-service-v1.png) ont été inspectées visuellement. Elles sont conservées comme explorations antérieures à la reconstruction complète des règles, et **supersédées pour la référence de gameplay**. Le label « concept art — non implémenté » est présent sur chacune. Aucune n'est une capture Godot.

| Contrôle expert v1, échelle 0–4 | A — Atelier 17 | B — Archipel Postal | C — Nuit de Service |
|---|---:|---:|---:|
| Cohérence des matériaux et de l'éclairage dans l'image | 4 | 4 | 4 |
| Distinction de la famille rail/colis/station/HUD | 3 | 3 | 3 |
| Lecture du type de livraison, hors fidélité aux règles | 3 | 3 | 3 |
| Conformité mécanique à la grille et aux pièces historiques | **0 — bloquant** | **0 — bloquant** | **0 — bloquant** |
| Ergonomie réellement testée au toucher | non testé | non testé | non testé |
| Fidélité d'une implémentation dans le moteur | non testé | non testé | non testé |

Défaut commun : trois destinations A/B/C, aiguillages de type Y/T à leviers, absence de grille 6 × 6 contrôlable et commande « pas à pas » suggérant une mécanique supplémentaire. A v1 ajoute une graduation verticale sans fonction historique définie. Les lettres et formes doublent les teintes, mais ne corrigent pas cette divergence de règles. Ces images peuvent aider à choisir une matière ou un ton ; elles ne sont pas recevables comme planches conformes de la mécanique G3. Les variantes v2 doivent être évaluées séparément contre `NATIVE-EXEMPLE-01`.

## Audit intermédiaire conservé : A v3, B v3 et C v2

La révision [A v2](concepts/a-atelier-17-v2.png) a également été inspectée puis conservée : elle montrait **sept lignes pour six colonnes**, avec une rangée vide supplémentaire entre les trajets et la source B à la ligne 6. Elle est supersédée par A v3 pour le respect de la grille. [B v2](concepts/b-archipel-postal-v2.png) avait les bonnes dimensions et les deux trajets, mais les colis n'étaient pas visibles aux sources ; B v3 corrige cette omission, explicite les entrées ouest des destinations et fonce le libellé d'expédition.

À cette étape intermédiaire, les planches comparées étaient [A — Atelier 17 v3](concepts/a-atelier-17-v3.png), [B — Archipel Postal v3](concepts/b-archipel-postal-v3.png) et [C — Nuit de Service v2](concepts/c-nuit-de-service-v2.png). **Toutes ont été inspectées visuellement**, sans modification des images par cet audit. Ce sont des concepts, pas un jeu Godot exécuté. Les labels « concept art — non implémenté » sont visibles. **A v3 est maintenant supersédée** ; la [QA finale A v5 / B v3 / C v2](QA_CONCEPTS_2026-11-14.md) remplace ce tableau pour l'arbitrage actuel.

| Contrôle expert, échelle 0–4 | A v3 | B v3 | C v2 |
|---|---:|---:|---:|
| Cohérence de matière, lumière et finition dans l'image | 4 | 4 | 4 |
| Lecture visuelle de l'objectif, de la rotation et des deux flux | 3 | 3 | 3 |
| Conformité visuelle à la grille 6 × 6 et aux voies à deux ports | 3, réserves sur les ports de réception | 3, entrées de réception plus explicites | 3, réserves sur les ports de réception |
| Distinction artistique par rapport aux références inspectées | **2, risque Parcel Flow à lever** | 3 | 3 |
| Affordance des stations sources/destinations | 2, fente frontale ambiguë | 3, flèche source et entrée ouest lisibles | 2, fente frontale ambiguë |
| Ergonomie tactile, contraste mesuré et typographie native | non testé | non testé | non testé |
| Animations, performance et fidélité d'un rendu dans le moteur | non testé | non testé | non testé |

La topologie globale des deux routes, les positions A/B, les coudes sélectionnés et les compteurs `02` rotations / `00` essais / `0 sur 2` correspondent visuellement au scénario préparé. Aucun troisième flux ou aiguillage Y/T n'est montré. Ce contrôle est une **lecture experte de l'illustration** : il ne transforme pas le raster en niveau exécutable. La preuve de résolubilité appartient au JSON et à son validateur, pas aux pixels générés.

Réserves concrètes avant fabrication des assets de la tranche :

- **A v3 :** rendre l'entrée ouest des deux destinations explicite, sans une fente frontale qui suggère une arrivée par le sud. Donner une silhouette et un marquage de colis plus lisibles à petite taille. Réduire la proximité du vocabulaire combiné bois / bleu-vert / ivoire / vis dorées observé chez Parcel Flow ; changer seulement les couleurs ne suffira pas.
- **B v3 :** conserver les deux colis visibles. Harmoniser leurs sceaux : le colis B porte un médaillon rond marqué B alors que sa destination utilise un triangle B ; les lettres/couleurs se correspondent, mais le code de forme doit devenir invariant dans la famille finale. Contrôler les entrées de rails et les aplats clairs des tuiles après import et compression Android.
- **C v2 :** clarifier l'ouverture ouest des stations de réception et agrandir/distinguer les colis. Éviter que les points lumineux du décor ressemblent à des ports ou des états jouables. Vérifier que le réseau reste lisible sans bloom ni mouvement.
- **Trois pistes :** recomposer tous les textes, compteurs, commandes et focus dans le HUD natif ; ne pas utiliser le texte peint d'un concept comme UI finale. Vérifier 360 × 640 unités, safe areas, tailles de toucher, contraste et réduction du mouvement sur un build. Aucune animation n'a été produite ou chronométrée par ces images.

**Orientation à cette étape intermédiaire, pas décision commerciale :** B était la piste à examiner en premier pour sa continuité avec la céramique et la chaleur de G3, ainsi que son éloignement matériel de l'atelier Parcel Flow. C était un comparateur utile pour la lecture et un ton plus utilitaire. Le risque concurrentiel alors relevé concernait **A v3**, pas la nouvelle A v5. Ce jugement ne remplaçait ni la préférence du propriétaire, ni les tests indépendants, ni un contrôle du nom ou des droits.

## Révision finale d'A : changement de système, puis correction de grille

Après comparaison avec les captures officielles Parcel Flow, A a été redéfinie en instrument aluminium gris clair / polymère cobalt / rails argentés / raccords orange, sans bois, laiton ou émail bleu-vert. [A v4](concepts/a-atelier-17-v4.png), inspectée, avait encore sept rangées et a été écartée pour la fidélité au plateau. [A v5](concepts/a-atelier-17-v5.png), également inspectée, corrige la grille à six rangées et six colonnes tout en gardant ce nouveau langage. Les deux colis sont visibles aux sources et les modules de réception montrent une entrée ouest latérale.

Les concepts actuels sont donc **A v5, B v3 et C v2**. La réduction du risque de proximité visuelle d'A est une observation de comparaison, pas une preuve juridique ou commerciale. Les anciennes images ne sont ni supprimées ni présentées comme finales ; les critères, notes et réserves actuels figurent dans [QA_CONCEPTS_2026-11-14.md](QA_CONCEPTS_2026-11-14.md).

## Acceptation avant la future tranche verticale

1. **Conserver le socle** : ne pas remplacer la mire, ses tests, les archives ou les prototypes web lorsqu'ils seront récupérés. Ajouter le travail natif dans des scènes/modules séparés.
2. **Récupérer les sources historiques** : moteur, niveaux et tests si disponibles ; établir leur version et leurs empreintes avant de porter des comportements. À défaut, reconstruire une spécification de règles avec tests nouveaux, en la nommant reconstruction plutôt que réutilisation du code.
3. **Valider un scénario de référence** : grille 6 × 6, pièces fixes/rotatives identifiées, solutions et échecs contrôlables, A/B non exclusivement colorés, départ volontaire et annuler/redémarrer.
4. **Choisir l'art sur des critères observables** : lecture en 3 secondes, 360 × 640 unités UI, raccords toujours visibles, feedback de rotation, éléments fixes distincts, confort tactile et mouvement réduit. Les grilles de l'étude [Références et conventions](REFERENCES_ET_CONVENTIONS.md) restent applicables, avec ces contraintes historiques.
5. **Préparer le terrain** : les protocoles G1/G2/G3 ne sont pas des résultats. Aucun GO commercial n'est délivré par l'amélioration visuelle, les tests automatisés ou la simple existence d'un build Godot.

## Intégrité et limites de cette reconstitution

Les trois sources PDF restent inchangées ; empreintes SHA256 relevées avant lecture :

- G1 : `055a5e556bbe21adb617bb188e0a7496dea31b21bb3f1494d1b23f43dcd98fdf`
- G2 : `8db19ba5a6d648cb320a09118c1a15fa416b8cd6e68bfaa391e9d83c88dccd9c`
- G3 : `2cb8ce0582423318fe3a3d4d0e16c61dcafebbeccfd1725ee6f59757159ef075`

Couverture : **19/19 pages** extraites et inspectées visuellement. Aucune règle des PDF n'a été injectée dans le code du jeu, aucun test historique n'a été inventé ou annoncé réexécuté et aucun prototype n'a été supprimé. Les contradictions sont consignées, sans modifier rétrospectivement les archives.
