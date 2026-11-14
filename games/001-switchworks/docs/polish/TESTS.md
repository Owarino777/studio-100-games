# Tests de la passe de finition ciblée

14 novembre 2026. Ces contrôles vérifient les contrats fonctionnels de la présentation. Ils ne donnent aucune note de beauté, de confort tactile humain ou de qualité commerciale.

## Suites conservées et ajouts

Les fichiers `tests/test_runner.gd`, `tests/slice_gameplay_runner.gd` et `tests/slice_ui_runner.gd` sont conservés sans retrait d'assertion. Le passage de référence avant corrections donnait 36/0, 137/0 et 476/0. Les niveaux, règles et ports restent ceux du modèle initial.

Le nouveau `tests/polish_state_runner.gd` instancie la vraie scène dans cinq `SubViewport` : 360×640, 390×844, 412×915, 768×1024 et 844×390. Il contrôle :

- L'objectif explicite A → A / B → B et la consigne initiale distincte d'une reprise.
- Les instructions de préparation restaurée prête ou non, trajet, échec, pause et victoire ; aucune invite à tourner pendant un état verrouillé ; absence d'une seconde consigne contradictoire dans le pied de page.
- Le refus atomique d'une préparation invalide : le modèle et le message visible restent ensemble dans leur état précédent.
- La restauration testée à travers `restore_preparation`, méthode de présentation utilisée par le vrai chargement, sans écrire la sauvegarde `user://` ni modifier son schéma. La restauration de fichier lors d'un nouveau processus reste une vérification Android séparée.
- Le chargement pendant le véritable `_ready`, via une sous-classe de test dont `_load_local_state` fournit un snapshot avant le montage. Trois cas — préparation non raccordée, prête et invalide — sont exécutés sur chacun des cinq formats. Les bornes sont vérifiées dès le premier layout, après trois frames, puis après remise à zéro, trajet et échec : deux lignes au maximum, minimum de fonte contenu dans la boîte, hauteur bornée à 54 unités, écart de quatre unités avec les statistiques et le plateau en portrait, distance suffisante des actions.
- Le singulier « 1 essai » et le pluriel « 2 essais », produits après des expéditions réellement lancées par le contrôleur ; aucun texte « essai(s) ».
- Les commandes nominales de 48 unités, leur maintien dans les cinq cadres et une marge inférieure de 16 unités. Ce n'est pas une mesure en dp physiques ou un test d'encoche.
- La visibilité des trois actions de préparation : présentes pendant préparation, trajet et échec, masquées à la victoire pour éviter des fragments de boutons autour du bilan sur tablette, puis de nouveau présentes après Rejouer. Le verrouillage des actions à la victoire reste contrôlé en plus de leur masquage.
- La réception A et B en mouvement normal puis réduit : sceaux visibles, colis entrés/masqués, couvercles revenus à leur pose fermée et échelles à l'unité ; aucune modification logique due au feedback.
- Rejouer pendant la fin du feedback, puis passer au mouvement réduit pendant une réception mise en pause : pas de sceau résiduel, de colis caché à tort ou de dérive d'échelle.

La solution témoin est préparée par les six rotations légales existantes. Le scénario pluriel débute par un véritable échec, puis corrige ces voies ; il n'invente pas de compteurs internes.

Le runner géométrique `assets/archipel/qa/check_art_family.gd` conserve les contrôles de famille existants et ajoute les rôles, la présence exclusive d'une toiture de départ ou d'un corps de boîte réceptrice, leurs proportions différentes, ainsi que les pivots et sceaux de réception. Les masques, hauteurs des ports, deux meshes par rail, codes cercle/triangle, bornes et normales finies restent contrôlés.

## Commandes

Depuis la racine du studio, après import et avec `$godotBin` sélectionnant le binaire Godot 4.7.2 Standard déjà installé :

```powershell
& $godotBin --headless --path games/001-switchworks --script res://tests/test_runner.gd
& $godotBin --headless --path games/001-switchworks --script res://tests/slice_gameplay_runner.gd
& $godotBin --headless --path games/001-switchworks --script res://tests/slice_ui_runner.gd
& $godotBin --headless --path games/001-switchworks --script res://tests/polish_state_runner.gd
& $godotBin --headless --path games/001-switchworks --script res://tests/polish_state_runner.gd -- --force-failure
& $godotBin --headless --path games/001-switchworks --script res://assets/archipel/qa/check_art_family.gd
```

Le contrôle négatif doit retourner 1 ; les passages positifs doivent retourner 0 et ne contenir aucun `SCRIPT ERROR` ou `ERROR:`. Les résultats de sous-tests interrompus sont comptés comme échecs. Les logs de travail nouveaux restent sous `artifacts/polish/`, sans écraser les preuves précédentes.

## Résultats réellement exécutés

