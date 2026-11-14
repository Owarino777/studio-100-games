# Archipel Postal — complément indépendant de lecture temporelle

14 novembre 2026. Ce complément **ne modifie pas le [premier audit statique](INDEPENDENT_ART_AUDIT.md)**. Il ajoute une lecture de la vidéo par images décodées et consultation ciblée du code. Il ne remplace ni un visionnage humain en temps réel, ni une manipulation sur téléphone, ni un avis de joueurs indépendants.

## Source et méthode réellement utilisées

La [vidéo Android originale](../vertical-slice/evidence/android/android-gameplay.mp4), issue du vrai package testé, a été décodée localement par le responsable de recette : **430 images**, piste **720×1600**, durée du conteneur **7,95 s**, sans piste audio. Le décodeur isolé est FFmpeg 9.0.2 ; le log et les métriques de décodage sont conservés sous `artifacts/stabilization/`, sans altération de la vidéo source. Les flux de métadonnées à durée nulle signalés par FFmpeg ne sont pas la piste vidéo.

Ce relecteur a effectivement ouvert avec `view_image` les images extraites **001 à 009 puis 029**, sélectionnées toutes les quinze images encodées. Elles ne sont donc pas espacées d'une durée constante. Aucun montage, recadrage, interpolation ou retouche n'a été produit par cette sous-revue.

| Image extraite | PTS vidéo | Observation dans l'image |
|---|---:|---|
| 001 | 0,000 s | Préparation terminée, colis aux sources, six rotations et un essai, commandes accessibles |
| 002 | 0,267 s | Deux colis partis sur leurs voies distinctes ; essais passé à deux, texte « en route », commandes grisées |
| 003 | 0,514 s | A et B approchent des coudes distincts ; lettres encore lisibles |
| 004 | 0,767 s | A dans son virage descendant, B sur la partie haute de son trajet ; boîtes et glyphes conservent leur orientation à l'écran |
| 005 | 1,063 s | Les deux colis progressent sur les portions centrales, sans chevauchement dans l'image |
| 006 | 1,315 s | A sur sa portion horizontale, B dans le virage descendant ; états et compteurs cohérents avec un trajet en cours |
| 007 | 1,765 s | Colis proches des réceptions, encore 0/2 ; cadre de sélection B bien perceptible |
| 008 | 2,199 s | Colis aux réceptions, compteur 2/2 et bilan de victoire visibles |
| 009 | 2,465 s | Victoire maintenue, action Rejouer accessible visuellement |
| 029 | 7,782 s | Même phase de victoire et colis aux réceptions ; fin du clip surtout consacrée à l'état de résultat |

Les dates ci-dessus sont des **PTS de capture**, pas des délais depuis un toucher observé. L'entrée tactile n'est pas matérialisée dans le clip par un indicateur de doigt. La vidéo commence une fois les rails préparés ; elle ne montre ni rotation de rail, ni annulation, ni échec, ni pause/reprise, ni mouvement réduit. Le son du jeu n'est pas évaluable avec cette piste muette.

## Ce que la séquence permet de conclure

Le départ des deux flux, leur progression et l'état de réussite sont visuellement distincts. Les deux lettres demeurent lisibles dans les virages ; le ciel et la caméra ne concurrencent pas le mouvement des colis. Le nombre d'essais passe de 1 à 2 au départ ; 2/2 et le bilan apparaissent une fois les deux colis aux quais. Aucun désaccord évident entre ces états n'est relevé dans les images inspectées.

Ces observations établissent une séquence de positions plausibles le long des voies. Elles ne certifient pas chaque image intermédiaire, l'absence d'à-coup, une latence tactile, une accélération satisfaisante ou une sensation de poids. La courte durée de déplacement et les deux éléments simultanés justifient d'observer où regardent des personnes découvrant le jeu ; leur attention ne peut pas être déduite de nos captures.

## Code : constats séparés des sensations

Lecture ciblée de `scripts/archipel/board_view.gd` et de la fin d'expédition dans `scripts/archipel/archipel_screen.gd` :

- `STEP_SECONDS=0.32` participe au calcul de durée depuis les ticks du résultat logique. Le parcours est échantillonné géométriquement ; les coudes emploient `slerp` pour construire une série de points, puis une interpolation de position selon la longueur cumulée. **Ce n'est pas une rotation du colis par `slerp`.**
- Le progrès temporel est linéaire ; la position du colis seule est assignée pendant le trajet. Le code consulté n'applique pas une orientation suivant la tangente du rail. La boîte garde donc un comportement de **glissement abstrait**, plutôt qu'un véhicule dont le nez suit le virage.
- Cette orientation constante protège les lettres. Elle peut être un choix de lisibilité valable ; la déclarer automatiquement fautive serait excessif. Le choix entre boîte glissante et transport davantage incarné doit être humain et cohérent avec B. Une éventuelle orientation du volume pourrait laisser le sceau lisible, sans modifier la simulation.
- L'arrivée applique une variation de taille initiale `(1.04, 0.96, 1.04)`, revenant à l'unité en **180 ms**, avec easing `BACK/OUT`. C'est un faible tassement visuel, pas une simulation physique du papier. L'échantillonnage toutes les quinze images est trop espacé pour juger précisément sa courbe ou affirmer qu'il est invisible en lecture réelle.
- Le bilan de victoire est affiché à la fin du trajet logique ; aucun temps séparé de réception du courrier ou rabat/sceau de station n'apparaît dans cette séquence de code. Le tassement peut se poursuivre alors que le bilan est déjà visible. Une information exacte peut ainsi manquer d'une hiérarchie émotionnelle forte ; ce jugement reste à faire confirmer en temps réel.
- Le code de rotation de rail utilise une rotation de 90° en 160 ms, avec easing `CUBIC/OUT`. **Cette animation n'est pas montrée par le clip** ; ses paramètres ne suffisent pas à la qualifier d'agréable ou réactive.

