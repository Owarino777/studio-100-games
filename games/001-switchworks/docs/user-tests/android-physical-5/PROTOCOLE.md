# SWITCHWORKS — cinq essais non guidés sur Android physique

**Préparation du 14 novembre 2026. Aucun essai humain exécuté ou réussi par ce document.** Décision explicite du propriétaire : GO pour les tests sur Android physique, HOLD pour l'acceptation artistique finale et commerciale.

La [revue externe finale](../../polish/REVUE_EXTERNE_FINALE_2026-11-14.md) a été **lue intégralement** après sa mise à disposition. Son GO porte sur une campagne physique ; son HOLD couvre l'acceptation artistique finale, l'extension du contenu et la commercialisation. Elle juge les médias et la recette fournis, sans installation directe de l'APK, manipulation tactile, inspection Git ou contrôle indépendant des suites. Ce protocole reprend ses points de surveillance : rôles, rotations au doigt, contraste, réception, pause/Home et second format. Le précédent prompt de correction n'est pas réexécuté.

## Référence figée et question étudiée

- Branche conservée : `fix/archipel-postal-finition-p1-p2`.
- Commit de référence : `108e2b04a3109f8f67d00a65caf0d60d7f1c979e`.
- APK existant : `switchworks-archipel-polish-debug.apk`, code 6, `0.1.1-polish.4`.
- SHA256 : `6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965`.
- Niveau unique existant « Les deux tournées ». Aucun contenu, paramètre logique ou asset nouveau n'est requis.

Question : **une personne découvrant ce build comprend-elle le trajet, agit-elle avec précision sur le téléphone et reconnaît-elle la réception, tout en percevant une finition visuelle cohérente ?** Il ne s'agit pas de mesurer la demande commerciale, la rétention ou une conformité d'accessibilité complète.

## Participants et conditions

Prévoir **P01 à P05**, cinq personnes indépendantes des auteurs et modérateurs, n'ayant vu ni la solution, ni les concepts, ni les vidéos ou audits du projet. Noter une éventuelle exposition antérieure et ne pas mélanger ce cas avec une première découverte. Varier raisonnablement l'habitude des puzzles mobiles ; ne collecter ni nom, coordonnées, âge précis ou donnée de santé.

Prévoir idéalement deux téléphones Android ARM64 physiques : un format standard D01 et un compact D02. Définir avant collecte l'attribution des cinq premières expositions, par exemple trois personnes sur D01 et deux sur D02, sans inscrire cette proposition comme une mesure déjà réalisée. **Une personne ne produit qu'une première découverte** : un second appareil essayé ensuite est une observation complémentaire après apprentissage, pas un sixième participant ou une seconde réussite indépendante. Analyser les cinq cas aussi par appareil, sans comparaison statistique entre les deux petits groupes.

Si un seul téléphone est disponible, les cinq sessions restent possibles sur celui-ci, mais le contrôle du second format reste CN. Consigner modèle, version Android, dimensions, navigation gestuelle/boutons, luminosité et échelle de texte ; aucun numéro de série dans les fiches. La première phase utilise si possible une luminosité moyenne consignée ; ne pas inventer de nits ou une équivalence de 50 % entre modèles. L'installation et le lancement techniques ne comptent pas comme un test joueur.

Faire cinq sessions séparées d'environ 15–20 minutes. Aucun observateur ne doit donner de signe d'approbation, expliquer un rôle, montrer un geste ou corriger un trajet pendant la phase autonome. Même modérateur et mêmes formulations si possible. Ne pas remplacer une personne parce qu'elle échoue ; une session interrompue ou techniquement invalide reste inscrite avec son motif.

## Avant chaque session, hors de la vue du joueur

1. Vérifier la référence APK, le véritable appareil et le démarrage. Lire la procédure d'installation du dossier. Aucun émulateur ne peut remplir les résultats physiques.
2. Utiliser les contrôles existants Pause → Recommencer pour retrouver le plateau initial, sans commande de suppression de données. Vérifier zéro rotation/essai, deux colis aux départs et aucune solution déjà préparée.
3. Conditions de départ identiques : portrait, sons désactivés, mouvement réduit désactivé, sauf besoin exprimé par la personne. Respecter ce besoin et consigner le mode réellement utilisé ; ne pas présenter ces sessions comme strictement identiques ensuite. Ne pas modifier silencieusement les réglages système du propriétaire.
4. Garder les rapports, la solution et les concepts hors du champ de vision. Demander l'accord avant toute capture, voix ou vidéo ; leur refus n'exclut pas du test. Préparer un chronomètre et une fiche vierge.
5. La personne propriétaire peut choisir de masquer les notifications. Ne pas enregistrer ses notifications, comptes ou autres applications. Aucune télémétrie/analytics n'est ajoutée au jeu.

