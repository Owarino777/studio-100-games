# SWITCHWORKS et programme du studio — Synthèse de référence

Date : 14 novembre 2026. Périmètre : documents historiques fournis pendant la mission, décisions explicites du propriétaire et état du dépôt. **SWITCHWORKS est une piste TEST, pas un produit commercial validé.** Cette synthèse rapproche les sources ; elle ne les remplace pas.

## Corpus lu et niveau de preuve

Le [README des archives](historique-projet/README.md) a été lu en premier. Les **9 PDF, soit 73 pages**, ont été extraits intégralement et rendus pour inspection ; les Markdown, CSV et JSON des trois sous-dossiers ont également été examinés. Les numéros ci-dessous désignent les pages physiques des PDF, concordantes avec leurs pieds de page. Les sources sont conservées octet pour octet ; le [manifeste SHA256 fourni](historique-projet/MANIFEST_SHA256.txt) permet leur contrôle.

| Source | Étendue lue | Repères utiles |
|---|---|---|
| [Programme directeur](historique-projet/01-programme/Programme_100_Jeux_Specification_Directrice.pdf) | 10 pages | p. 1–2 : ambition et hypothèses ; p. 3–6 : plateforme cible ; p. 7–9 : qualité, pipeline, exploitation ; p. 9–10 : sources |
| [Modèle de spécification par jeu](historique-projet/01-programme/Modele_Specifications_Par_Jeu.pdf) | 3 pages | p. 1 : identité/règles/DA ; p. 2 : architecture et preuves ; p. 3 : mission et approbations |
| [Étude stratégique](historique-projet/02-marche/Etude_Strategique_Marche_2026.pdf) | 12 pages | p. 1–2 : étude secondaire ; p. 7–9 : économie, critères et gates ; p. 11–12 : limites et sources |
| [Préqualification du jeu 001](historique-projet/02-marche/Prequalification_Commerciale_Jeu_001.pdf) | 5 pages | p. 1 et 4 : **PHASE SHIFT**, statut HOLD ; ce titre de fichier ne désigne pas une validation de SWITCHWORKS |
| [Benchmark des cinq concepts](historique-projet/02-marche/Benchmark_5_Concepts_Jeux_Mobiles_2026.pdf) | 20 pages | p. 2–3 : méthode ; p. 6 : SWITCHWORKS ; p. 11–13 : classement ; p. 15–17 : économie/tests/gates ; p. 20 : décision |
| [Protocole terrain G1](historique-projet/02-marche/Protocole_Validation_Terrain_G1.pdf) | 4 pages | p. 1–2 : deux concepts et six créatifs ; p. 4 : collecte et décision |
| [Spécifications SWITCHWORKS G1](historique-projet/03-prototypes/Specifications_SWITCHWORKS_G1.pdf) | 4 pages | p. 1–2 : prototype HTML/règles ; p. 3 : terrain prévu ; p. 4 : recette annoncée et limites |
| [Dossier SWITCHWORKS G2](historique-projet/03-prototypes/Conception_Recette_SWITCHWORKS_G2.pdf) | 9 pages | p. 2–4 : hypothèses, règles, nuit ; p. 6 : recette/injection HTML ; p. 7–9 : terrain et leçons |
| [Dossier SWITCHWORKS G3](historique-projet/03-prototypes/Conception_Recette_SWITCHWORKS_G3.pdf) | 6 pages | p. 2 : règle et progression ; p. 3 : petite ville céramique ; p. 4–5 : architecture/recette ; p. 6 : décision suivante |

Le [CSV des cinq concepts](historique-projet/02-marche/Matrice_decision_5_concepts.csv), le [JSON des protocoles](historique-projet/02-marche/Protocoles_choix_et_mesure.json), la [DEC-001](historique-projet/02-marche/DEC-001_selection_commerciale.md), le [README décision](historique-projet/02-marche/README_DECISION.md) et la [grille de collecte vierge](historique-projet/02-marche/Grille_collecte_G1_vierge.csv) complètent les PDF. La grille n'a aucune ligne de participant. Les PDF ne contiennent pas les sources exécutables JS/HTML, les 18 niveaux JSON ou les tests du prototype : ces éléments ne peuvent pas être restaurés ou réexécutés par déduction depuis les captures.

## Chronologie et justifications

