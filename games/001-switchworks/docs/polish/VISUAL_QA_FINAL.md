# Archipel Postal — revue visuelle indépendante des PNG Android corrigés

14 novembre 2026. **GO pour la remise de cette correction expérimentale V6, avec réserves ; HOLD pour l'acceptation artistique définitive et toute extension de contenu.** Les gains graphiques et de communication sont visibles dans les captures Android, indépendamment des résultats des tests. Aucun défaut C11 restant n'impose un NO-GO dans le lot examiné. Le défaut mineur VQ-F03 détecté en V5 est maintenant fermé sur trois nouvelles captures de victoire V6 réellement ouvertes.

Ce relecteur est un agent distinct des auteurs des corrections, avec contexte partagé. Il ne représente ni cinq participants indépendants, ni un évaluateur humain, ni une validation commerciale. Le [brouillon sur le candidat 03](VISUAL_QA_DRAFT.md) et la [revue V5](VISUAL_QA_V5.md) sont conservés séparément ; ils ne sont pas réécrits comme s'ils avaient inspecté V6. Le second fichier conserve octet pour octet le rapport provisoire avant ce contrôle final.

## Références exactes et portée

| Lot | APK identifié dans le reçu | Répertoire de captures ouvert |
|---|---|---|
| Avant | `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1` | [Recette avant](evidence/before/receipt.json) |
| Après V6, lot final de ce contrôle | `6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965` ; 61 448 663 octets | [Recette après V6](evidence/after/receipt.json) |
| Historique V5 avant fermeture de VQ-F03 | `a384923a6d8fa2900844b94937089c84f1ab9800a54284fa7bd0fd02802e1d42` | [Image témoin V5](evidence/candidates/v5-1200x1600-won.png) et [rapport conservé](VISUAL_QA_V5.md) |

Les reçus avant et V6 indiquent `status: passed`. Cette information identifie les lots ; elle ne constitue pas une note artistique attribuée par le relecteur. Les PNG sont des captures natives de Studio_API_36, Android 16/API 36, Godot 4.7.2 Standard / Compatibility, scène `res://scenes/archipel_postal.tscn`. Ce rapport ne prétend pas avoir relancé lui-même l'APK ou mesuré sa performance.

**Les douze PNG V6 ont réellement été ouverts avec `view_image`, dans leurs copies durables.** Ils sont comparés aux sept images avant déjà ouvertes, dont l'identité octet pour octet entre fichiers sources et copies durables a aussi été contrôlée. Le noyau comparatif final comporte ainsi dix-neuf images :

| Taille | Avant inspecté | Après V6 inspecté |
|---|---|---|
| 1080×2400 | préparation, transport, réussite, reprise | préparation, transport, réussite, reprise |
| 720×1280 | préparation | préparation, transport, réussite, reprise |
| 1200×1600 | préparation et réussite | préparation, transport, réussite, reprise |

Auparavant, les douze PNG V5 de ces mêmes quatre états avaient été ouverts ; leurs observations restent dans le rapport historique. Les nouvelles images V6 ne sont pas présentées comme ces anciens fichiers V5. Le changement visible de victoire, notamment en 1200×1600, a été recontrôlé dans les trois PNG V6 correspondants.

Les deux documents de critique utilisateur et les skills `studio-art-direction` / `studio-visual-qa` avaient été lus intégralement pour le premier contrôle. Le [concept B v3](../../../../docs/art/switchworks/concepts/b-archipel-postal-v3.png) a été ouvert : c'est une illustration d'intention, non une preuve de gameplay ou une alternative native.

**Limite temporelle :** les PNG montrent l'état intermédiaire de transport et la fin de réception, pas la courbe d'animation. La nouvelle vidéo est traitée séparément par le responsable de recette. Ce rapport n'évalue pas la fluidité humaine, l'écoute, le toucher, le mode réduit en mouvement, les safe areas d'un téléphone physique ou iOS.

## Comparaison observée

