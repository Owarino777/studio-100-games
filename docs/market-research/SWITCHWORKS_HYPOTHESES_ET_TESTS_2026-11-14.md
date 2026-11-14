# SWITCHWORKS — Registre d'hypothèses et protocole de validation

- Date : 14 novembre 2026.
- Statut : **protocole préparé, aucun participant testé**.
- Sources de cadrage : [préqualification et concurrence](SWITCHWORKS_PREQUALIFICATION_2026-11-14.md), [fondation technique](../RECETTE_BOOTSTRAP_2026-11-14.md).
- Les seuils ci-dessous sont des règles de décision internes, pas des normes du marché ni des résultats observés. Les valeurs historiques sont conservées séparément des compléments proposés pour les trois directions artistiques. Toute modification doit être approuvée et consignée **avant** de voir les résultats concernés.

## Protocole historique retrouvé : référence avant adaptation

Le [benchmark, p. 13](../historique-projet/02-marche/Benchmark_5_Concepts_Jeux_Mobiles_2026.pdf) proposait : 12–20 entretiens exploratoires, 8–12 personnes par concept pour la compréhension après 5–8 secondes d'exposition, puis 30–50 personnes distinctes si disponibles pour une préférence à l'aveugle. Les seuils internes proposés étaient **≥80 % de compréhension sans aide**, **≥65 % de première résolution après une courte démonstration** et **≥60 % déclarant vouloir essayer une autre manche**. Ce sont des critères historiques à tester/recalibrer, pas des résultats acquis ni des benchmarks universels.

Le [protocole G1, p. 1–4](../historique-projet/02-marche/Protocole_Validation_Terrain_G1.pdf) compare **deux concepts, SWITCHWORKS et FOLDSPACE**, avec trois mini-scènes de 6–10 secondes chacun et ordres AB/BA. Il envisage 8–12 personnes par itération tactile et laisse la cohorte J1/J7 à définir. Les deux documents sont compatibles en intention mais portent sur des phases/expositions différentes ; ne pas fusionner leurs dénominateurs ou convertir une préférence en rétention.

La mission actuelle prépare trois directions **du même SWITCHWORKS**. Leur comparaison graphique ne remplace pas le test historique SWITCHWORKS/FOLDSPACE, ni une mesure commerciale. Le choix technique actuel de traiter SWITCHWORKS comme jeu 001 ne transforme pas le statut historique TEST en validation marché. Les [réponses historiques](../historique-projet/02-marche/Grille_collecte_G1_vierge.csv) sont toujours vierges et le [JSON](../historique-projet/02-marche/Protocoles_choix_et_mesure.json) indique zéro entretien/campagne.

Le premier brouillon de cette préparation proposait 6/8 sur la compréhension, soit 75 %. Après lecture des archives, ce seuil est retiré pour H01/H03 au profit de **7/8** sur une vague de huit, afin de ne pas abaisser silencieusement le plancher historique de 80 %. Les autres comptages ci-dessous servent à des tâches/choix distincts ; ils ne sont pas présentés comme équivalents aux critères historiques.

## Boucle documentée commune aux trois directions

Lire la mission → reconnaître les sources et quais A/B → tourner de 90° les rails droits/coudés → examiner la continuité des connexions → expédier volontairement → comprendre la réussite ou la rupture → corriger par annulation/remise à zéro puis réessayer.

La [spécification G1 p. 2](../historique-projet/03-prototypes/Specifications_SWITCHWORKS_G1.pdf) et le [dossier G3 p. 2](../historique-projet/03-prototypes/Conception_Recette_SWITCHWORKS_G3.pdf) décrivent une grille **6 × 6**, des pièces **à deux ports**, des sources/destinations fixes et un départ volontaire. Le [dossier G2 p. 3](../historique-projet/03-prototypes/Conception_Recette_SWITCHWORKS_G2.pdf) distingue un flux au district 01, deux flux A/B au district 02, puis un croisement fixe et un délai de départ 0–4 au district 03. Ces règles documentées ne sont pas implémentées dans la mire du bootstrap ; les dossiers historiques concernent des prototypes HTML. Les concepts graphiques ne prouvent pas le portage natif.

| À conserver dans la comparaison actuelle | À traiter seulement comme nouvelle hypothèse |
|---|---|
| Droite/coude à deux ports, rotation par quart de tour ; source/quai fixes. | Jonction Y/T, bascule d'une branche, dessin ou pose libre de voie. |
| Un ou deux flux selon le district ; écran de double flux limité à A/B. | Troisième flux/colis autonome ou nouvelle règle de tri. |
| Préparer les orientations puis lancer la simulation déterministe. | Prévision temporelle au pas, curseur, pause/édition pendant le trajet. |
| Synchronisation du district 03 : croisement fixe et délai de départ 0–4. | Nouveau type de collision ou réglage temporel montré dès le district 01/02. |