| Date / étape | Décision ou constat documenté | Portée actuelle |
|---|---|---|
| 12 novembre — programme | 100 applications distinctes ; Godot proposé, plateforme mutualisée envisagée ; validation humaine et qualité avant publication. Programme p. 1–2 et 8–9. | Ambition de portefeuille. Ni 100 concepts retenus, ni budget, ni cadence financée. Les vidéos de 67 s viennent après un stock de jeux effectivement validés. |
| 12 novembre — sélection | Les notes de marché ne valident pas un jeu ; SWITCHWORKS priorité 1 TEST, FOLDSPACE priorité 2 TEST ; premier produit commercial non sélectionné. DEC-001 §§ Décisions/Condition de révision ; benchmark p. 20. | Priorité de recherche, sans GO commercial. Le nom reste à vérifier. |
| 12 novembre — G1 | Grille 6×6, rotation des rails et simulation ; six niveaux et tests techniques annoncés ; observation externe encore à faire. G1 p. 1–4. | Preuve technique rapportée pour un prototype web. Aucun résultat terrain indépendant fourni. |
| 13 novembre — G2 | 18 niveaux/3 districts ; double livraison et synchronisation ; version web nocturne ; 79 tests annoncés. G2 p. 1, 3–6. | Recette de navigateur contrôlé, pas de build mobile natif ni de validation du plaisir. |
| 14 novembre — G3 | Même cœur, univers chaleureux céramique/petite ville ; annulation, sauvegarde/export locaux ; 18 missions annoncées. G3 p. 2–5. | Révision artistique et UX historique la plus récente. Pas une autorisation de monétisation ou de publication. |
| 14 novembre — dépôt actuel | Choix explicite monorepo, Godot 4.7.2 Standard/GDScript, Android d'abord ; bootstrap testé et validé par le propriétaire. | Décisions techniques actuelles, consignées dans l'[ADR 0001](decisions/0001-socle-godot-mobile.md) et la [recette](RECETTE_BOOTSTRAP_2026-11-14.md). La mire n'est pas un portage des 18 niveaux. |
| Mission actuelle | Premier commit, reprise des archives, trois DA comparables et préparation d'une tranche native après sélection. | Étude et décisions réversibles autorisées ; aucun jeu complet, push, achat ou service commercial. |

## Séparer faits, hypothèses, décisions et validations manquantes

| Catégorie | Éléments établis ou à démontrer |
|---|---|
| Faits documentaires | Les documents, scores, règles, captures et protocoles existent. Les CSV/JSON rapportent zéro entretien/campagne et aucune rétention mesurée. |
| Résultats techniques rapportés | G2/G3 annoncent 79 tests et 18 missions résolues. G2 p. 6 précise `page.set_content` et stockage simulé : pas preuve du démarrage d'une archive chez un joueur ou de sa persistance réelle. Sans sources, ces tests ne sont pas réexécutés ici. |
| Résultats techniques exécutés dans ce dépôt | Bootstrap : 36 contrôles GDScript, lancement Windows et APK sur émulateur, limites natives Android et iOS explicitement conservées. Ce sont d'autres tests, avec un autre périmètre. |
| Hypothèses produit | Adultes occasionnels, sessions courtes, plaisir de planifier, thème colis, lisibilité, différence perçue, envie de rejouer/télécharger/payer, coût soutenable des niveaux. G2 p. 2/7 ; G3 p. 2/6. |
| Décisions provisoires | SWITCHWORKS à tester en premier ; trois districts ; identité G3 chaude/céramique ; monétisations proposées historiquement ou nouvellement étudiées. Aucune préférence artistique nouvelle n'est déjà approuvée. |
| Validations manquantes | Joueurs indépendants qualifiés, comparaison à un autre concept, différenciation mémorisée, retour au jeu, acquisition, conversion/prix, économie, appareils physiques, iOS, droits du nom et conformité du produit final. |

G2 p. 8 mentionne qu'un « premier testeur » a résolu les six niveaux G1. Sa qualité de participant indépendant, son recrutement et ses données ne sont pas fournis. Ce retour ponctuel ne doit pas devenir une étude utilisateur réalisée, et ne contredit pas automatiquement les compteurs datés de recherche du 12 novembre.

## Benchmark : ce que les nombres permettent de conclure

Les poids sont 25/25/20/10/10/10 pour demande, différenciation, faisabilité, accroche vidéo, monétisation et profondeur de rétention. Le recalcul des cinq lignes du CSV est conforme ; il ne réévalue pas les appréciations de départ.

| Concept | Score expert /100 | Décision historique | Interprétation correcte |
|---|---:|---|---|
| SWITCHWORKS | 81 | TEST | Priorité documentaire, pas probabilité de réussite |
| ARROW CASCADE | 78,5 | KILL en l'état | Un risque éliminatoire de similarité prime sur le score |
| BLOCK GARDEN | 77,5 | KILL en l'état | Même logique ; une forte demande de catégorie ne suffit pas |
| FOLDSPACE | 70 | TEST | Second concept comparateur ; nom à contrôler |
| WORD MOSAIC | 67 | HOLD | Éléments insuffisants pour engager la suite |

Références : benchmark p. 11–13/20 ; CSV, colonnes de score/statut/niveau de preuve ; JSON `weights`, `concepts`, `research`. Les chiffres externes de marché/CPI/rétention décrivent des panels et méthodes différents. Ils ne sont pas utilisés comme prévisions du studio. Les populations/coûts/marges/LTV devront être harmonisés avant toute simulation économique. La [préqualification actualisée](market-research/SWITCHWORKS_PREQUALIFICATION_2026-11-14.md) identifie les sources primaires relues et les informations restant à rafraîchir.