| Critère | Avant → après | Décision dans le périmètre inspecté |
|---|---|---|
| **C01 — But et première action** | L'ancienne aide générique, située sous le plateau, est remplacée par l'objectif explicite « Livrez A → A et B → B » dans l'en-tête, puis une seule instruction de préparation au-dessus du réseau. | **Amélioration nette.** Les deux relations d'adresse se lisent sans déduire la règle des seules couleurs. La compréhension humaine en trois secondes n'est pas mesurée. |
| **C02 — Départs et réceptions** | Les pavillons jumeaux deviennent guichets de départ avec flèches vers les voies, et boîtes de réception avec capot/enveloppe. Les lettres A/B demeurent visibles. | **Réserve principale corrigée visuellement.** Les rôles possèdent maintenant un code différent de la seule couleur ou de la présence initiale du colis. Le seuil 4/5 testeurs reste à vérifier. |
| **C03 — Rails et raccords** | Les traverses blanches en motif serré sont remplacées par des supports peu saillants ; les profils sont plus continus et perceptibles. | **Amélioration réelle**, surtout dans le transport et la réussite. Les deux itinéraires sont suivables ; aucune rupture graphique évidente nouvelle n'est observée dans les images. La topologie logique reste un contrôle technique séparé. |
| **C05 — Hiérarchie et marges** | Marque et compteurs compactés, consigne remontée, pied redondant supprimé ; les boutons restent identifiables. La rangée de préparation ne transparaît plus derrière le bilan de victoire V6. | **Amélioration nette.** Dans les douze PNG V6 examinés, aucun texte essentiel n'est coupé ou collé sous les actions. Les marges d'un appareil physique restent NT. |
| **C10 — Famille et matières** | Les faces crème sont maintenant cadrées par un liseré céladon et un bord de coque plus explicite ; les volumes papier et kraft gardent un autre traitement. Les fleurs sont moins facettées visuellement. | **Progression perceptible par rapport au candidat 03**, sans bruit de texture ajouté aux parcours. La matière demeure une interprétation sobre, moins riche et moins glaçurée que le concept. Cette limite doit être gardée, pas convertie en fidélité parfaite. |
| **C11 — Ombres et contours** | Les grosses masses noires et dentelées des pavillons, colis et fleurs ont disparu au profit d'un modelé/contact beaucoup moins contrasté. | **Le défaut majeur de la référence est corrigé dans ce lot.** Les bords et ports ne sont plus concurrencés par les anciennes taches d'ombre. Ce jugement porte sur l'apparence, pas sur une promesse de pénombre physique ou de technique de rendu. |
| **C12 — Réception locale, état final seulement** | Avant, les colis restent devant des pavillons ; après, ils ne restent plus dehors et chaque boîte affiche son sceau de réception. | **Fin de réception plus explicite**, même sans lire 2/2. La qualité du geste d'ouverture/entrée/fermeture doit être jugée dans la nouvelle vidéo ; les PNG ne suffisent pas. |
| **Guidage des états** | Le transport annonce « Livraison en cours. Les colis rejoignent leurs boîtes » sans invite à tourner ; la reprise prête annonce « Préparation retrouvée : voies prêtes. Vous pouvez expédier » ; le bilan écrit « 2 essais ». | **Incohérences signalées corrigées dans les états photographiés**, y compris aux deux ratios supplémentaires. Aucune ligne importante ne manque dans les douze images V6 ouvertes. |

## Preuves centrales

- Préparation : [avant 1080×2400](evidence/before/1080x2400/planning.png) / [après V6](evidence/after/1080x2400/planning.png).
- Transport : [avant](evidence/before/1080x2400/transport.png) / [après V6](evidence/after/1080x2400/transport.png).
- Réussite : [avant](evidence/before/1080x2400/won.png) / [après V6](evidence/after/1080x2400/won.png).
- Reprise : [avant](evidence/before/1080x2400/restored.png) / [après V6](evidence/after/1080x2400/restored.png).
- Petit portrait : [préparation 720×1280](evidence/after/720x1280/planning.png) / [reprise](evidence/after/720x1280/restored.png) / [victoire V6](evidence/after/720x1280/won.png).
- Ratio tablette : [préparation 1200×1600](evidence/after/1200x1600/planning.png) / [reprise](evidence/after/1200x1600/restored.png) / [victoire V6](evidence/after/1200x1600/won.png).

## Réserves restantes

**Aucun bloquant certain nouveau n'a été observé dans le noyau final avant/V6.** Cela n'est pas une garantie pour tous les états, tous les appareils ou tous les utilisateurs.

| ID / qualification | Observation et preuve | Suite raisonnable |
|---|---|---|
| **VQ-F01 — Réserve artistique à valider, non bloquante pour ce correctif** | Les grandes faces restent très calmes et les toitures de départ simples. Le liseré/coque rend mieux la céramique que dans le candidat 03, mais la richesse de glaçure, les plis et le charme des objets du concept ne sont pas pleinement atteints. | Faire juger la reconnaissance des matières et le degré de sobriété par des personnes indépendantes. Ne pas prétendre que l'ajout de bord ou de réflexion clôt cette question à lui seul. |
| **VQ-F02 — Mineur : respirations et espace utile** | Le 1080×2400 garde de grandes plages de ciel entre HUD et plateau, puis entre plateau et actions. Le HUD attire moins l'attention, mais le plateau n'a pas fortement gagné d'emprise. | Arbitrer sur appareil la tenue et le rythme vertical ; ne pas remplir tout le ciel par principe. Ce vide ne bloque pas la lecture observée. |
| **VQ-F03 — Mineur corrigé et fermé visuellement en V6** | En [V5 1200×1600](evidence/candidates/v5-1200x1600-won.png), les extrémités grisées d'Annuler et Indice transparaissaient aux côtés du panneau, comme [avant](evidence/before/1200x1600/won.png). Dans la [victoire V6 1200×1600](evidence/after/1200x1600/won.png), elles ne sont plus visibles ; l'état est également propre dans les victoires V6 1080×2400 et 720×1280 ouvertes. | Correction visuelle acceptée dans ces trois captures. Le tableau de préparation réapparaît dans les images de reprise V6 ; aucune conclusion de bug de commandes n'avait été déduite du défaut visuel initial. |
| **VQ-F04 — Mineur / physique NT : finesse de la signalétique de forme** | Les grandes lettres sont lisibles dans les PNG ; les petits contours cercle/triangle du colis restent plus délicats à distinguer, notamment en 720×1280. | Confronter au téléphone réel, à faible luminosité et sans dépendance à la teinte. Une vue native haute résolution n'est pas un test de capacités visuelles. |
| **VQ-F05 — Compromis d'état final, pas un blocage** | Le bilan 720×1280 et 1200×1600 recouvre la dernière rangée vide et une partie du décor bas. Les réceptions A/B et leurs sceaux restent visibles, les itinéraires utiles sont lisibles et l'action Rejouer est contenue dans le cadre. | Garder ce compromis explicite ; réévaluer seulement s'il masque une information essentielle sur un appareil cible. |