Introduction neutre : « Nous évaluons l'application, pas vos capacités. Vous pouvez vous arrêter à tout moment. Jouez à votre façon et dites ce que vous cherchez à faire. Je garderai les explications pour la fin. » Ne pas annoncer la mécanique, les destinations ou les matières attendues.

## Phase A — découverte autonome

Une demande d'aide est notée. Réponse neutre unique possible : « Faites ce qui vous semble le plus naturel. » Elle ne doit désigner ni bouton ni solution. Toute explication de mécanique ou indication de cible met fin à l'autonomie pour la tâche concernée : marquer **A — assistée**, même si elle aboutit ensuite.

| Tâche | Consigne et ordre de passation | Mesures, sans aide |
|---|---|---|
| **T01 — première lecture** | Montrer l'écran initial trois secondes, puis le masquer avec une carte neutre. Demander « Que pensez-vous devoir faire ? Que feriez-vous d'abord ? ». Transcrire avant toute reformulation. Réafficher ensuite et demander « D'où les objets partent-ils et où pensez-vous qu'ils vont ? » ; faire désigner les éléments avant toute action. | Compréhension spontanée du but après 3 s ; réponse verbatim. Puis départs corrects sur 2, destinations correctes sur 2, associations A/B correctes sur 2 et temps de pointage. **Ne pas appeler le pointage réaffiché un score de mémoire après 3 s.** Arrêter le pointage à 30 s sans expliquer la réponse. |
| **T02 — rotations et précision** | « Commencez à jouer comme vous le souhaitez. » Observer jusqu'à 60 s : première action, premier quart de tour voulu et demande d'aide. Ensuite, pendant 60–90 s : « Dites quel élément vous voulez modifier avant de le toucher ; essayez aussi de retrouver l'état précédant une modification. » Ne nommer ni le geste ni le bouton. | Temps de première rotation intentionnelle, découverte sans aide, intentions/rotations réellement obtenues, précision des touches et méthode de retour utilisée. Cette seconde période de verbalisation est distincte du premier geste libre ; elle n'est pas un benchmark de vitesse naturelle. Ne pas imposer dix touches ou une solution pour gonfler le dénominateur. |
| **T03 — tentative et réparation** | « Poursuivez jusqu'à obtenir le résultat que vous souhaitez. Si quelque chose ne fonctionne pas, faites ce qui vous semble utile. » Laisser jusqu'à quatre minutes, sans demander de lancer une erreur ni corriger un rail. | Expéditions, erreurs logiques rencontrées, compréhension du message et du repère, corrections, temps, abandon ou aide. Une erreur de raccord n'est pas une erreur tactile. Noter une éventuelle réussite autonome ; ne pas l'exiger pour conserver la session. |
| **T04 — réception** | Au premier succès, immédiatement demander « Que vient-il de se passer ? Qu'est-ce qui vous le fait dire ? ». Laisser la première réponse complète avant toute relance. Puis demander de désigner où chaque objet a été reçu. Si aucun succès n'a été obtenu, utiliser la phase B ci-dessous et la signaler. | Évocation spontanée de l'entrée/disparition du colis, du clapet ou de la coche locale ; localisation A et B sur 2 ; source de confirmation citée : locale, compteur, bilan, mixte, aucune ou indéterminée. **Ne pas dire “regardez les boîtes”, ne pas masquer le compteur ni modifier le build.** Mentionner seulement « 2/2 » ou le bilan n'est pas une reconnaissance spontanée du feedback local. |
| **T05 — appréciation visuelle** | Avant de montrer le concept : « Comment décririez-vous l'apparence de ce jeu ? Qu'est-ce qui paraît terminé ou inachevé ? Quels matériaux reconnaissez-vous, s'il y en a ? ». Recueillir ensuite les trois notes ancrées ci-dessous et un motif. | Description et matières librement nommées ; attrait 1–5, lisibilité 1–5, finition perçue 1–5 ; défaut cité et envie de poursuivre formulée librement. Ne pas suggérer porcelaine/papier/kraft avant la réponse. Une préférence esthétique n'est pas un achat ni une rétention mesurés. |

