# Cinq sessions non guidées sur Safari iPhone

**Statut : protocole préparé, résultats non exécutés.** Base de conception : commit `108e2b04` et revue externe finale fournie par le propri?taire (`docs/polish/REVUE_EXTERNE_FINALE_2026-11-14.md`, document local ant?rieur conserv? hors de ce commit Web). Le passage Web est une adaptation technique du même niveau Archipel Postal. Aucun niveau, identité ou mécanisme nouveau n'est requis.

## Question et portée

Vérifier si l'iPhone permet de charger le vrai export, comprendre les départs/destinations, tourner les voies précisément, reconnaître la réception et retrouver une préparation. L'appréciation du rendu est recueillie avant de montrer un concept ou une vidéo. La campagne ne mesure ni demande commerciale, ni rétention, ni performance Android native.

Godot Web demande WebAssembly/WebGL 2.0 ; le mode single-thread améliore la compatibilité iOS sans garantir ce projet. Le stockage `user://` s'appuie sur la persistance du navigateur ; navigation privée et données effacées peuvent l'empêcher. L'arrière-plan peut suspendre le traitement. Ces limites documentées motivent les contrôles ci-dessous, pas des échecs ou réussites déjà constatés. [Source Godot 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_web.html).

## 1. Référence de session et préparation technique

Avant l'arrivée du joueur, consigner dans `controle_technique.csv` :

- Code du build Web, SHA256 du manifeste/artéfact et commit réellement servis ; conserver la base `108e2b04` sans assimiler un autre export à cet identifiant.
- iPhone physique, modèle et version iOS ; version Safari si disponible, sinon `NE`. Une taille simulée de viewport n'est pas un modèle d'iPhone. Relever orientation, taille CSS/DPR si le build les expose, zoom/échelle et visibilité des barres Safari ; sinon laisser `NE`.
- Origine HTTPS stable codée O01/O02, page ouverte directement dans Safari ou raccourci d'accueil, mode normal/privé, réseau Wi-Fi/cellulaire et cache déclaré initial/chaud/inconnu. Ne pas stocker les liens secrets ou identifiants.
- Vérifier le vrai chargement, absence d'écran vide, objectif et plateau ; un démarrage technique n'est pas une réussite de joueur. Si TLS/WebGL/mémoire bloque, marquer la condition `CN` et documenter le blocage avant recrutement.
- Préparation initiale obtenue par les contrôles existants Pause → Recommencer : zéro rotation/essai, deux colis aux sources. Ne pas vider les données du navigateur pour remettre un joueur à zéro.
- Sons initialement coupés et mouvement réduit initialement désactivé, sauf besoin exprimé ; respecter ce besoin et noter le mode. Aucun audio/haptique n'est présumé depuis une vidéo muette.

Le premier chargement et le chargement chaud doivent être distingués. Mesurer le premier à partir de l'ouverture réelle de l'URL après les éventuelles étapes d'accès, jusqu'au plateau utilisable ; relever séparément attente réseau, erreur et durée approximative si observables. Pour le chaud, recharger la même origine. **Ne pas appeler chaque joueur un nouveau chargement à froid** sur le même téléphone. N'effacer aucun cache ni historique personnel à l'insu du propriétaire pour fabriquer ce cas ; si le cache initial est incertain, le noter.

## 2. Participants, indépendance et consentement

Prévoir cinq personnes SW01–SW05 indépendantes des auteurs, qui n'ont vu ni la solution, ni les vidéos/concepts du jeu. Ne pas remplacer un échec par un joueur plus favorable. Une session interrompue reste inscrite avec son motif. Durée indicative : 15–20 minutes, sans objectif de vitesse.

Un seul iPhone peut servir aux cinq sessions. Chaque personne ne fournit qu'une première découverte. Si ces mêmes personnes essaient Android plus tard, noter un essai **apparié après apprentissage**, sans le compter comme cinq nouvelles découvertes indépendantes. Pour une comparaison de première compréhension, prévoir une nouvelle cohorte Android ou un ordre Web/Android contrebalancé décidé avant collecte ; avec cinq personnes, rester qualitatif et ne pas annoncer d'effet statistique de plateforme.

Disponibilité déclarée par le propriétaire : D01 peut désigner l'iPhone 15 Pro et D02 l'iPhone 15 Pro Max, tous deux annoncés sous iOS 27.2, sur le même Wi-Fi que le PC. Vérifier les caractéristiques effectivement utilisées avant de les reporter comme observées. Répartition proposée avant collecte : SW01–SW03 sur D01, SW04–SW05 sur D02 ; la modifier avant les sessions si nécessaire, puis conserver le plan. Le même joueur sur les deux appareils ne crée pas un participant supplémentaire. Ne pas comparer ces groupes de trois et deux comme une étude statistique de taille d'écran.

