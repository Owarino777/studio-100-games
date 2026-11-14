# SWITCHWORKS — Recette de la tranche Archipel Postal

> Rapport initial conservé. Le jalon ultérieur de [stabilisation et revue indépendante](../stabilization/README.md) précise le gel Git et les réserves artistiques. Les mentions « non commité » ci-dessous décrivent l'état au moment de cette recette, avant le commit local de référence.

**14 novembre 2026 — tranche expérimentale jouable, statut produit TEST / HOLD.** B est une direction candidate autorisée provisoirement. Cette livraison ne constitue ni une validation artistique définitive, ni une validation commerciale, ni une préparation aux stores.

## Résultat et périmètre

Une scène Godot native complète permet de préparer deux trajets, expédier simultanément A et B, comprendre un raccord invalide, corriger, annuler, utiliser un indice, mettre en pause et rejouer après réussite. Le niveau nouveau « Les deux tournées » utilise une grille 6×6, des droites/coudes à deux ports et des stations fixes. Les six rotations du témoin ne sont pas un PAR optimal certifié.

Le modèle déterministe typé est séparé des animations et du rendu. Les tuiles, rails, pavillons et colis sont de vraies géométries sous caméra orthographique, avec HUD natif et fonte embarquée. Le décor de ciel et deux albedos sont des PNG générés ; aucun concept pleine page ne sert de plateau ou de contrôle.

Le brief antérieur proposait trois micro-niveaux. La mission actuelle autorise **un niveau représentatif** : le double flux du district 02. Le croisement fixe/délai du district 03, la progression, les anciens 18 niveaux HTML, les étoiles, les comptes, la monétisation et le jeu complet restent hors périmètre. Les sources HTML exécutables historiques n'ont pas été reconstituées artificiellement. Voir [VS-001](../decisions/VS-001-archipel-experimental.md).

## Traçabilité et livrables

| Élément | Référence |
|---|---|
| Branche locale | `feat/archipel-postal-vertical-slice` |
| Commit parent conservé | `68548a4b004a047e43d9ce0c77f248ffc07af23d` |
| État des nouveaux travaux | Modifications locales sur cette branche, sans commit ni push de la tranche |
| Moteur réellement exécuté | `4.7.2.stable.official.ed1daf0bf`, Standard, renderer Compatibility |
| Scène | `res://scenes/archipel_postal.tscn` |
| Niveau | `data/archipel_double_flux.json`, ID `archipel-double-flux-01` |
| APK testé | `build/android/switchworks-archipel-slice-debug.apk` ; 61 432 091 octets |
| Empreinte APK | `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1` |
| Package distinct | `org.studio100games.switchworks.archipel.slice`, version 0.1.0 / code 2, debug |
| Preuves conservées | [Manifeste des copies inchangées](evidence/MANIFEST.json), [reçu Android](evidence/android/receipt.json), logs et PNG/MP4 |

L'APK et l'archive source locale sont des artefacts de livraison ignorés par Git. Les preuves sélectionnées sont dans `docs/vertical-slice/evidence/`, séparées des essais intermédiaires conservés sous `artifacts/`. Le manifeste donne leurs dimensions, tailles et SHA256. Les captures montrent un arbre de travail identifié par le commit parent et les sources ajoutées, pas un commit inexistant.

## Démarrer, tester, exporter