Si T03 réussit avant la fin, recueillir T04 à ce moment ; ne pas attendre artificiellement la limite. Ne pas relancer la réception pour prétendre qu'une réponse déjà informée est spontanée. Aucun concept, vidéo ou ancienne note d'audit avant T05. Une comparaison au concept après les mesures peut être proposée séparément, sans remplacer ces notes.

## Phase B — exposition à la réception si la personne est bloquée

Après la limite autonome ou l'abandon, dire explicitement : « La partie autonome s'arrête ici. Je vais préparer les voies pour que nous puissions observer la fin du trajet. Cette préparation ne sera pas comptée comme votre résolution. » Masquer l'écran pendant la préparation, puis rendre le téléphone au joueur ; ne pas lui décrire les signes locaux de réception.

Le modérateur utilise uniquement Recommencer et les rotations existantes du niveau. Aucun fichier n'est modifié. La réussite de puzzle reste A/E/AB selon les faits ; le mode d'exposition à la réception est **ASSISTEE**. La compréhension de la réception peut alors être observée, mais doit être rapportée séparément des réceptions atteintes de façon autonome. Si le modérateur doit également désigner l'action de lancement, noter cette aide supplémentaire.

**Repère réservé au modérateur — ne pas montrer avant les tâches :** depuis le plateau initial, un quart de tour horaire sur les cases `(rangée, colonne)` **(2,3), (3,5), (4,2), (4,4), (5,2), (5,4)**, comptées depuis le coin haut gauche en base 1, constitue le témoin existant. Ce sont les indices source 8, 16, 19, 21, 25 et 27 en base 0. Six rotations sont un témoin connu, **pas un optimum démontré**. Cette information sert seulement à une exposition assistée déclarée, jamais à préparer secrètement le plateau puis compter un succès autonome.

## Codage des gestes et calculs

Consigner les événements dans `evenements_tactiles.csv`, avec la cible voulue annoncée avant le geste si possible, la zone réellement touchée observée et le résultat. Une intention reconstituée après coup doit être qualifiée PROBABLE ou INDETERMINEE ; elle n'entre pas comme erreur tactile confirmée.

| Code | Définition opérationnelle | Compte comme erreur tactile confirmée ? |
|---|---|---|
| OK | Cible voulue atteinte et effet attendu obtenu | Non |
| VISEE | Une cible voisine/non voulue est activée, intention préalable et observation concordantes | Oui, si CONFIRMEE |
| MANQUE | Toucher dirigé vers la voie/action voulue, sans effet alors que cette action est disponible ; preuve suffisante | Oui, si CONFIRMEE ; noter l'état et les éventuels gestes rapides |
| DOUBLE | Un seul geste intentionnel observé provoque plusieurs actions non voulues | Oui, si CONFIRMEE ; possible anomalie applicative, pas faute attribuée au joueur |
| LOGIQUE | La pièce voulue tourne, mais le trajet choisi échoue | Non ; erreur de raisonnement à analyser séparément |
| ROLE | La personne pense pouvoir modifier un quai fixe ou une commande verrouillée | Non ; compréhension/affordance à analyser séparément |
| INDETERMINE | Intention, point de contact ou effet insuffisamment observable | Non ; compter l'incertitude séparément |

- **Taux de rotation voulue obtenue** = rotations voulues obtenues / intentions de rotation classifiables sur des voies éditables en préparation, même phase et même mode. Une rotation doit viser la pièce voulue et produire le quart de tour attendu. ROLE, actions verrouillées et intention indéterminée sont consignés séparément. Garder les deux nombres avec le taux.
- **Taux d'erreurs tactiles confirmées** = gestes classifiables VISEE/MANQUE/DOUBLE confirmés / gestes tactiles classifiables visant une action disponible pendant T02–T03. Les gestes de boutons peuvent être inclus ; les distinguer dans le journal. INDETERMINE et ROLE sont exclus du dénominateur et décomptés à part. Un geste rapide refusé pendant une animation est noté comme friction/refus temporel, ou indéterminé si l'état est incertain : ne pas l'effacer de l'analyse, ni l'attribuer automatiquement à une mauvaise visée.
- **Compréhension des rôles** : nombre de sessions valides ayant identifié 2/2 départs, 2/2 destinations et 2/2 associations sans aide / nombre de sessions valides effectivement observées.
- **Réception locale spontanée** : sessions mentionnant spontanément un signe local de réception / sessions ayant effectivement vu une réception. Présenter les nombres séparés par exposition AUTONOME ou ASSISTEE ; ne pas mélanger les deux pour annoncer un succès autonome.
- Dénominateur nul, tâche non vue ou preuve insuffisante : **NE/CN**, jamais 0 % ou 100 %. Avant collecte, toutes les cellules de mesure restent vides. Ne pas supposer zéro erreur en l'absence d'enregistrement ou de note.