Accord à participer et accord à enregistrer sont distincts ; refuser la vidéo n'exclut pas la personne. Utiliser uniquement les identifiants anonymes, pas de nom, compte, contact ou donnée de santé. Masquer l'enregistrement lors de Home et des autres applications. Le propriétaire peut choisir de masquer ses notifications. Aucune télémétrie n'est ajoutée.

Introduction : « Nous évaluons le jeu, pas vos capacités. Vous pouvez arrêter à tout moment. Jouez à votre façon et dites ce que vous cherchez à faire ; je garderai les explications pour la fin. » Ne montrer ni contrôle, ni flèche, ni boîte. Une explication de mécanisme ou une cible donnée fait passer la tâche en `A — assistée`.

## 3. Cinq tâches de découverte

Le temps de première exposition commence quand le **jeu**, et non son écran de chargement, est visible. Le chargement reste une mesure séparée.

| Tâche | Consigne non guidée | Mesure réelle |
|---|---|---|
| W01 — première lecture | Montrer le plateau initial 3 s, masquer, demander « Que pensez-vous devoir faire ? Que feriez-vous d'abord ? ». Transcrire, puis réafficher et demander d'indiquer d'où les objets partent et où ils vont, avant toute action. | But spontané après 3 s ; verbatim ; départs sur 2, destinations sur 2, associations A/B sur 2 au pointage réaffiché, temps indicatif ≤ 30 s. Le pointage réaffiché n'est pas un score de mémoire. |
| W02 — geste et précision | « Commencez à jouer comme vous le souhaitez. » Observer le premier geste pendant 60 s. Ensuite « Dites quel élément vous voulez modifier avant de le toucher ; essayez aussi de retrouver l'état avant une modification. » Ne nommer ni geste ni bouton. | Temps de première rotation voulue, découverte sans aide, intentions classifiables sur voies éditables, effets obtenus, erreurs de visée/manqués/doubles confirmés, hésitations et annulation. Distinguer gestes libres et période verbalisée. |
| W03 — tournée et réparation | « Poursuivez jusqu'à obtenir le résultat que vous souhaitez ; si quelque chose ne fonctionne pas, faites ce qui vous semble utile. » Laisser au plus quatre minutes. | Expéditions, erreurs logiques rencontrées, interprétation du message et du cadre, correction, aide, temps et abandon. Ne pas forcer un échec ou imposer un nombre de touches. |
| W04 — réception | Au premier succès : « Que vient-il de se passer ? Qu'est-ce qui vous le fait dire ? ». Laisser finir la réponse avant de demander où chaque objet est reçu. | Signe local spontanément cité, localisation A/B sur 2, preuve invoquée : local/compteur/bilan/mixte/aucune/indéterminée. Ne pas dire de regarder la boîte ou masquer le compteur. |
| W05 — visuel | Avant concept ou vidéo : « Comment décririez-vous l'apparence ? Qu'est-ce qui semble terminé ou inachevé ? Quels matériaux reconnaissez-vous, s'il y en a ? ». | Description et matières spontanées ; notes ancrées d'attrait, lisibilité et finition ; défaut avec zone précise ; envie de poursuivre librement formulée. Aucun nom de matériau suggéré avant réponse. |

En cas de blocage avant réception, terminer explicitement la phase autonome, puis préparer le témoin **hors de sa vue**, avec Recommencer et les rotations du jeu. Dire que cette préparation n'est pas sa résolution. Le modérateur peut utiliser le repère conservé dans le [protocole Android](../android-physical-5/PROTOCOLE.md), sans l'afficher avant les tâches. Marquer l'exposition à la réception `ASSISTEE`, et l'éventuelle aide au lancement séparément. Ne pas transformer ensuite ce succès visuel en puzzle résolu sans aide.

## 4. Après les réponses spontanées : interruptions et stockage

Ces contrôles viennent après W05. Ils n'ont pas valeur de nouvelle première exposition. Partir d'une préparation réellement modifiée et noter son état avant chaque interruption. Ne modifier ni le code ni le niveau pour la rendre observable.