Le terme « aiguillage » des études commerciales est un raccourci ; il ne remplace pas ces contraintes plus précises. La clarté des rails rotatifs est l'hypothèse à mesurer en premier.

## Registre des risques

| ID | Hypothèse non démontrée | Preuve à produire | Critère proposé avant collecte | Si le critère échoue |
|---|---|---|---|---|
| H01 — compréhension | Le premier écran permet d'identifier l'objectif et les objets importants. | Exposition de 5–8 s selon le benchmark historique, puis reformulation libre sans jargon fourni par le modérateur. | Au moins **7 personnes sur 8** citent une destination correcte et l'action de routage, sans inventer une fonction principale différente ; test graphique exploratoire, pas résultat G1 complet. | Corriger hiérarchie, signes et formulation, puis refaire une vague ; ne pas sélectionner sur beauté seule. |
| H02 — commande | Les rails rotatifs et commandes centrales sont manipulables sans précision excessive. | Test natif sur téléphone, gestes enregistrés avec consentement. | Au moins 6/8 accomplissent chaque tâche critique sans aide ; aucun blocage tactile répété n'est accepté. | Agrandir/réorganiser les cibles et donner un retour immédiat ; ne pas réduire la difficulté des puzzles pour masquer un défaut de commande. |
| H03 — causalité | Le joueur peut prévoir la continuité du trajet et comprendre pourquoi sa tentative échoue. | Prédiction avant lancement et récit de la connexion incorrecte après lancement. | Au moins **7/8** expliquent correctement un trajet et un échec sans intervention ; ce critère complémentaire n'est pas une première résolution après démonstration. | Montrer les deux ports et l'orientation, puis la connexion rompue ; ne pas ajouter une nouvelle fonction de prévision au pas pour masquer un défaut de lisibilité. |
| H04 — différenciation | Le souvenir porte sur une expérience propre, pas seulement « un autre jeu de trains ». | Question libre après une distraction, puis comparaison honnête avec un jeu connu du participant. | Au moins 5/8 rappellent une particularité de décision ou de feedback ; les mots dictés par l'enquêteur ne comptent pas. | Revoir la promesse et la combinaison des règles. Aucune communication « innovante » ne passe sur le seul habillage. |
| H05 — désir de continuer | Le puzzle donne envie de lancer un autre niveau hors obligation de test. | Après les tâches obligatoires, proposer la fin de séance ou un niveau supplémentaire ; observer le choix. | Au moins 5/8 choisissent de continuer et peuvent dire ce qu'ils veulent essayer. | Diagnostiquer difficulté, répétition et intérêt ; ne pas confondre courtoisie et engagement. |
| H06 — retour réel | Le plaisir persiste après la découverte. | Test fermé volontaire d'un build, retour sans relance individuelle, sur une période fixée à l'avance. | Mesurer d'abord une référence sur un petit groupe ; décider du seuil d'investissement après estimation de l'économie et avant la vague suivante. Aucun chiffre de rétention concurrent n'est inventé. | Revoir les règles/contenus avant d'ajouter une méta-progression ou des récompenses artificielles. |
| H07 — paiement | Un modèle de vente est acceptable pour la valeur réellement offerte. | Entretiens neutres puis, ultérieurement, comportement de paiement réellement proposé et autorisé. | Pas de GO commercial sur intention déclarée seule. Fixer valeur offerte, pays, prix et dénominateur avant le test économique. | Modifier valeur, offre ou segment ; ne pas extrapoler la rentabilité d'un achat fictif. |
| H08 — acquisition | Des joueurs pertinents peuvent être atteints à un coût soutenable. | Créatifs issus du vrai prototype, dépenses séparément autorisées et mesure des conversions jusqu'à l'usage. | Un budget et une limite de perte doivent être approuvés avant campagne ; CAC maximal dépend de la marge et de la rétention mesurées. | Suspendre la campagne, revoir créatif/cible/offre ; ne pas poursuivre au nom du programme « 100 ». |
| H09 — production | Le studio peut créer des niveaux de qualité avec un effort soutenable. | Journal d'effort pour plusieurs niveaux, solutions vérifiées et tests indépendants. | Décider d'une capacité après une première série mesurée, pas d'après le nombre de dossiers ou de skills. | Réduire le périmètre ou changer les outils ; conserver le prototype comme preuve d'apprentissage. |

## Étape A — Sélection artistique et compréhension

