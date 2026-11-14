# SWITCHWORKS — Audit expert des trois concepts finaux

Date : **14 novembre 2026**. Périmètre : **A — Atelier 17 v5**, **B — Archipel Postal v3**, **C — Nuit de Service v2**. Toutes les images ont été ouvertes et inspectées visuellement. Il s'agit de **concept art non implémenté**, pas de captures du moteur, de tests tactiles ou de validation commerciale. Les fichiers de jeu, les tests et les prototypes antérieurs ne sont pas modifiés par cet audit.

## Versions inspectées et traçabilité

| Direction finale | Image | Dimensions du fichier | SHA256 |
|---|---|---|---|
| A — Atelier 17 v5 | [Concept A v5](concepts/a-atelier-17-v5.png) | 830 × 1894 | `7908f918c3620b8e97e384280b0bca55f97e4624450e1311a26c03d9a1fa3d9f` |
| B — Archipel Postal v3 | [Concept B v3](concepts/b-archipel-postal-v3.png) | 830 × 1894 | `c855a0bce6699e8f0540570a6e530f2c74146bd0ed2682e7044570aacd341f55` |
| C — Nuit de Service v2 | [Concept C v2](concepts/c-nuit-de-service-v2.png) | 830 × 1895 | `ab4fe99c48431a156cb4fbc34178cf5caaaf5e969c0ccfaba11037a67dcc010e` |

La [reconstitution G1–G3](HISTORIQUE_PROTOTYPES.md) couvre 19 pages historiques. Les [références commerciales et conventions](REFERENCES_ET_CONVENTIONS.md) distinguent les observations sur des sources officielles de nos propositions de style. Les variantes précédentes restent conservées ; elles ne remplacent pas ces versions finales. A v1–v3 ont été écartées de l'arbitrage actuel après leur proximité matérielle avec Parcel Flow ; A v2 et A v4 comportaient en outre sept rangées. Le défaut commun de règles des v1 est détaillé dans l'historique.

## Conformité du scénario illustré

La base est la [planche originale NATIVE-EXEMPLE-01](EXEMPLE_PLATEAU_6X6.json), construite selon G1 p.2 et G3 p.2. **Ce n'est pas un niveau récupéré des fichiers historiques.** Un validateur Python local a passé 7/7 contrôles de connectivité du JSON ; aucune extraction automatique des règles à partir des pixels n'a été réalisée.

La lecture visuelle des trois finales confirme :

- Six rangées et six colonnes ; sources A en `(2,1)` et B en `(5,1)`, réceptions A en `(2,6)` et B en `(5,6)`.
- Deux trajets séparés suivant globalement la géométrie du JSON ; pièces droites et coudes à deux connexions, sans Y/T pivotant ni troisième flux.
- État préparé avant expédition : deux rotations, aucun essai et zéro livraison sur deux ; le coude `(2,3)` est sélectionné avec un repère de rotation horaire.
- Deux colis visibles aux sources dans les versions finales ; départ volontaire « Expédier », annuler, indice et pause visibles. Aucun compte à rebours contraignant ou mode pas-à-pas n'est ajouté à l'image finale.

Ces observations n'établissent ni une zone de toucher correcte, ni une trajectoire réellement animée, ni la résolubilité d'un jeu exécuté. La spécification JSON reste la référence technique des ports. Les pièces, stations et zones de connexion devront être reconstruites séparément dans Godot.

## Grille expert 0–4

0 : absent/illisible ; 1 : défaut majeur ; 2 : utilisable sous réserve de correction ; 3 : cohérent et clair dans l'image ; 4 : finition visuelle très cohérente dans ce périmètre. **NT** : non testé, sans conversion en note favorable. Aucun total ne doit masquer une réserve. Un score de 2 impose une correction avant livraison native ; il n'interdit pas de comparer des directions conceptuelles.

| Critère | A v5 | B v3 | C v2 |
|---|---:|---:|---:|
| Cohérence de matériaux et d'éclairage de la famille dans l'image | 4 | 4 | 4 |
| Lecture du réseau et de l'objectif à l'inspection | 3 | 3 | 3 |
| Géométrie visuelle 6 × 6 / deux ports / deux flux | 3 | 3 | 3 |
| Sources et réceptions distinguées visuellement | 3 | 3 | **2 — réception à clarifier** |
| Colis et marquages à maintenir dans la famille finale | 3 | **2 — forme du sceau B** | **2 — colis petits et peu caractérisés** |
| Contraste de l'état sélectionné, appréciation visuelle seule | **2 — blanc sur gris clair** | 3 | 3 |
| Éloignement des identités inspectées, appréciation visuelle | 3 | 3 | 3 |
| Contrastes chiffrés du HUD natif / police effectivement embarquée | NT | NT | NT |
| Tactile sur appareil, safe areas et adaptation 360 × 640 | NT | NT | NT |
| Animation, feedback haptique, réduction du mouvement | NT | NT | NT |
| Assets séparés, transparence, pivots et raccords d'atlas | NT | NT | NT |
| Fidélité d'un vrai rendu Godot et performance mobile | NT | NT | NT |

