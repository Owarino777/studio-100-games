# Archipel Postal — revue visuelle indépendante des PNG Android corrigés

14 novembre 2026. **GO provisoire de revue statique de V5, avec réserves ; contrôle complémentaire V6 attendu avant remise finale. HOLD pour l'acceptation artistique définitive et toute extension de contenu.** Les gains graphiques et de communication sont visibles dans les captures Android, indépendamment des résultats des tests. Aucun défaut C11 restant n'impose un NO-GO dans le lot examiné. Le défaut mineur VQ-F03 est en cours de correction et n'est pas déclaré fermé sans ses nouvelles captures.

Ce relecteur est un agent distinct des auteurs des corrections, avec contexte partagé. Il ne représente ni cinq participants indépendants, ni un évaluateur humain, ni une validation commerciale. Le [brouillon sur le candidat 03](VISUAL_QA_DRAFT.md) est conservé séparément ; il n'est pas réécrit comme s'il avait inspecté ces images ultérieures.

## Références exactes et portée

| Lot | APK identifié dans le reçu | Répertoire de captures ouvert |
|---|---|---|
| Avant | `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1` | [Recette avant](../../artifacts/polish/android-before-20261114T045408403729Z/receipt.json) |
| Après V5, passage r3 conservé avant correction mineure | `a384923a6d8fa2900844b94937089c84f1ab9800a54284fa7bd0fd02802e1d42` ; 61 448 663 octets | [Recette après V5](../../artifacts/polish/android-after-20261114T051837886476Z/receipt.json) |

Les deux reçus indiquent `status: passed`. Cette information identifie les lots ; elle ne constitue pas une note artistique attribuée par le relecteur. Les PNG sont des captures natives de Studio_API_36, Android 16/API 36, Godot 4.7.2 Standard / Compatibility, scène `res://scenes/archipel_postal.tscn`. Ce rapport ne prétend pas avoir relancé lui-même l'APK ou mesuré sa performance.

**Dix-neuf PNG Android ont réellement été ouverts avec `view_image` :**

| Taille | Avant inspecté | Après inspecté |
|---|---|---|
| 1080×2400 | préparation, transport, réussite, reprise | préparation, transport, réussite, reprise |
| 720×1280 | préparation | préparation, transport, réussite, reprise |
| 1200×1600 | préparation et réussite | préparation, transport, réussite, reprise |

Les deux documents de critique utilisateur et les skills `studio-art-direction` / `studio-visual-qa` avaient été lus intégralement pour le premier contrôle. Le [concept B v3](../../../../docs/art/switchworks/concepts/b-archipel-postal-v3.png) a été ouvert : c'est une illustration d'intention, non une preuve de gameplay ou une alternative native.

**Limite temporelle :** les PNG montrent l'état intermédiaire de transport et la fin de réception, pas la courbe d'animation. La nouvelle vidéo est traitée séparément par le responsable de recette. Ce rapport n'évalue pas la fluidité humaine, l'écoute, le toucher, le mode réduit en mouvement, les safe areas d'un téléphone physique ou iOS.

## Comparaison observée