Prévoir une première vague exploratoire de **8 personnes**, réparties entre personnes jouant régulièrement à des puzzles mobiles et personnes plus occasionnelles. C'est une proposition de recrutement, pas un effectif déjà obtenu. Ne pas assimiler des proches du studio à un échantillon du marché ; signaler les liens éventuels.

Présenter les trois directions dans un ordre contrebalancé : ABC, BCA, CAB, ACB, CBA, BAC puis deux ordres tirés et consignés avant séance. Utiliser la même composition de niveau, mêmes objectifs, textes, colis, états et échelle d'affichage. Montrer chaque écran seul sur téléphone, sans logo de concurrent, avant la planche comparée. Ne pas mettre une direction animée face à deux images fixes.

Séquence :

1. Exposition de **3 secondes**, écran masqué ensuite : « Que cherchez-vous à faire ? Quels éléments semblent pouvoir changer ? » Aucun nom de mécanique n'est soufflé. Ce relevé d'accroche est un complément de première impression, sans verdict du test historique de compréhension.
2. Exposition séparée de **5–8 secondes**, puis reformulation libre, afin de garder le repère historique H01. Observer ensuite sans limite stricte et faire désigner colis, quai correspondant, deux ports d'un rail rotatif et commande d'envoi. Relever ambiguïtés et erreurs, sans transformer une image en test de fonctionnement. Les mini-scènes de 6–10 secondes du G1 devront faire l'objet d'une séance distincte lorsqu'elles existeront.
3. Questions sur les gestes attendus : toucher, glisser, lancer, annuler. Une réponse plausible sur concept reste une hypothèse tant qu'un prototype natif ne l'a pas confirmée.
4. Montrer les trois directions ensemble : demander choix et raisons, puis demander laquelle semble la plus claire pour jouer longtemps. Séparer attrait, compréhension, confiance et fatigue.
5. Après une courte distraction, demander ce qui a été retenu du jeu ; noter les mots exacts sans reformulation favorable.

**Sortie de l'étape :** comptages bruts, verbatim anonymisés, erreurs par objet, préférences et raisons, limites de l'échantillon. Une préférence 5 contre 3 ne devient ni une différence statistiquement prouvée ni une prédiction de ventes. La décision artistique reste provisoire si la lisibilité ou la compréhension échoue. Les huit personnes servent à une première exploration graphique ; elles ne sont pas substituées aux phases historiques de 12–20 entretiens et de 30–50 préférences A/B.

**Budget de préparation :** aucune dépense engagée ou autorisée automatiquement. Proposition de capacité pour cette seule vague : huit séances de 20–25 minutes, une préparation et une synthèse à planifier avec le propriétaire ; ce sont des estimations d'effort, pas un calendrier promis ni une rémunération décidée. Sans participants externes disponibles, conserver le statut HOLD terrain au lieu de fabriquer des réponses.

## Étape B — Cinq tâches sans aide sur la future tranche native

Exécuter une fois la direction retenue réalisée dans Godot, sur appareils ciblés disponibles. Le modérateur lit seulement le but ; il n'explique pas les contrôles. Une aide donnée est horodatée et compte comme aide, même si la tâche finit ensuite.

| Tâche | Consigne centrée sur l'intention | Observation attendue |
|---|---|---|
| T1 — première livraison | « Faites arriver ce colis au quai qui lui correspond. » | Le joueur identifie le quai, tourne un rail droit/coudé et lance ; aucune action suggérée par le modérateur. |
| T2 — anticipation double flux | « Avant d'envoyer A et B, dites où chacun va passer et à quel quai il arrivera. » | Continuité des deux trajets et absence de confusion des destinations ; pas de troisième colis ni de fonction temporelle ajoutée. |
| T3 — réparation | « Cette tentative n'aboutit pas. Corrigez-la en conservant ce qui vous paraît utile. » | Cause comprise, annulation/reprise trouvée, absence de perte d'état incompréhensible. |
| T4 — signes et confort | « Reprenez le même objectif avec le son coupé et la présentation des couleurs réduite. » | Couleur non indispensable, symboles suffisants, feedback non sonore disponible ; test natif requis. |
| T5 — pause et retour | « Interrompez le jeu, revenez, puis continuez votre essai. » | État explicite et contrôle conservé, aucun blocage de navigation ; ne pas confondre ce test avec une sauvegarde durable non implémentée. |

Consigner par tâche : succès sans aide, aide, erreur de manipulation, erreur de raisonnement, abandon, durée, explication libre et appareil. Ne pas résumer un échec de toucher à un « mauvais joueur ». Les critères H01–H05 ne remplacent pas une analyse de chaque blocage critique.

## Niveaux de la tranche à préparer après choix artistique