Depuis la racine du studio, réutiliser le moteur, les modèles, le JDK et le SDK déjà installés. Aucun autre projet ou réglage système global n'est modifié.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action Run
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action Test
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action Capture -Resolution 360x640 -Scenario planning
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Slice.ps1 -Action ExportAndroid
```

Dans l'éditeur, ouvrir la scène puis F6. F5 conserve la mire historique. Le preset **Android Archipel Slice** sélectionne la tranche via `archipel_slice`, sans remplacer les deux presets ni le package bootstrap.

L'émulateur dédié est **Studio_API_36**, Android 16/API 36, x86_64, 1080×2400, densité 420, GPU `host`. Il utilise uniquement `emulator-5580` et le serveur ADB **5041**. Démarrage et état avec `tools/Start-StudioEmulator.ps1 -Action Start` / `-Action Status`. La recette réellement exécutée est reproductible par :

```powershell
python games/001-switchworks/tools/verify_android_slice.py --help
python games/001-switchworks/tools/verify_android_slice.py
python games/001-switchworks/tools/verify_android_layouts.py
```

Le script vérifie AVD/package, installe le seul APK de la tranche, lit uniquement sa sauvegarde debug et ne vide pas ses données. Les données sauvegardées sont une préparation versionnée, ses compteurs et les préférences. Un nouveau processus revient en planification ; l'historique d'annulation et la phase de trajet ne sont pas restaurés après destruction du processus. Home en mémoire interrompt la session avec reprise explicite.

## Vérifications exécutées

| Contrôle | Résultat observé et portée |
|---|---|
| Import natif et exécution | Code 0, scène réellement rendue ; pas d'erreur de script dans les passages positifs |
| Tests bootstrap conservés | **36 réussites / 0 échec** |
| Modèle gameplay | **137 assertions / 0 échec**, dont 1 000 couples rotation/annulation et identité après quatre rotations |
| Cas d'échec | Hors plateau, connexion manquante, mauvaise destination, autre source et boucle testés |
| Intégration UI | **476 assertions / 0 échec**, cinq tailles, entrée GUI, focus, pause, compteurs, verrouillage de simulation, réussite/échec |
| Contrôles négatifs | Runners gameplay/UI : respectivement 137 et 476 réussites, puis un échec volontaire ; code **1** attendu |
| Famille d'art | **386 assertions géométriques / 0 échec** ; assertions répétées, pas 386 scénarios de gameplay indépendants |
| Compilation globale | **12 scripts vérifiés / 0 cassé**, code 0 ; contrôleur fourni par le skill GDScript |
| Android réel dans l'AVD | **67 vérifications / 67 réussies**, APK inchangé avant/après ; tap, annulation, source fixe, indice, échec, six rotations, deux livraisons |
| Deux ratios Android supplémentaires | **28 contrôles / 0 échec**, 720×1280 et 1200×1600 : 36 centres projetés dans l'écran, tap/annulation, pause/reprise ; taille d'affichage initiale et préparation restaurées |
| Cycle Android | Home pendant trajet, pause/reprise sans nouvelle tentative ; même PID après Home ; restauration après force-stop et nouveau PID |
| Préférences | Mouvement réduit et son optionnel activés par les contrôles Android ; pas d'écoute humaine du son |
| Préservation / export / secrets | Voir [contrôle d'intégrité](../technical/FINAL_INTEGRITY.md) : signature debug, contenus APK et exclusions, fichiers de référence |

Les [protocoles et commandes détaillés](../technical/SLICE_TESTS.md) distinguent les tests synthétiques des entrées réellement envoyées à Android. Les nombres sont des assertions et contrôles techniques, jamais des joueurs ou des essais terrain.

Le premier essai du script Android imposait à tort `LaunchState: HOT`. Android rapporte `UNKNOWN (0)` malgré le même PID, `Status: ok` et une reprise correcte. Ce reçu d'échec reste sous `artifacts/`. L'assertion du script a été corrigée sur ces preuves ; l'APK n'a pas changé.

Le script complémentaire de proportions cherchait initialement `board/rotations` au lieu du champ plat `rotations`. Il s'est arrêté après un toucher ; l'affichage avait été restauré. Le niveau a été remis à zéro par son propre bouton, puis la recette corrigée a passé 28/28 et conservé sa préparation. L'échec du script et le rétablissement sont documentés séparément sous `artifacts/slice-android/layouts-20261114T035745875169Z/`. Aucun de ces correctifs de recette ne modifie le runtime ou l'APK.

## Captures authentiques et revue artistique

| Plateforme / état | Preuve |
|---|---|
| Android — préparation initiale | [planning.png](evidence/android/planning.png) |
| Android — échec réparable | [failed.png](evidence/android/failed.png) |
| Android — deux routes préparées | [prepared.png](evidence/android/prepared.png) |
| Android — colis en mouvement | [in-motion.png](evidence/android/in-motion.png), [vidéo réelle](evidence/android/android-gameplay.mp4) |
| Android — deux livraisons | [won.png](evidence/android/won.png) |
| Android — pause après Home pendant trajet | [running-resumed-paused.png](evidence/android/running-resumed-paused.png) |
| Android — préparation restaurée | [restored-preparation.png](evidence/android/restored-preparation.png) |
| Android — petit portrait supplémentaire | [720×1280](evidence/android-layouts/720x1280-planning.png) |
| Android — ratio tablette supplémentaire | [1200×1600](evidence/android-layouts/1200x1600-planning.png), [pause](evidence/android-layouts/1200x1600-paused.png), [reçu 28/28](evidence/android-layouts/receipt.json) |
| Windows — petit portrait | [360×640](evidence/desktop/desktop-360x640-planning.png) |
| Windows — portraits | [390×844](evidence/desktop/desktop-390x844-planning.png), [412×915](evidence/desktop/desktop-412x915-planning.png) |
| Windows — tablette / paysage | [768×1024](evidence/desktop/desktop-768x1024-planning.png), [844×390](evidence/desktop/desktop-844x390-planning.png) |

Les PNG Android proviennent de `adb exec-out screencap -p` après de vrais touchers et états applicatifs. La vidéo `screenrecord` contient une piste 720×1600, huit secondes demandées, sans audio. Les PNG Windows viennent du framebuffer de la scène exécutée ; les états visuels de capture sont préparés par des arguments de développement. Aucun pixel de gameplay n'a été retouché. Les archives de captures ne sont pas un benchmark de joueurs.

La [revue artistique finale](ART_REVIEW.md) confronte les captures au [concept B v3](../../../../docs/art/switchworks/concepts/b-archipel-postal-v3.png) et à sa [QA](../../../../docs/art/switchworks/QA_CONCEPTS_2026-11-14.md). Le code de forme du colis B est corrigé : **triangle/B partout**, A restant cercle/A. Les réceptions ont un port ouest réel ; fleurs et ornements restent hors des raccords. Les lettres, toits et colis ont été agrandis/calibrés, les enseignes de sol redondantes retirées et l'éclairage ajusté après captures.

Les caractères du HUD sont rendus depuis Nunito Sans, avec poids variable effectivement appliqué. Les couleurs solides donnent un contraste calculé en sRGB d'environ **9,95:1** pour `#203c56` sur `#f5efe2` et **5,78:1** sur le bouton `#edaa7d`. Ce calcul de tokens n'est ni une mesure de tous les pixels 3D, ni une certification WCAG/RGAA. Les actions principales ont une hauteur nominale de 48 unités logiques ; la projection des cases à 360×640 présente un pas de centres d'environ 52×49 pixels. Les marges sûres sont calculées depuis l'OS, mais les encoches et technologies d'assistance physiques ne sont pas certifiées par cet AVD.