| Critère | Avant → après | Décision dans le périmètre inspecté |
|---|---|---|
| **C01 — But et première action** | L'ancienne aide générique, située sous le plateau, est remplacée par l'objectif explicite « Livrez A → A et B → B » dans l'en-tête, puis une seule instruction de préparation au-dessus du réseau. | **Amélioration nette.** Les deux relations d'adresse se lisent sans déduire la règle des seules couleurs. La compréhension humaine en trois secondes n'est pas mesurée. |
| **C02 — Départs et réceptions** | Les pavillons jumeaux deviennent guichets de départ avec flèches vers les voies, et boîtes de réception avec capot/enveloppe. Les lettres A/B demeurent visibles. | **Réserve principale corrigée visuellement.** Les rôles possèdent maintenant un code différent de la seule couleur ou de la présence initiale du colis. Le seuil 4/5 testeurs reste à vérifier. |
| **C03 — Rails et raccords** | Les traverses blanches en motif serré sont remplacées par des supports peu saillants ; les profils sont plus continus et perceptibles. | **Amélioration réelle**, surtout dans le transport et la réussite. Les deux itinéraires sont suivables ; aucune rupture graphique évidente nouvelle n'est observée dans les images. La topologie logique reste un contrôle technique séparé. |
| **C05 — Hiérarchie et marges** | Marque et compteurs compactés, consigne remontée, pied redondant supprimé ; les boutons restent identifiables. | **Amélioration nette.** Dans les douze PNG après examinés, aucun texte essentiel n'est coupé ou collé sous les actions. Les marges d'un appareil physique restent NT. |
| **C10 — Famille et matières** | Les faces crème sont maintenant cadrées par un liseré céladon et un bord de coque plus explicite ; les volumes papier et kraft gardent un autre traitement. Les fleurs sont moins facettées visuellement. | **Progression perceptible par rapport au candidat 03**, sans bruit de texture ajouté aux parcours. La matière demeure une interprétation sobre, moins riche et moins glaçurée que le concept. Cette limite doit être gardée, pas convertie en fidélité parfaite. |
| **C11 — Ombres et contours** | Les grosses masses noires et dentelées des pavillons, colis et fleurs ont disparu au profit d'un modelé/contact beaucoup moins contrasté. | **Le défaut majeur de la référence est corrigé dans ce lot.** Les bords et ports ne sont plus concurrencés par les anciennes taches d'ombre. Ce jugement porte sur l'apparence, pas sur une promesse de pénombre physique ou de technique de rendu. |
| **C12 — Réception locale, état final seulement** | Avant, les colis restent devant des pavillons ; après, ils ne restent plus dehors et chaque boîte affiche son sceau de réception. | **Fin de réception plus explicite**, même sans lire 2/2. La qualité du geste d'ouverture/entrée/fermeture doit être jugée dans la nouvelle vidéo ; les PNG ne suffisent pas. |
| **Guidage des états** | Le transport annonce « Livraison en cours. Les colis rejoignent leurs boîtes » sans invite à tourner ; la reprise prête annonce « Préparation retrouvée : voies prêtes. Vous pouvez expédier » ; le bilan écrit « 2 essais ». | **Incohérences signalées corrigées dans les états photographiés**, y compris aux deux ratios supplémentaires. Aucune ligne importante ne manque dans les images finales r3 ouvertes. |

## Preuves centrales

- Préparation : [avant 1080×2400](../../artifacts/polish/android-before-20261114T045408403729Z/1080x2400/planning.png) / [après](../../artifacts/polish/android-after-20261114T051837886476Z/1080x2400/planning.png).
- Transport : [avant](../../artifacts/polish/android-before-20261114T045408403729Z/1080x2400/transport.png) / [après](../../artifacts/polish/android-after-20261114T051837886476Z/1080x2400/transport.png).
- Réussite : [avant](../../artifacts/polish/android-before-20261114T045408403729Z/1080x2400/won.png) / [après](../../artifacts/polish/android-after-20261114T051837886476Z/1080x2400/won.png).
- Reprise : [avant](../../artifacts/polish/android-before-20261114T045408403729Z/1080x2400/restored.png) / [après](../../artifacts/polish/android-after-20261114T051837886476Z/1080x2400/restored.png).
- Petit portrait : [préparation 720×1280](../../artifacts/polish/android-after-20261114T051837886476Z/720x1280/planning.png) / [reprise](../../artifacts/polish/android-after-20261114T051837886476Z/720x1280/restored.png).
- Ratio tablette : [préparation 1200×1600](../../artifacts/polish/android-after-20261114T051837886476Z/1200x1600/planning.png) / [reprise](../../artifacts/polish/android-after-20261114T051837886476Z/1200x1600/restored.png).

## Réserves restantes

**Aucun bloquant certain nouveau n'a été observé dans les dix-neuf PNG.** Cela n'est pas une garantie pour tous les états, tous les appareils ou tous les utilisateurs.