L'objectif du skill `game-feel` est une réponse proportionnée aux événements. Rien n'impose d'ajouter secousse, flash ou hit-stop à un puzzle postal calme. Les animations ne doivent ni masquer un port ni modifier la réussite logique.

## Anomalies et réserves de motion

| ID / statut | Qualification et preuve | Critère d'acceptation proposé pour une passe de finition |
|---|---|---|
| **IM-01 — Majeur artistique : réception peu caractérisée** | Entre 007 et 008, le lecteur passe du trajet au grand panneau de victoire. Les objets ont atteint les quais ; le code ajoute un tassement de 4 %/180 ms, mais pas de geste propre de réception papier, de sceau confirmé ou de différence de station en service. La promesse de B prévoyait un courrier reçu, pas seulement un compteur changé. Il s'agit d'une faiblesse de caractérisation, pas d'un échec fonctionnel prouvé. | Faire accepter une séquence native de réception puis résultat, sur les mêmes assets et le même niveau. Demander séparément à des relecteurs humains « où le colis a-t-il été reçu ? » et « quel événement a confirmé la livraison ? ». Ne pas imposer d'attente bloquante pour fabriquer de l'émotion. |
| **IM-02 — Mineur UX : instruction de préparation conservée pendant le trajet** | Les images 002–007 conservent « Touchez une voie pour la tourner de 90° » sous des commandes grisées, alors que l'édition est verrouillée. Le message « les deux tournées sont en route » donne l'état principal, mais le pied de page continue à proposer un geste momentanément refusé. Aucun échec utilisateur réel n'est inventé à partir de cette incohérence. | Accorder l'aide contextuelle à la phase running, puis restaurer le conseil de rotation quand l'édition redevient possible. Vérifier la compréhension avec et sans mouvement réduit. |
| **IM-03 — Choix artistique à valider, sans gravité de bug attribuée** | Les boîtes glissent en gardant le sceau orienté. La lecture A/B est bonne dans les virages ; une impression de poids, de transport ou de papier reste peu incarnée. Le choix est confirmé par les positions et le code, sa satisfaction ne l'est pas. | Faire comparer en temps réel le comportement actuel à l'intention de B avant toute modification. Conserver les identifiants lisibles, les ports et le résultat déterministe. |
| **IM-04 — Observation non qualifiée : cadre de sélection** | Le cadre B est évident en 007 et dans le PNG `won.png` de l'audit statique. Il paraît moins perceptible dans certaines images finales de la vidéo. Le code consulté ne l'efface pas explicitement à la fin. Cet écart apparent n'est ni une disparition certaine, ni un diagnostic de cache ou de rendu. | Contrôler en exécution réelle la règle voulue pour la sélection pendant trajet/victoire. Ne pas corriger un hypothétique bug sur la seule comparaison d'images compressées et d'états différents. |
| **IM-05 — Preuve manquante, NT** | Le clip couvre une expédition déjà préparée puis une victoire ; il ne permet pas de juger les rotations tactiles, l'échec, la correction, les interruptions et le mouvement réduit. Les tests et autres PNG peuvent vérifier des états, pas leur sensation temporelle. | Une revue externe doit manipuler le build ou disposer d'une capture complémentaire montrant ces gestes existants, sans nouveau gameplay ni faux curseur ajouté. Garder les états non observés en NT. |

**Aucun blocage certain de la séquence de livraison n'est établi par cet échantillon.** IM-01 reste à résoudre ou à accepter explicitement avant une validation artistique. IM-03 et IM-04 ne sont pas des bugs à comptabiliser artificiellement ; IM-05 est une limite de preuve.

## Cadence : mesure du fichier, pas jugement de fluidité humaine

Le relevé fourni par le décodage complet indique 430 images et des PTS monotones : intervalle encodé p50 **16,700 ms**, p95 **33,267 ms**, maximum **67,022 ms**, avec **21 écarts supérieurs à 33,4 ms**. Il s'agit de la cadence du fichier résultant d'Android Emulator, de la charge GPU et de `screenrecord`. La compression H.264 et ses images de référence ne rendent pas ce fichier équivalent au framebuffer PNG pour inspecter tous les pixels.

Ces nombres **ne mesurent ni les FPS du moteur, ni le temps GPU, ni la latence d'entrée, ni un téléphone physique**. Ils ne permettent pas d'attribuer une variation à l'application plutôt qu'au recorder ou à l'émulateur. Les relevés moteur 60 FPS idle et 55 FPS pendant animation/enregistrement restent ceux de la recette séparée, avec leur fenêtre roulante et leurs limites.

## Conclusion de ce complément

Le clip soutient la lisibilité du départ, des deux trajets et du résultat. Il ne clôt pas le gate de game feel. La réception et le lien entre comportement de boîte et promesse de papier précieux restent à arbitrer ; la rotation tactile et les situations d'échec/reprise doivent encore être vues ou manipulées par les relecteurs externes. **HOLD pour l'acceptation artistique reste applicable**, avec possibilité de finition limitée si le propriétaire l'autorise. Aucune validation humaine indépendante ou commerciale n'est prononcée par cet agent.