VQ-F01 ne clôt pas automatiquement l'ancienne réserve de matière pour une future acceptation artistique complète. Elle est requalifiée ici pour **la livraison de la correction demandée**, car les progrès sont visibles et la scène n'est pas présentée comme finie ou commercialisable. Le contrôle vidéo, le mode réduit et les performances restent des portes de recette séparées.

## Verdict argumenté

**GO de revue visuelle statique V6 pour remettre la correction au propriétaire ; pas de NO-GO C11 restant dans le périmètre inspecté.** Les trois nouvelles victoires V6 ferment VQ-F03. L'amélioration ne repose pas seulement sur davantage d'assertions réussies : ombres, rôle des stations, bruit des rails, objectif et consignes changent clairement dans le rendu réel.

Repères experts non agrégés : lisibilité des parcours **3/4**, rôles et hiérarchie **3/4 provisoire**, cohérence de famille **3/4 provisoire**, ombres/contours **3/4 dans ce lot**. Richesse matérielle et identité définitive restent **à valider humainement** ; motion, confort tactile, accessibilité système et performance ne sont pas notés par ce rapport. Aucun total ne masque une réserve.

La suite requiert les nouvelles preuves vidéo et techniques, puis les cinq tâches proposées auprès de personnes indépendantes. Le seuil 4/5 n'a pas été exécuté par ce relecteur. **SWITCHWORKS reste TEST / HOLD** ; aucun nouvel écran, niveau ou service ne doit être déduit de ce GO limité.

## Annexe — réception locale dans trois extraits de la vidéo V6

Complément de portée, sans modifier les verdicts ni les PNG précédents. La [vidéo de régression V6](evidence/regression/android-gameplay.mp4) est un enregistrement réel 720×1600 lié à l'APK `6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965`. Son SHA256 a été lu localement : `b5eec73d4a90b5f21f2c063d5a95ec3be67cfec092b24ce6e09296581787846c`. Le responsable rapporte un décodage complet de 427 images sur environ 7,97 s ; ce relecteur a effectivement ouvert les **trois images décodées** ci-dessous, pas visionné la vidéo en temps réel.

| Extrait / PTS fourni par le décodage | Observation locale, sans utiliser le compteur |
|---|---|
| [021 — 2,167600 s](evidence/video-analysis/arrival-frame-021.png) | Les deux colis restent partiellement visibles à l'entrée ouest de leur boîte ; les volets présentent une saillie latérale. Les lettres des colis sont en partie occultées par le réceptacle, contrairement au colis simplement garé devant l'ancien pavillon. Les deux confirmations de toit ne sont pas encore affichées. |
| [023 — 2,385289 s](evidence/video-analysis/arrival-frame-023.png) | Les colis ne dépassent plus des entrées et chaque boîte A/B porte sa propre confirmation blanche/verte. Ces deux changements se lisent localement au niveau des réceptions, même en ignorant 2/2 et le titre du bilan. Le clapet reste un détail discret à cette échelle. |
| [025 — 2,569311 s](evidence/video-analysis/arrival-frame-025.png) | Les deux confirmations restent présentes, sans colis à l'extérieur ; les volets ont rejoint visuellement le corps des boîtes. L'état « courrier reçu » est stable dans cette image. |

**Constat limité : entrée/occultation du colis puis confirmation locale A/B sont distinguables dans cette séquence d'extraits.** Le défaut « seule la modification du compteur annonce la réception » ne décrit plus ce résultat. En revanche, la courbe et l'agrément du clapet ne peuvent pas être jugés finement par trois échantillons ; sa lisibilité gestuelle reste à confirmer en lecture réelle sur téléphone.

Le bilan est déjà visible dans le premier extrait, pendant que le dépôt visuel se termine. Cela conserve l'action Rejouer sans attente supplémentaire mais peut concurrencer l'attention portée aux boîtes : c'est un compromis de hiérarchie à observer auprès de joueurs, pas un blocage fonctionnel établi ici. Aucun délai tactile, temps GPU, FPS du jeu, son ou score humain n'est inféré des PTS ou du nombre d'images encodées. Ces extraits complètent la preuve de réception ; ils ne constituent pas une validation humaine du game feel ou du mode mouvement réduit.