Godot utilisé : **4.7.2.stable.official.ed1daf0bf**, Standard, après lecture des contrats et sans réinstallation. Le premier ensemble du nouveau runner passait 823/0 ; la régression de chargement précoce et les écarts de layout ont ensuite été ajoutés sans retirer ces contrôles. Les seuls `ERROR:` d'un contrôle négatif doivent correspondre à son injection explicite. Les nombres comprennent les répétitions de contrat et de layout dans cinq cadres ; ils ne représentent pas autant de scénarios indépendants ou de participants.

Le passage après la réserve de 44 unités en portrait, avant le dernier masquage des actions à la victoire, donne **1 698 assertions réussies, 0 échec**, code **0**. Son contrôle négatif donne **1 698 réussites, 1 échec volontaire**, code **1** attendu. Les quinze hooks de chargement ont des largeurs déjà définies (328, 358, 380, 736 et 442 selon le format), après le placement initial corrigé. Logs de ce passage : `polish-state-1698-final.log` et `polish-state-1698-negative.log` ; aucun `SCRIPT ERROR` ou `ERROR:` dans le passage positif.

La QA Android tablette a ensuite relevé des fragments des boutons de préparation de part et d'autre du bilan de victoire. Après leur masquage limité à cette phase, **le dernier passage donne 1 758 réussites / 0 échec, code 0**, et le contrôle négatif **1 758 réussites / 1 échec volontaire, code 1**. Les 75 contrôles explicites de visibilité ajoutés couvrent cinq états sur cinq formats ; les quinze itérations automatiques de bounds des boutons désormais invisibles à la victoire ne s'exécutent plus. Aucune assertion antérieure n'est retirée. Logs finaux : `polish-state-visibility-final.log` et `polish-state-visibility-negative.log`, passage positif sans erreur de script ou `ERROR:`.

Les suites conservées passent : **36/0** bootstrap, **137/0** modèle et **471/0** UI. Le passage UI antérieur comptait 476 : ses cinq itérations ne trouvent plus de pied de page visible à vérifier, puisque cette consigne redondante est maintenant masquée. Le fichier du runner UI et ses assertions sont inchangés ; le nouveau runner vérifie explicitement le pied vide et masqué dans les différents états. La comparaison Git avec `d36af097` ne relève aucun changement des trois anciens runners, des scripts du modèle ou des données de niveau.

Famille géométrique au dernier passage : **467 assertions réussies, 0 échec**, 111 instances de meshes et 12 051 triangles custom inspectés dans l'échantillon. La tuile de référence possède un capot d'émail séparé dont le sommet reste à Y=0,12, à l'intérieur du rebord, sans changer le dégagement des rails. Des révisions candidates antérieures passaient 452/0 puis 460/0 ; ces passages restent distincts. Ce sont des nombres de la planche de contrôle, pas le coût du plateau complet ni une note de finition.

Une première exécution du nouveau contrôle de bounds à la victoire a détecté un panneau de 560 unités de haut, dû au minimum d'autowrap d'un label encore caché. Le contrôleur a été corrigé : son bilan possède déjà deux lignes bornées et n'utilise plus cet autowrap. Le passage final **vérifie de nouveau les bornes immédiatement après l'entrée en victoire, sans attente ajoutée pour masquer un dépassement**. Les premiers logs d'échec sont conservés pour traçabilité ; ils ne décrivent pas l'état corrigé final.

Logs : `polish-state-tests-final.log`, `polish-state-tests-negative.log`, `reference-suites-final.log`, `art-family-tests.log`. Les journaux `polish-state-tests-first.log` et `polish-state-tests-diagnostic.log` conservent le défaut de bounds trouvé ; le journal intermédiaire `polish-state-tests-layout-settled.log` ne constitue pas la preuve finale du correctif immédiat.

Un défaut différent a ensuite été trouvé dans l'APK Android : le label de reprise était rempli avant sa première largeur de layout, ce qui gonflait son minimum d'autowrap et déportait ses caractères vers le bas. Les premiers tests restauraient après montage et ne couvraient pas ce chemin ; la sous-classe de chargement précoce ci-dessus ferme cette lacune. Le premier essai de cette nouvelle régression a commencé après l'arrivée du correctif source : il ne prouve donc pas un échec headless avant correction. Son ancien contrat de hauteur 38 a été remplacé par le contrat final de fonte (44 réservées en portrait, minimum réel de deux lignes 43 ; maximum 54). Le log `early-restore-obsolete-height-contract.log` décrit ce contrat de test périmé, pas le défaut Android initial. La preuve de ce dernier reste la capture native du paquet a17bed conservée par la recette globale.

## Limites

Un `SubViewport` headless ne produit aucun rendu GPU et ne mesure pas les matériaux, ombres, silhouettes perçues, FPS Android ou sensations de réception. Les noms et proportions des meshes démontrent une différence structurelle ; ils ne prouvent pas que quatre personnes sur cinq identifient le rôle d'une station. Les états observables d'une animation ne remplacent ni sa vidéo Android native ni une manipulation humaine.

Les comparaisons visuelles, le toucher Android, la reprise de processus et les mesures de performance sont à lire dans le rapport global de cette passe. Aucun test sur iOS ou téléphone physique, aucun test auprès de joueurs et aucune validation commerciale ne sont déduits de ces suites.