Les temps au chronomètre sont arrondis à la seconde et leur méthode est notée ; ne pas en déduire une latence tactile en millisecondes. Les taux sur quelques gestes sont descriptifs. Présenter les cinq cas et leurs hésitations plutôt qu'une moyenne seule.

## Phase C — interruptions et conditions physiques, après T05

Cette phase vient **après** les mesures de découverte, réception et appréciation spontanée. Les reprises, l'autre tenue et les autres conditions ne sont pas de nouvelles premières expositions. Utiliser toujours le même niveau et les contrôles existants ; aucun mode spécial n'est développé.

| Contrôle complémentaire | Demande portant sur un objectif, sans procédure enseignée | Observation à noter |
|---|---|---|
| **C01 — pause / reprise** | « Recommencez une préparation, puis interrompez-la en gardant ce que vous avez fait. Reprenez quand vous le souhaitez. » Ne pas montrer le bouton ni son emplacement. La préparation doit comporter au moins une modification voulue pour rendre la conservation vérifiable. | S/A/E/AB/CN, temps, demande d'aide, état avant/après, éléments que la personne pense conservés et action qu'elle comprend devoir faire. Demander après coup « Qu'est-ce qui a été conservé ? » sans fournir la réponse. |
| **C02 — Home / retour** | « Quittez momentanément l'application pour retrouver l'accueil du téléphone, puis retrouvez votre partie. » Ne pas enseigner un raccourci ou geste système. | Même relevé, plus éventuelle difficulté de navigation système. Masquer l'enregistrement pendant l'accueil et les autres applications ; ne conserver que les preuves du jeu autorisées. Le retour Home en mémoire ne prouve pas une restauration après destruction du processus. Ne pas forcer l'arrêt de l'application pour ce contrôle. |
| **C03 — tenue à une main** | Si la personne est d'accord : « Essayez maintenant de modifier les voies en tenant le téléphone d'une seule main. » Aucun objectif de vitesse. | Main et tenue, portée des cibles, gestes classifiables/erreurs confirmées, hésitations, confort décrit. Si la tenue n'est pas possible/souhaitée, CN avec motif non médical, sans la forcer ni noter un échec de compréhension. Ne pas agréger ces gestes avec les taux de la phase A. |
| **C04 — lumière** | Observer la lisibilité à luminosité moyenne, puis en lumière extérieure si possible, sur le même écran. Demander « Que pouvez-vous lire ou distinguer ici ? ». Aucun élément à nommer d'avance. | Conditions réelles, réglage manuel/auto, texte/compteurs/indices distingués, note de lisibilité ancrée et zone difficile. Le propriétaire du téléphone décide des réglages ; aucune modification silencieuse. Si l'extérieur n'est pas disponible, CN. Les observations après apprentissage sont séparées de la compréhension initiale. |

La fiche permet aussi un commentaire facultatif d'écoute en conditions calmes, si les sons existants sont volontairement activés après les tâches. Ne pas présumer un retour haptique, ne pas noter l'audio si personne ne l'a écouté et ne pas déduire l'impact sensoriel d'une vidéo muette. Ne pas changer ces préférences pendant la phase A sans le consigner.

## Notes ancrées et calcul des synthèses

Les notes 2 et 4 sont intermédiaires entre les ancrages ci-dessous. Elles sont recueillies après le récit libre, avec un motif réel. Une absence d'observation reste NE/CN, jamais une note moyenne par défaut.

