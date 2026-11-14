# Programme des 100 jeux — Cadrage de travail à confirmer

- Date : 14 novembre 2026.
- Statut : proposition de gouvernance rapprochée des règles du dépôt **et des archives fournies ensuite par le propriétaire** ; aucune validation commerciale n'est déduite de ces documents.
- Premier projet effectivement identifié : `games/001-switchworks`.

## Ce qui est établi et ce qui ne l'est pas

Le studio vise des jeux originaux et jouables sur mobile, avec des gates produit, art, UX, implémentation, technique et publication dans `AGENTS.md`. Le bootstrap Godot 4.7.2 est validé comme fondation. L'[étude stratégique historique, p. 1 et 6](../historique-projet/02-marche/Etude_Strategique_Marche_2026.pdf) précise déjà que « 100 » est un objectif de portefeuille et que « 1 jour, 1 jeu »/le format éditorial de 67 secondes ne justifient pas de publier un produit non validé. Le nombre ne constitue pas une preuve de concepts sélectionnés, de budget financé, de calendrier soutenable ou de demande pour chaque jeu.

L'inventaire initial et l'apport ultérieur des archives sont détaillés dans la [préqualification SWITCHWORKS](SWITCHWORKS_PREQUALIFICATION_2026-11-14.md). Le lot comprend une étude stratégique, une préqualification initiale centrée sur PHASE SHIFT, un benchmark de cinq concepts et un protocole G1, accompagnés de CSV/JSON/Markdown. Il ne contient pas un catalogue de 100 concepts tous retenus ou des réponses de joueurs. Aucun contrat de financement ou résultat primaire non fourni n'est inventé. Les documents de `01-programme` et les prototypes `03-prototypes` sont rapprochés dans la synthèse générale du dossier ; ils ne sont pas écrasés par la présente proposition.

Le [benchmark, p. 2, 11–13 et 20](../historique-projet/02-marche/Benchmark_5_Concepts_Jeux_Mobiles_2026.pdf), la [DEC-001](../historique-projet/02-marche/DEC-001_selection_commerciale.md) et le [JSON](../historique-projet/02-marche/Protocoles_choix_et_mesure.json) conservent SWITCHWORKS/FOLDSPACE au statut **TEST**, ARROW CASCADE/BLOCK GARDEN écartés en l'état et WORD MOSAIC en réserve. Le score SWITCHWORKS **81/100** est une appréciation pondérée exploratoire, pas une probabilité, un achat observé ou une autorisation de production commerciale. Les cinq scores ont été recalculés indépendamment et concordent avec le CSV ; la grille de participants est vierge.

## Principe proposé : une décision vérifiable avant une production supplémentaire

Maintenir un seul projet au stade de tranche verticale active tant que la capacité réelle du studio n'est pas mesurée. Préparer une liste courte d'opportunités futures sans créer 100 coquilles de jeu ni une architecture générique pour des besoins imaginés. Les composants partagés ne passent dans `shared/` qu'après un deuxième usage concret, avec leurs consommateurs documentés.

Chaque jeu garde une fiche d'une page : public supposé, promesse, occasion de jeu, concurrence, règle différenciante candidate, moyen de distribution envisagé, risques, effort mesuré, coût de maintenance, preuves obtenues et décision. Les concepts abandonnés conservent leur fiche et leurs prototypes ; aucun archivage ne supprime les anciennes preuves.

## Repères de travail par jeu, distincts des codes historiques

Les archives n'utilisent pas partout les mêmes numéros : l'étude stratégique p. 9 nomme G0 Marché / G1 Concept / G2 Intention / G3 Prototype, tandis que le benchmark p. 17 nomme G0 Dossier / G1 Désirabilité / G2 Jouabilité / G3 Business. La DEC-001 emploie également G1 Désirabilité. Cette variation de nomenclature ne justifie pas de supprimer une étape. Les repères **S0–S6** ci-dessous sont donc locaux à cette synthèse ; les références historiques gardent leur nom, page et signification.

