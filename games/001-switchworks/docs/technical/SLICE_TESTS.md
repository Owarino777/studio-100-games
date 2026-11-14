# Tests de la tranche Archipel Postal

Le runner `tests/slice_gameplay_runner.gd` vérifie le contrat du modèle natif de la tranche. Il est distinct de `tests/test_runner.gd`, conservé pour les 36 contrôles du bootstrap.

Périmètre : **un niveau représentatif du district 02**, selon la demande actuelle. Le croisement fixe, le délai et les autres niveaux du brief préparatoire ne sont pas ajoutés implicitement.

Contrôles exécutés : entrée JSON stricte, niveau initial non résolu et solution témoin, évaluation pure/déterministe, compte d'expéditions, refus d'indices/stations/cases vides, copies profondes, restauration atomique, annulation/indice/remise à zéro, sorties hors plateau, connexion manquante, mauvaise destination, autre source et boucle. Les erreurs utilisent de petites données de test structurellement valides, sans modifier les champs internes d'un jeu en cours.

Deux propriétés sont vérifiées : 1 000 couples rotation/annulation avec graine fixe et identité après quatre rotations sur chaque rail éditable. Ces tests ne prouvent ni l'optimalité de la solution, ni la difficulté ressentie, ni la qualité commerciale.

Une option `-- --force-failure` provoque un échec volontaire et doit retourner le code 1. Les erreurs runtime d'un sous-test sont aussi comptées si celui-ci ne termine pas. Un code 0 sans inspection des logs Godot ne suffit pas à certifier une exécution propre.

## Résultats du modèle, 14 novembre 2026

Godot réellement exécuté : `4.7.2.stable.official.ed1daf0bf`, Standard. Import du projet : code 0. Runner normal : **137 contrôles réussis, 0 échec**, avec **1 000 essais rotation/annulation**, code 0 et aucun `ERROR:` ou `SCRIPT ERROR`. Contrôle négatif : **137 réussites, 1 échec volontaire**, code **1** attendu. Les deux derniers contrôles couvrent aussi la sérialisation JSON des snapshots, car ses nombres et tableaux n'ont pas exactement les mêmes types que les valeurs natives GDScript.

Les logs sont dans `artifacts/slice-tests/gameplay.log`, `gameplay-negative-control.log` et `domain-final.log` (artefacts de travail ignorés par Git). L'erreur explicitement présente dans le log négatif est intentionnelle ; elle ne décrit pas une anomalie du jeu.

Commandes sous-jacentes, après import et avec le binaire local sélectionné :

```powershell
& $godotBin --headless --path games/001-switchworks --import
& $godotBin --headless --path games/001-switchworks --script res://tests/slice_gameplay_runner.gd
& $godotBin --headless --path games/001-switchworks --script res://tests/slice_gameplay_runner.gd -- --force-failure
```

Les processus de test redirigent uniquement leur `APPDATA` vers `tools/.local/godot/4.7.2/editor_data/runtime-user`. L'accès au magasin de certificats Windows a nécessité l'accès de processus adapté dans le sandbox ; aucune vérification TLS n'a été neutralisée et aucune configuration globale modifiée.

Contrat testé des compteurs : une rotation/indice est annulable ; une expédition reste comptée après annulation d'une modification ; la remise à zéro commence une nouvelle session du niveau et remet tous les compteurs à zéro. Les snapshots ne fabriquent pas d'historique d'annulation et une restauration invalide est refusée sans état partiel.

## Intégration de scène et proportions

Runner séparé : `tests/slice_ui_runner.gd`. Résultat normal : **476 contrôles réussis, 0 échec**, code 0. Contrôle négatif : **476 réussites, 1 échec volontaire**, code 1 attendu. Les logs `artifacts/slice-tests/ui.log` et `ui-negative-control.log` séparent ces deux passages.

Les cinq tailles de `SubViewport` réellement instanciées sont **360×640**, **390×844**, **412×915**, **768×1024** et **844×390**. Le test vérifie l'existence, les dimensions et les bornes des contrôles visibles, le focus initial, la planification, l'échec initial, les expéditions non dupliquées pendant la résolution, la correction, l'annulation, l'indice et la réussite de deux livraisons.

Les commandes Recommencer et Réduire le mouvement sont vérifiées dans le menu pause où elles sont accessibles, et ne sont pas exigées à tort visibles dès la planification. Le test de pause commence sur un plateau réellement modifié pour détecter une remise à zéro accidentelle ; il vérifie aussi le retour du focus et le bouton Recommencer du menu.