Les corrections faites avant gel comprennent aussi le texte de focus trop clair, le pied de page chevauché, le bilan de victoire trop long, le HUD paysage trop petit, le sens des rotations, les ports à des hauteurs différentes et l'invalidation du cache de rendu après reprise Android. Les vrais panneaux de pause et victoire sont maintenant entièrement dans le cadre.

**Réserve de finition conservée :** le résultat natif est plus géométrique et mat que le concept, avec ombres plus franches et détails périphériques simplifiés. La lecture et la famille sont cohérentes pour l'expérience ; l'équivalence de finition au concept n'est pas acquise. Les captures fixes ne mesurent pas le plaisir, la latence tactile perçue ou la satisfaction des animations.

## Performance et erreurs

Mesure sur cet AVD avec traducteur **OpenGL ES 3.1 / NVIDIA 621.24 / RTX 4060 Laptop**, Compatibility. Le moteur est plafonné à 60 FPS dans cette scène. Après échauffement de 60 images, l'observation idle de onze secondes donne 540 intervalles muraux :

| Mesure idle | Valeur |
|---|---:|
| Compteur moteur | 60 FPS |
| Intervalle p50 / p95 | 16,686 / 18,118 ms |
| Draw calls | 23 |
| Mémoire statique Godot | 55 563 880 octets |
| PSS du processus | 201 777 KiB |

Un relevé pendant animation et enregistrement indique **55 FPS / 460 draw calls**, p95 18,858 ms sur une fenêtre roulante mêlant plusieurs états. Ce n'est pas un profil GPU isolé. Le viewport 3D reste en cache à l'arrêt et se met à jour pendant les changements/animations ; aucun gain de batterie n'en est déduit. Les 60 FPS idle ne sont pas généralisés à toutes les phases ou à un téléphone.