## Mécanique de référence pour les nouvelles propositions

Le socle retenu pour l'étude visuelle est celui de G1 p. 2, G2 p. 3 et G3 p. 2 : **6×6 ; rails droits/coudés à deux connexions, rotation de 90° ; sources/destinations fixes ; départ volontaire et résolution déterministe ; un flux, puis deux A/B**. Le district 03 ajoute un croisement fixe et un délai de départ de 0 à 4 temps. Pas de compte à rebours imposé.

Les étoiles/rotations/essais/indices et l'annulation sont documentés, mais certains détails exacts de compteurs et de sauvegarde nécessitent les sources ou un nouveau contrat explicite. Les interfaces natives devront garder les lettres et formes en plus des couleurs, le focus, l'erreur réparable et les commandes bas d'écran. Une nouvelle carte d'étude est explicitement distincte des niveaux historiques : [EXEMPLE_PLATEAU_6X6.json](art/switchworks/EXEMPLE_PLATEAU_6X6.json).

## Écarts et arbitrages avec le travail actuel

| Écart | Analyse / traitement |
|---|---|
| Monorepo actuel vs dépôts séparables historiques | Programme p. 6/9 proposait plusieurs dépôts selon les cycles d'accès. La décision explicite récente impose le monorepo ; aucune séparation automatique. |
| Plateforme Symfony/PostgreSQL/Redis et SDK envisagés vs bootstrap | Programme p. 1/3/8 décrit une cible future, non une installation prouvée. Elle reste différée ; le socle validé n'est pas toute la phase plateforme/dashboard. |
| G2/G3 suspendaient le natif avant terrain | G2 p. 9/G3 p. 6 visent l'industrialisation du jeu. Le propriétaire a ensuite autorisé le bootstrap natif et l'étude actuelle. Cela ne constitue pas un GO commercial ; la tranche future reste bornée et soumise au choix de direction/périmètre. |
| Préqualification « Jeu 001 » | PHASE SHIFT n'est pas SWITCHWORKS. Le nom de fichier ne change pas le sujet de la fiche. |
| Codes G0/G1/G2/G3 variables | Versions de prototypes et gates de validation ne désignent pas la même chose ; chaque code historique reste cité avec son document. Les repères S0–S6 de la nouvelle note sont une proposition locale, pas une réécriture des archives. |
| Premières images de cette mission | Produites avant l'arrivée des archives : trois destinations et raccords Y/T. Conservées comme V1, **écartées pour le gameplay de référence**. Les révisions corrigeront la grille et les deux flux sans en faire des captures moteur. |
| Première piste bois/émail/laiton | La revue concurrentielle a relevé une proximité avec Parcel Flow ; cette combinaison est écartée au profit d'une proposition A contemporaine gris/cobalt/aluminium. Voir [références](art/switchworks/REFERENCES_ET_CONVENTIONS.md). |
| Trois styles vs deux concepts | A/B/C comparent des directions artistiques de SWITCHWORKS. Ils ne remplacent pas le protocole SWITCHWORKS/FOLDSPACE. |
| 3 s de lecture vs protocole historique | Une lecture experte à 3 s est un test d'accroche proposé ; elle ne remplace pas l'exposition 5–8 s ni les échantillons du protocole historique. |
| Bibliothèque tiers verrouillée par empreintes | Programme p. 3 demande aussi un suivi de révision. Les 80 empreintes sont conformes ; aucun commit amont historique n'est reconstitué artificiellement. |

## Décisions de travail et preuves suivantes

1. Conserver le code, les tests, prototypes et archives ; ne pas convertir les PDF en validations nouvelles.
2. Comparer trois directions sur les mêmes règles. Les PNG restent du concept art ; le [dossier artistique](art/switchworks/DIRECTIONS_ARTISTIQUES.md) définit palette, matière, HUD, motion et faisabilité.
3. Préserver le terrain historique : 12–20 entretiens, 8–12 tests de compréhension, comparaison A/B de concepts 30–50 personnes proposée dans le benchmark ; ce sont des plans, pas des effectifs réalisés. Voir le [registre de tests](market-research/SWITCHWORKS_HYPOTHESES_ET_TESTS_2026-11-14.md) pour les seuils, dénominateurs et limites.
4. Avant le portage du gameplay, retrouver si possible les sources HTML/JS/levels/tests et les exports volontaires. Sinon, écrire et faire approuver un contrat natif qui distingue restauration et nouvelles décisions.
5. Après sélection, suivre le [brief de tranche native](art/switchworks/BRIEF_TRANCHE_VERTICALE.md) : modèle déterministe, assets séparés, HUD natif, échec/réussite/reprise et captures authentiques. Aucun backend, achat, publicité ou jeu complet maintenant.

La décision recommandée est **poursuivre TEST et préparation**, avec **HOLD commercial**. La qualité des images, un score documentaire de 81/100 ou un build qui démarre ne démontrent pas que des joueurs veulent acheter SWITCHWORKS.