| ID / qualification | Observation et preuve | Suite raisonnable |
|---|---|---|
| **VQ-F01 — Réserve artistique à valider, non bloquante pour ce correctif** | Les grandes faces restent très calmes et les toitures de départ simples. Le liseré/coque rend mieux la céramique que dans le candidat 03, mais la richesse de glaçure, les plis et le charme des objets du concept ne sont pas pleinement atteints. | Faire juger la reconnaissance des matières et le degré de sobriété par des personnes indépendantes. Ne pas prétendre que l'ajout de bord ou de réflexion clôt cette question à lui seul. |
| **VQ-F02 — Mineur : respirations et espace utile** | Le 1080×2400 garde de grandes plages de ciel entre HUD et plateau, puis entre plateau et actions. Le HUD attire moins l'attention, mais le plateau n'a pas fortement gagné d'emprise. | Arbitrer sur appareil la tenue et le rythme vertical ; ne pas remplir tout le ciel par principe. Ce vide ne bloque pas la lecture observée. |
| **VQ-F03 — Mineur : boutons de préparation partiellement visibles derrière le bilan tablette** | En [réussite 1200×1600](../../artifacts/polish/android-after-20261114T051837886476Z/1200x1600/won.png), les extrémités grisées d'Annuler et Indice restent visibles aux côtés du panneau. Le même défaut est présent [avant](../../artifacts/polish/android-before-20261114T045408403729Z/1200x1600/won.png) : ce n'est pas une régression introduite par la passe. Aucune action derrière le panneau n'est démontrée par ce PNG. | Masquer la rangée de préparation pendant la victoire donnerait un état plus propre, sans changer la mécanique. Cette réserve ne justifie pas seule un NO-GO de la passe, mais doit rester signalée si non corrigée. |
| **VQ-F04 — Mineur / physique NT : finesse de la signalétique de forme** | Les grandes lettres sont lisibles dans les PNG ; les petits contours cercle/triangle du colis restent plus délicats à distinguer, notamment en 720×1280. | Confronter au téléphone réel, à faible luminosité et sans dépendance à la teinte. Une vue native haute résolution n'est pas un test de capacités visuelles. |
| **VQ-F05 — Compromis d'état final, pas un blocage** | Le bilan 720×1280 et 1200×1600 recouvre la dernière rangée vide et une partie du décor bas. Les réceptions A/B et leurs sceaux restent visibles, les itinéraires utiles sont lisibles et l'action Rejouer est contenue dans le cadre. | Garder ce compromis explicite ; réévaluer seulement s'il masque une information essentielle sur un appareil cible. |

VQ-F01 ne clôt pas automatiquement l'ancienne réserve de matière pour une future acceptation artistique complète. Elle est requalifiée ici pour **la livraison de la correction demandée**, car les progrès sont visibles et la scène n'est pas présentée comme finie ou commercialisable. Le contrôle vidéo, le mode réduit et les performances restent des portes de recette séparées.

## Verdict argumenté

**GO provisoire de revue visuelle statique V5 ; pas de NO-GO C11 restant dans le périmètre inspecté.** Le contrôle des trois nouveaux états de victoire V6 doit encore clore VQ-F03 avant le verdict de remise. L'amélioration ne repose pas seulement sur davantage d'assertions réussies : ombres, rôle des stations, bruit des rails, objectif et consignes changent clairement dans le rendu réel.

Repères experts non agrégés : lisibilité des parcours **3/4**, rôles et hiérarchie **3/4 provisoire**, cohérence de famille **3/4 provisoire**, ombres/contours **3/4 dans ce lot**. Richesse matérielle et identité définitive restent **à valider humainement** ; motion, confort tactile, accessibilité système et performance ne sont pas notés par ce rapport. Aucun total ne masque une réserve.

La suite requiert les nouvelles preuves vidéo et techniques, puis les cinq tâches proposées auprès de personnes indépendantes. Le seuil 4/5 n'a pas été exécuté par ce relecteur. **SWITCHWORKS reste TEST / HOLD** ; aucun nouvel écran, niveau ou service ne doit être déduit de ce GO limité.