Les deux lancements à froid observés ont des `am start -W TotalTime` de **960 et 573 ms**. Le premier framebuffer instrumenté arrive **1 527 et 1 552 ms après `_ready`** ; ces points de départ différents ne donnent pas une mesure complète toucher-icône → jeu prêt. Un essai d'endurance, une mesure thermique/énergétique et un budget sur téléphone physique restent nécessaires.

Aucun `ERROR:` Godot, `SCRIPT ERROR` ou `FATAL EXCEPTION` dans les deux PID de la recette finale. Les lignes natives `ashmem` déprécié et `Failed to load cached shader, recompiling` sont conservées : le moteur recompilait son cache puis rendait la scène. Aucun « zéro avertissement », aucune garantie « zéro bug » et aucune conformité globale ne sont revendiqués.

## Ressources, livraison et limites

Le [registre des assets](../../assets/README.md), le manifeste détaillé, les prompts, l'OFL et les notices Godot sont conservés. Les fontes et notices nécessaires sont incluses dans l'APK. Les conditions du fournisseur des images générées s'appliquent ; une revue des droits pour une commercialisation ultérieure reste ouverte. Aucun achat, SDK publicitaire, serveur, compte ou collecte automatique n'a été ajouté.

La [procédure d'archive source](../technical/SOURCE_DELIVERY.md) décrit le paquet extractible et son contrôle depuis une extraction neuve. Le moteur et SDK ne sont pas redistribués dans ce paquet ; les versions et scripts du studio sont les prérequis explicites. Les clés et caches locaux n'y entrent pas.

Le candidat source RC1 a été effectivement extrait : **458 empreintes vérifiées**, import neuf, tests **36/0 + 137/0 + 476/0**, puis capture GPU de la scène extraite sans erreur. Le paquet final `build/delivery/switchworks-archipel-sources.zip` ajoute ces preuves et les documents de clôture, sans changement runtime. L'AVD dédié et le serveur ADB 5041 ont été arrêtés après la revue pour libérer les ressources ; le package reste installé dans cet AVD et l'affichage initial 1080×2400/densité 420 est restauré. Les commandes Start et Run restent disponibles.

Contrôle de clôture : **463 fichiers candidats**, dont **408 textes décodés UTF-8/UTF-16**, sans motif de secret détecté ; liens locaux de la documentation du jeu valides. Les 60 copies de preuve et les 32 empreintes de sources runtime du manifeste sont vérifiées. Le scan reste une détection de motifs, avec les limites des formats binaires/comprimés explicitées dans la procédure source.

| Critère du brief | Verdict pour cette mission |
|---|---|
| NV-01/02/03/05 | Vérifiés dans le périmètre du niveau double flux |
| NV-04 | Non applicable : district signal/délai non inclus |
| NV-06/07 | Vérifications natives et AVD effectuées ; réserves physiques, assistance et finition encore ouvertes |
| NV-08 | Réussite/échec/annulation/reprise/sauvegarde observés sur APK |
| NV-09 | Captures natives avec moteur, plateforme, scène et parent Git ; un niveau double flux, pas les trois niveaux du brief initial |
| NV-10 | FPS/mémoire/points de chargement AVD relevés ; consommation, endurance et téléphone physique non testés |
| NV-11 | **Non effectué** : aucun participant indépendant |

Prochaines décisions : faire évaluer cette tranche par des joueurs indépendants selon le [protocole produit](../../../../docs/market-research/SWITCHWORKS_HYPOTHESES_ET_TESTS_2026-11-14.md), choisir un Android physique de référence et son budget de performance, puis arbitrer la finition B sur ce rendu réel. iOS reste non vérifié faute de chaîne macOS. Le nom et les hypothèses de marché restent à valider. Le [retour technique réutilisable](../technical/LESSONS_ARCHIPEL.md) ne crée pas de framework partagé avant un second usage démontré.

Aucun push, aucune publication sur un store, aucune opération sur un autre projet et aucune modification système globale n'ont été réalisés pour cette tranche.