Quatre expériences minimales candidates pour la future tranche : un trajet dont une droite/courbe doit être tournée ; un détour avec des cases leurres ; deux flux A/B vers deux quais fixes ; une correction par annulation d'une rotation. Le choix des niveaux doit être rapproché des solutions historiques avant implémentation. La synchronisation par croisement fixe et délai 0–4 appartient au district 03 et n'est pas ajoutée au niveau de double flux de référence. Le benchmark p. 17 envisageait **20–30 niveaux tests** pour un prototype approfondi ; les dossiers G2/G3 documentent ensuite **18 niveaux HTML**. Ces quatre expériences ne sont ni un portage de ces niveaux déjà réalisé, ni un remplacement silencieux du périmètre historique.

Ces expériences peuvent être regroupées dans les trois micro-niveaux du [brief natif proposé](../art/switchworks/BRIEF_TRANCHE_VERTICALE.md), qui ajoute une proposition explicite de démonstration du signal du district 03 ; le nombre et le périmètre restent à arrêter avant codage. Le modèle de puzzle devra être une donnée séparée de la vue, avec simulation déterministe, annulation du même état et solutions vérifiées. Le solveur et les vérifications de niveaux exécutables viendront avec la tranche jouable. La [planche illustrative](../art/switchworks/EXEMPLE_PLATEAU_6X6.json) possède un témoin de connexion vérifié sur ses données (7/7), sans constituer un niveau historique retrouvé ou un gameplay natif implémenté. Ces règles viennent de la discipline `puzzle`, tandis que `level-design` guide l'ordre d'apprentissage.

## Étape C — Vérification commerciale ultérieure

Après une tranche native compréhensible : ouvrir un test fermé volontaire, fixer avant collecte les cohortes, fenêtres de retour, définition de session et raisons d'abandon. Ne pas sélectionner seulement les joueurs qui ont fini les niveaux. Séparer les mesures Android/iOS et les groupes de recrutement.

Comparer ensuite les modèles plausibles pour le produit réellement offert : les **indices vidéo volontaires et cosmétiques historiquement envisagés** (benchmark p. 6), ainsi que l'achat initial ou l'essai puis déblocage complet observés dans la revue actuelle. Aucun de ces modèles n'est approuvé ou prouvé pour SWITCHWORKS. Ne pas intégrer publicité, monnaies ou boutique avant de démontrer leur utilité. Aucun prix optimal, taux de conversion, CPI ou LTV du studio n'est avancé à ce stade.

Les définitions économiques devront être figées avant tout calcul : l'étude stratégique p. 7 et le benchmark p. 15 présentent la LTV et les coûts déduits avec des formulations différentes. Ne pas soustraire deux fois les mêmes coûts variables lorsqu'on rapproche ces documents. Les valeurs sectorielles et cohortes des p. 7–8 de l'étude/p. 4 et 15 du benchmark ne sont pas nos dépenses, nos cohortes ou nos revenus.

Toute campagne, indemnisation, achat ou mise en vente demande l'autorisation du propriétaire. Cette mission n'a engagé **aucune dépense** et n'a envoyé aucun message de recrutement.

## GO, PIVOT, HOLD, KILL

- **GO vers la tranche limitée** : objectif compris, commandes et signes jugés exploitables, une direction choisie pour des raisons consignées et scope limité accepté. Cela ne vaut pas validation G1 commerciale historique ; toute dérogation à l'ordre des preuves doit être explicitée, et non déduite du seul fait d'avoir produit une planche artistique.
- **PIVOT** : les critères de compréhension/commande échouent mais une cause corrigeable est identifiée ; modifier une hypothèse à la fois et refaire une vague.
- **HOLD** : sources, participants, budget ou preuves manquent ; l'absence de données n'est ni un succès ni une raison de produire davantage d'assets.
- **KILL/archivage de l'hypothèse** : deux vagues successives après correction n'améliorent pas le même blocage central, ou le coût mesuré dépasse la capacité acceptée sans valeur démontrée. C'est un seuil interne proposé à confirmer avant test, pas une suppression automatique de fichiers.

Le statut **actuel** est HOLD commercial : aucun des tests A, B ou C n'a été réalisé. La recherche de marché et les concepts peuvent préparer une décision, sans remplacer ces preuves.

## Fiche de collecte à copier pour chaque séance

`ID pseudonyme / date / groupe de recrutement / appareil / version ou hash / direction et ordre / tâche / succès sans aide / aide fournie / erreurs / durée / citation volontaire / observation du modérateur / décision / anomalie liée`.

Demander le consentement avant enregistrement ; ne collecter ni identifiants de compte ni données sans rapport. Le responsable du test doit fixer accès, durée de conservation et suppression des enregistrements avant le recrutement. Aucun fichier de participant n'est créé ici.