| Contrôle | Procédure à objectif, puis observation | Attendu à vérifier, sans succès précoché |
|---|---|---|
| S01 — pause du jeu | Demander d'interrompre puis reprendre sans perdre ce qui a été préparé, sans montrer le bouton. | Commande trouvée, état conservé, consigne de reprise comprise ; temps et aides. |
| S02 — Home / Safari | Demander de retrouver l'accueil du téléphone puis le jeu. Ne filmer que le jeu autorisé. | Retour dans le même onglet, pause/consigne, surface WebGL, préparation et compteurs ; noter si Safari recharge. Le retour en mémoire ne prouve pas une restauration depuis stockage. |
| S03 — rechargement même origine | Avec l'accord du propriétaire, recharger ce seul onglet du test. Noter avant : ports/rotations/essais/préférences observables. | Préparation réellement retrouvée ou avertissement d'indisponibilité. La reprise en planification après nouveau processus est le contrat ; absence de victoire/animation/historique d'annulation restaurés n'est pas automatiquement une perte logique. |
| S04 — fermeture / réouverture du test | Après accord, fermer uniquement l'onglet dédié puis rouvrir la même origine HTTPS. Ne fermer aucune autre page. | Même comparaison et délai approximatif. Une nouvelle origine, un chemin de stockage différent ou un mode privé ne permettent pas de conclure que le même stockage a été relu. |
| S05 — mouvement réduit / son | Faire découvrir l'option existante après les tâches puis comparer une réception. Audio seulement si activé volontairement et réellement écouté. | Mode, différence observée et compréhension. Ne pas noter le son depuis un enregistrement muet ; ne pas inventer d'haptique. |
| S06 — conditions physiques | Après accord : une main ; luminosité moyenne puis extérieure si possible ; orientation et barres Safari visibles/masquées si pertinent. | Portée des touches, erreurs, lisibilité, encoche/Home indicator, défilement/zoom involontaire. `CN` si condition impossible ; ne pas mélanger ces gestes aux taux initiaux. |

Ne pas forcer de fermeture de Safari, de pression mémoire, d'effacement des données ou de changement de confiance TLS pendant les sessions. Une éviction/recharge spontanée est un incident à décrire, pas un diagnostic automatique de bug Godot. Un mode privé ou un refus de stockage volontaire peut être un cas technique séparé, jamais la preuve que le mode normal conserve les données. Une URL de test changée entre deux visites impose de noter l'origine et de requalifier la comparaison.

## 5. Codage et calcul

`S` = tâche sans aide ; `A` = assistée ; `E` = échec ; `AB` = abandon ; `NE` = non évaluée ; `CN` = conditions non réunies ; `NA` = non applicable avec motif. Pas de note favorable par défaut.

- Rotation obtenue : pièce voulue et quart de tour attendu sur une voie éditable disponible. Garder numérateur/dénominateur ; ROLE, gestes verrouillés et intention indéterminée à part.
- Erreur tactile confirmée : intention annoncée/observable et mauvais appui, manque ou double action étayé. L'erreur de raccord (`LOGIQUE`) et la confusion de rôle (`ROLE`) sont des catégories séparées. Un geste refusé pendant une animation est une friction temporelle à conserver, pas forcément une mauvaise visée. Sans preuve suffisante : `INDETERMINE`.
- Taux tactile : erreurs confirmées / gestes visant une action disponible et classifiables de la même période ; consigner les exclus et leurs motifs. Zéro dénominateur : `NE`, pas 0 %.
- Réception : présenter séparément exposition AUTONOME/ASSISTEE ; citation locale spontanée et deux arrivées localisées. Compteur/bilan seuls n'établissent pas une reconnaissance du feedback local.
- Temps : chronomètre ou vidéo selon accord, arrondi à la seconde. Aucun temps observateur ne devient une latence tactile ou GPU en millisecondes. Les barres Safari/encoche et les marges réellement visibles sont des observations physiques, pas celles d'un viewport simulé.

Notes 1–5 après récit libre, avec motif : facilité 1 très difficile / 3 obtenue avec gêne / 5 facile et précise ; attrait 1 pas attirant / 3 avis partagé / 5 très attirant ; lisibilité 1 éléments essentiels difficiles / 3 effort / 5 immédiatement clairs ; finition 1 très provisoire / 3 cohérente mais inachevée / 5 très aboutie selon cette personne. 2 et 4 sont intermédiaires. Ne pas moyenner usage, préférence et technique.

## 6. Décision proposée avant collecte

Confirmer les seuils avant de voir les résultats. Pour cette série qualitative : cinq vraies sessions sur Safari iPhone, aucun blocage reproductible essentiel ; au moins 4/5 comprennent le but et les rôles sans aide, découvrent une rotation intentionnelle et reconnaissent les deux réceptions avec un signe local. Déclarer les réceptions assistées. Une même difficulté majeure de toucher/reprise ou de lecture observée chez deux personnes impose une investigation, même avec une bonne moyenne. Une impossibilité d'obtenir HTTPS, WebGL ou persistance attendue maintient `HOLD` pour le contrôle concerné.

Un bilan favorable n'autorise que l'examen d'une suite par le propriétaire. Pas de contenu, refonte, Android natif, iOS natif, publication ou commercialisation automatiquement validés. La campagne Android reste préparée pour un appareil futur ; les fiches Safari ne la remplacent pas.

## Sources et limites documentées

- [Godot 4.7 — export Web](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_web.html) : prérequis, single-thread, stockage, arrière-plan et audio.
- [Protocole Android conservé](../android-physical-5/PROTOCOLE.md) : définitions de première découverte et d'assistance.
- [Synthèse à remplir](SYNTHESE.md), sans résultat humain prérempli.

Le présent document ne prouve ni export réussi, ni accessibilité HTTPS, ni essai Safari réel : ces résultats doivent venir des reçus et des observations effectives du build courant.