### A v5 — Précision claire et langage révisé

L'aluminium clair, les modules cobalt, les profilés argentés et les raccords orange forment un instrument modulaire cohérent. Les colis portent un repère A/cercle et B/triangle ; les entrées latérales ouest des réceptions sont plus explicites que dans A v3. Le changement ne se limite pas à une recoloration de l'ancien atelier bois/laiton : matière, structure de modules et signalétique ont évolué.

La proximité combinée avec l'atelier chaleureux observé sur les [captures officielles Parcel Flow](https://play.google.com/store/apps/details?id=com.byteeralabs.parcelflow) est **réduite**, sans preuve d'originalité commerciale ou juridique. A v5 constitue une alternative crédible pour un ton de précision/pédagogie. Réserve à corriger : le repère blanc de sélection et le rail argenté sur tuile claire ont besoin d'un contour d'état plus affirmé et d'une mesure dans le moteur, y compris en niveaux de gris.

### B v3 — Continuité chaleureuse avec G3

Porcelaine, papier, petits quais et décor aérien composent une famille distincte. Les deux colis ajoutés restent visibles ; les ouvertures de réception sur le côté ouest clarifient les raccords. Le texte sombre du bouton d'expédition est plus lisible visuellement que le texte blanc de B v2, sans que cette appréciation remplace un ratio de contraste mesuré.

Réserve à corriger : le colis B porte un médaillon rond « B » alors que la station B porte un triangle « B ». La lettre et la teinte se correspondent, mais le code de forme doit être invariant dans les assets de production. Les ornements, fleurs et nuages doivent rester hors des ports et ne pas devenir des indices de chemin. Le cadre d'archipel est une proposition nouvelle ; la continuité avec G3 concerne la céramique et la chaleur, pas la reproduction exacte de sa ville/jardin ou de sa palette.

### C v2 — Logistique de nuit et comparaison utilitaire

La matérialité graphite, les points d'éclairage ambre et les voies claires produisent une ambiance utilitaire sans se réduire à un réseau de néons. Les destinations et les deux voies A/B se distinguent par teinte et symbole/lettre. Cette piste réinterprète l'intention nocturne historique de G2, sans devenir le dernier choix de G3 par défaut.

Réserves à corriger : les ouvertures frontales des destinations peuvent suggérer une entrée par le sud alors que la route arrive de l'ouest ; clarifier cette géométrie. Les colis doivent gagner une silhouette et un sceau plus visibles au téléphone. Les lumières du décor ne doivent pas ressembler à des connecteurs interactifs. Le réseau devra rester lisible avec luminosité réduite et sans bloom.

## Décision d'audit et critères d'entrée dans la tranche

**GO pour comparer les trois directions et demander un choix informé.** Ce GO concerne les concepts, pas le produit ou les stores. **Non validés à ce stade :** une famille d'assets prête à importer, une tranche verticale jouable, l'ergonomie tactile, les animations réelles, les performances et la validation commerciale.

Conseil expert : examiner **B v3 en premier** si l'objectif est de prolonger la chaleur et la céramique de G3 ; comparer **A v5** comme alternative de précision claire, et **C v2** pour un ton utilitaire nocturne. Ce conseil n'est ni un choix accepté par le propriétaire, ni une mesure de préférence des joueurs. La refonte d'A ne justifie plus de reprendre le verdict de risque élevé appliqué à A v3.

Après sélection, avant de qualifier la tranche de livrée :

1. Corriger les réserves listées pour la direction retenue ; figer ports, silhouettes, motifs A/B, palette et vraies polices dans une art bible.
2. Produire les objets de jeu et le HUD en fichiers séparés, avec licences, dimensions, pivots et états documentés. Aucun poster complet ni texte peint ne doit servir d'UI de production.
3. Conserver le modèle déterministe et les contrats hérités : tourner 90°, sources/destinations fixes, expédier, erreur réparable, annuler/redémarrer ; traiter le croisement et son délai seulement dans le périmètre du district concerné.
4. Capturer le vrai rendu Godot aux tailles ciblées et sur l'export Android. Vérifier les raccords après import/compression, les zones tactiles, focus, safe areas, contraste, son optionnel et mouvement réduit.
5. Faire tester la compréhension et l'intérêt par des participants indépendants, sans transformer les notes de cet audit en validation terrain ou commerciale.

## Vérifications réalisées pour ce rapport

Images finales ouvertes avec `view_image`, compte manuel des 36 cases et lecture des chemins/commandes ; lecture des dimensions PNG et calcul SHA256 ; contrôle des liens locaux et de l'encodage UTF-8 ; reprise du validateur JSON 7/7. Aucune image n'a été retouchée par l'auditeur, aucune scène de jeu n'a été ajoutée et aucune publication ou dépense n'a été déclenchée par ce contrôle.