| Gate | Question à résoudre | Preuve attendue | Situation SWITCHWORKS |
|---|---|---|---|
| S0 — fondation | Peut-on lancer, tester et exporter le socle ? | Commandes, logs, paquets et captures du vrai moteur. | Bootstrap validé, avec limites Android natif et iOS consignées dans la recette. |
| S1 — opportunité | Quel public veut quel bénéfice, et quelles alternatives existent ? | Préqualification sourcée et hypothèses testables. | Sept concurrents directs/adjacents revus ; études historiques retrouvées ; demande propre au jeu non démontrée. |
| S2 — cible artistique | Quelle direction rend l'intention claire et désirable ? | Trois propositions comparables, inventaire d'assets, critères et observations de compréhension. | Préparation de trois directions ; choix et tests utilisateurs à faire. |
| S3 — tranche native | La boucle est-elle compréhensible, corrigeable et plaisante ? | Un niveau enseigné, un échec, une réussite et un retour/reprise dans Godot ; tests sans aide. | Le bootstrap Godot reste une mire. Les archives G2/G3 documentent 18 niveaux HTML, dont le portage natif n'est pas réalisé. |
| S4 — comportement | Les personnes reviennent-elles et pour quelle raison ? | Cohorte, définitions et fenêtres fixées avant test ; retours observés sans sélection des seuls réussissants. | Non mesuré. |
| S5 — économie | Le modèle finance-t-il production et exploitation ? | Valeur/prix/coûts/acquisition/marge étayés par des observations et budget approuvé. | Aucun CPI, conversion, revenu ou rentabilité du studio établi. |
| S6 — livraison | Le jeu est-il utilisable et publiable sur ses cibles ? | Recette physique, performance, confidentialité, droits, signatures, stores, support et rollback. | Hors scope actuel ; iOS non exécuté. |

Un GO à S0 n'accorde pas automatiquement un GO à S1–S6. Une préqualification réussie ne vaut pas validation commerciale. Une direction artistique choisie n'est pas une preuve de fonctionnement ; une capture du moteur ne prouve pas une vente. La comparaison de trois styles pour SWITCHWORKS n'exécute pas le test historique de deux concepts SWITCHWORKS/FOLDSPACE.

Les politiques actuelles Apple 4.3 et Google Play sur les contenus répétitifs confortent le besoin d'une valeur propre à chaque produit. Elles ne donnent pas une autorisation automatique dès qu'une palette change. Leur applicabilité au produit réel sera revue avant toute soumission. [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), [Google Play — Repetitive Content](https://support.google.com/googleplay/android-developer/answer/9899034)

## Matrice de sélection proposée

Pour chaque opportunité, fournir les éléments suivants sans agréger les inconnues en note flatteuse :

| Dimension | Observation à conserver | Traitement des inconnues |
|---|---|---|
| Public et besoin | Entretiens, comportements ou sources précises. | Écrire « hypothèse », pas « marché validé ». |
| Différenciation | Comparaison des règles et bénéfices, pas seulement du thème. | Déclencher une recherche ciblée, puis tester le rappel libre. |
| Compréhension et ergonomie | Tâches sans aide sur appareil. | Bloquer la production large si les commandes centrales restent ambiguës. |
| Effort et capacité | Temps réellement passé sur niveaux, art, code, QA et support. | Aucun planning des 100 jeux calculé avant cette mesure. |
| Risque d'exploitation | Dépendances, services, comptes, données, maintenance et plateformes. | Donner un responsable et un test de réduction de risque. |
| Économie | Prix/offre, coûts, marge et acquisition observés. | Interdire une projection de revenus fondée sur les notes d'un concurrent. |

La priorité revient à la réduction du risque le plus déterminant pour une décision. Produire davantage de visuels n'est pas la bonne action si l'incertitude principale est la compréhension de la règle ; ajouter une boutique n'est pas la bonne action si le retour au jeu n'existe pas.

## Dossier minimal de preuve et traçabilité

Chaque décision GO/PIVOT/HOLD/KILL consigne auteur, date, sources, version testée, hypothèse, protocole, résultats bruts, limites et conséquence sur le scope. Pour SWITCHWORKS, utiliser le [registre d'hypothèses et tests](SWITCHWORKS_HYPOTHESES_ET_TESTS_2026-11-14.md). Conserver les captures conceptuelles comme concepts, les captures moteur avec moteur/version/OS/résolution/scène, et les données utilisateurs dans un espace contrôlé distinct des secrets et du code public potentiel.

Les coûts de production, le nombre de jeux financés, la cadence et les responsabilités restent à décider par le propriétaire sur la base des premiers jalons mesurés. Aucun budget, publication, contact de testeur ou engagement externe n'est pris par ce document.

## Décision recommandée maintenant

Concentrer la mission actuelle sur SWITCHWORKS : comparer les trois directions avec le même problème visuel, sélectionner une cible, puis préparer la tranche native limitée. Conserver le socle et les prototypes existants. Le statut commercial reste TEST/HOLD ; la priorité historique FOLDSPACE n'est pas transformée en validation ou en rejet par absence d'un nouveau test. Les jeux suivants restent au stade de fiche d'opportunité jusqu'à ce que la boucle de décision et la capacité du studio aient produit des preuves utiles.