| Échelle 1–5 | 1 | 3 | 5 |
|---|---|---|---|
| Facilité des rotations | Geste très difficile ou non obtenu sans aide | Geste obtenu, avec hésitations ou reprises gênantes | Geste facile et précis, sans aide ni hésitation notable |
| Attrait visuel | Apparence pas du tout attirante pour cette personne | Apparence acceptable, avis partagé | Apparence très attirante pour cette personne |
| Lisibilité | Éléments essentiels difficiles ou impossibles à lire/distinguer | Éléments compris avec effort ou hésitation | Éléments essentiels immédiatement clairs dans cette condition |
| Finition perçue | Aspect très provisoire, défauts visuels fortement gênants | Ensemble cohérent mais plusieurs détails visiblement inachevés | Ensemble perçu comme très abouti dans la condition observée |

La lisibilité en extérieur utilise les mêmes ancrages mais reste une colonne distincte. Une appréciation « très aboutie » est la perception de cette personne, pas une certification artistique ou commerciale.

## Règles de décision proposées, à confirmer avant collecte

Ce sont des seuils de travail pour cette première série, pas des normes industrielles ou une validation commerciale. Le propriétaire doit les confirmer avant de voir des résultats ; ne pas les ajuster après coup pour rendre le build favorable. Le seuil 4/5 est celui proposé par la revue pour le triage précoce, pas une preuve statistique.

1. Conditions remplies : cinq personnes indépendantes, référence APK identique, téléphone physique validé, tâches réellement observées ; sinon HOLD pour les mesures manquantes.
2. Aucun blocage reproductible empêchant une tâche essentielle. Une session concernée reste visible, même si les quatre autres aboutissent.
3. Au moins 4/5 décrivent le but après l'exposition courte et identifient ensuite les quatre rôles/adresses au pointage pré-action sans aide. Rapporter ces deux observations séparément.
4. Au moins 4/5 découvrent une rotation intentionnelle sans aide en 60 s ; difficulté et erreurs tactiles analysées avec les nombres de gestes. Une même erreur tactile confirmée chez au moins deux personnes impose une investigation, sans l'effacer dans un taux global. Le seuil de taux proposé est ≤ 10 % seulement si au moins 30 gestes classifiables sont naturellement observés au total ; sinon ce critère reste CN, sans imposer des gestes artificiels pour le franchir.
5. Au moins 4 des 5 personnes exposées à la réception localisent les deux arrivées et citent un feedback local sans relance orientée. Indiquer combien ont eu une préparation assistée ; aucune de ces sessions ne devient une résolution autonome.
6. Lisibilité et finition perçue : médiane proposée ≥ 4/5 sur les notes ancrées, sans défaut majeur récurrent masqué. L'attrait est publié séparément, sans moyenne qui mélange usage et préférence.
7. Pause/Home : aucune perte ou impasse reproductible ; succès, aide et compréhension du guidage rapportés séparément. Les conditions à une main, extérieures et sur un second format restent CN si non exécutées. Elles ne sont pas converties en résultats favorables.

Un résultat favorable constitue une **recommandation à examiner par le propriétaire**, pas une autorisation automatique de contenu. Une confusion récurrente, un geste difficile ou une consigne ambiguë conduit à proposer un REWORK ciblé du même niveau ; une absence d'exécution physique ou indépendante maintient HOLD pour ces mesures. **HOLD artistique et commercial reste applicable tant que les décisions correspondantes ne sont pas documentées.** Cinq participants qualitatifs ne prouvent ni marché, ni rétention, ni rentabilité. Pas de nouveau niveau, refonte ou diffusion automatique après la collecte.

## Conservation et résultat à rendre

Dupliquer les gabarits dans `games/001-switchworks/artifacts/user-tests/` pour la collecte réelle ; ce dossier est ignoré par Git. Garder les gabarits de ce dossier vierges. N'ajouter aux sources qu'une synthèse anonymisée explicitement revue ; aucune vidéo/voix/fiche personnelle n'est envoyée ou publiée par ce protocole.

Le consentement à participer et celui à enregistrer sont distincts. Consigner oui/non sans signature nominative dans les résultats techniques. Définir avant collecte qui accède aux médias, leur durée de conservation et leur suppression ; proposition de travail : supprimer les médias bruts après la synthèse et au plus tard sous trente jours, sauf accord spécifique différent. Ne pas affirmer une conformité juridique sur cette seule fiche.

Rendre : cinq fiches avec statuts réels, journal des gestes, numérateurs/dénominateurs, temps et verbatim anonymes, incidents techniques et aides, observations de réception autonome/assistée séparées, puis décision humaine motivée. Une installation réussie, un script de contrôle ou une grille préremplie ne peut être compté comme un test humain réussi.