La sélection d'une case passe par la projection caméra et le pipeline GUI du viewport. Le test injecte une paire tactile/événement souris principal émulé, car `Viewport.push_input` ne réalise pas lui-même l'émulation du système. Une interaction ne doit provoquer qu'un quart de tour ; une station fixe reste inchangée. Ce contrôle synthétique ne remplace pas un tap ADB ni une observation physique sur Android.

```powershell
& $godotBin --headless --path games/001-switchworks --script res://tests/slice_ui_runner.gd
& $godotBin --headless --path games/001-switchworks --script res://tests/slice_ui_runner.gd -- --force-failure
```

Les logs d'instrumentation de la fenêtre headless peuvent indiquer 64×64 : il s'agit de la fenêtre système factice, pas de la taille des cinq `SubViewport` contrôlés. Les tests de bornes utilisent les dimensions explicites ci-dessus. Ils ne rendent aucune image GPU et ne mesurent pas le contraste des matériaux, les FPS Android, les safe areas physiques ou le confort réel du toucher.

Les captures exécutées, le toucher Android et les performances GPU sont consignés dans la recette globale de la tranche. Aucun test auprès de joueurs indépendants ou sur un appareil physique n'est inventé par ce document.

## Recette Android réelle

Le [script stdlib dédié](../../tools/verify_android_slice.py) a été exécuté sur **Studio_API_36**, Android 16/API 36, `emulator-5580`, serveur ADB 5041. Il vérifie l'identité de l'AVD et le package de l'APK avant installation. Il n'utilise ni `pm clear`, ni désinstallation, ni commande destinée à un autre paquet.

Passage final : **67 vérifications réussies sur 67**, dans `artifacts/slice-android/final-20261114T034540868917Z/receipt.json`. APK testé : package `org.studio100games.switchworks.archipel.slice`, **61 432 091 octets**, SHA256 `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1`, inchangé entre début et fin de recette.

Les contrôles lisent les snapshots réellement sauvegardés par l'application et les événements de son processus :

- Un vrai tap ADB sur la case 8 provoque exactement une rotation ; Annuler restaure le plateau ; une source fixe ne tourne pas ; Indice n'oriente pas automatiquement un rail.
- Le plateau initial produit l'échec attendu et compte un essai ; les six commandes du témoin préparent les ports exacts de la solution ; l'expédition aboutit à deux livraisons, six rotations et deux essais.
- Home puis retour conserve le même PID et l'état, avec pause et reprise observées. Android a rapporté **`LaunchState: UNKNOWN (0)`**, malgré `Status: ok` et le retour de la tâche existante : aucun libellé HOT n'est inventé.
- Home pendant l'animation produit une pause de la phase `running` ; la reprise termine la même tentative, sans seconde expédition.
- Après force-stop puis nouveau processus, la préparation et ses compteurs sont restaurés. Le test active ensuite Mouvement réduit/Sons discrets, tourne et annule une voie, puis vérifie l'état et l'absence d'erreur Godot. L'écoute audio n'a pas été effectuée.
- Le passage se termine sur la préparation initiale, préférences mouvement réduit/son désactivées, sans effacer les données de l'application. L'AVD est laissé actif pour la revue visuelle du responsable de recette.

Onze PNG authentiques et une vidéo Android **720×1600, huit secondes demandées**, de **3 428 103 octets**, ont été enregistrés. Le fichier MP4 et son format de piste ont été vérifiés ; aucun audio n'est enregistré. Les logs restent filtrés par PID de l'application. Un premier reçu d'échec est conservé séparément : son assertion imposait à tort le mot HOT ; après vérification du PID, de la capture et des événements, seule cette hypothèse du script a été corrigée, sans changer l'APK.

Mesure finale après une observation idle de onze secondes : 540 échantillons d'intervalles muraux après échauffement, p50 **16,686 ms**, p95 **18,118 ms**, compteur moteur **60 FPS**, **23 draw calls**, mémoire statique **55 563 880 octets**, PSS de l'application **201 777 KiB**. Un relevé pendant animation et enregistrement donnait **55 FPS / 460 draw calls** ; sa fenêtre roulante mélange plusieurs états. Ces résultats d'émulateur ne garantissent pas 60 FPS sur matériel physique et ne constituent pas une mesure du temps GPU pur ou de batterie.

Le renderer observé est OpenGL ES 3.1 via le traducteur Android Emulator/NVIDIA RTX 4060 Laptop. Aucun `ERROR:` Godot, `SCRIPT ERROR` ou `FATAL EXCEPTION` dans les deux processus du passage final. Les diagnostics natifs `ashmem` déprécié et l'avertissement Godot de cache shader recompilé sont conservés dans le reçu ; aucun « zéro avertissement » n'est revendiqué.
