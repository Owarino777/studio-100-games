# Corrections natives de la famille Archipel — 14 novembre 2026

Passe ciblée depuis la référence `d36af097`, suivant P1/P2 de la revue critique. Aucun PNG de jeu n'est remplacé ou régénéré ; les sources précédentes restent dans Git. Ces notes décrivent les objets, pas une acceptation artistique humaine.

## Famille et intentions

- **Porcelaine** : même tuile et même emprise, dessus Y=0,12. Les normales des biseaux sont désormais interpolées autour des coins et sur les parties planes. Une coque à rebord celadon feutré entoure un cap glacé ivoire légèrement encastré : coque maximale Y=0,12 et fond Y=0,101 ; cap de largeur 0,890, base Y=0,101 et épaisseur 0,019. Cette construction ajoute exactement un mesh par tuile et rend le bord perceptible sans bruit d'albedo supplémentaire. La marge de teinte de 18 % est conservée après un essai à 7 % trop clair dans le vrai jeu ; la rugosité du cap est 0,26, face au papier de toit à 0,68 et au kraft à 0,93. L'albedo céramique existant reste inchangé. L'exposition et la réflexion doivent être jugées avec les lumières finales de la scène, pas avec l'ancien showcase.
- **Départ** : le guichet conserve le toit de papier plié et ses ports physiques. Une flèche en relief sur la partie libre avant de la rampe pointe vers l'est (centre approximatif X=0,235/Z=0,365 ; sommet Y=0,225) ; elle reste visible avec le colis initial. Les plis et la couture du toit sont des géométries. Le signe A/cercle ou B/triangle reste unique et lisible.
- **Réception** : silhouette de boîte de collecte basse, corps en porcelaine, capot voûté émaillé, fente et clapet. Une enveloppe en relief sur le capot précise le rôle depuis la caméra presque verticale. Ce volume diffère du toit pointu du départ et ne dépend pas uniquement de la couleur.
- **Colis** : carton arrondi, rabat conservé, bandes chaudes prolongées sur les faces, kraft mat. Aucun changement des racines, des identités ou du placement de départ attendu.
- **Voies** : deux meshes par pièce comme auparavant. Les profils émaillés passent de 0,026 à 0,035 unité de demi-largeur ; quatre traverses fines crème chaude remplacent huit traverses plus épaisses. Masques, orientations, extrémités et hauteurs des ports restent identiques.
- **Fleurs** : mêmes objets périphériques, pétales/feuilles plus arrondis, silhouette plus basse ; leurs ombres portées sont désactivées afin de ne pas produire les anciennes taches polygonales. La lumière et l'ombre de contact globale restent du ressort de la scène.

## Contrat de réception pour la vue

`create_station()` garde son API. Les métadonnées `port` E/W et `is_source` restent présentes ; `role` ajoute `dispatch` ou `reception`. `StationTrack.position.y` reste zéro. Les sources possèdent `DispatchCanopy` et `DispatchArrow` ; les réceptions `ReceptionBody`, `ReceptionHood` et `ReceptionEnvelope`.

La destination est toujours tournée de PI autour de Y : **son +X local pointe vers l'ouest du plateau**. Enfants directs destinés au feedback de la vue :

| Enfant | État initial et usage |
|---|---|
| `ReceptionLid` | Pivot local `(0,23 ; 0,60 ; 0)`, rotation nulle. Une rotation Z positive d'environ 0,75 rad ouvre le clapet vers l'extérieur. Revenir à zéro après réception. |
| `ReceiptSeal` | Position locale `(0,015 ; 0,78 ; 0,12)`, échelle unité, `visible=false`. Petit sceau à coche, à montrer pour confirmer le dépôt. Il ne remplace pas le code d'adresse A/B. |

Le mode de mouvement réduit peut appliquer directement l'état reçu sans tween. L'animation ne décide jamais du succès logique et ne doit pas retarder les commandes.

## Vérifications et provenance

Le code de la fabrique a été exécuté dans Godot 4.7.2 Standard. Le contrôle géométrique disponible au gel de la coque/cap donne **464 assertions passées, zéro échec**, 111 meshes et 12 051 triangles custom sur sa famille échantillon. Ce nombre ne mesure ni le coût du plateau complet ni une performance Android, et les assertions supplémentaires de la recette peuvent le faire évoluer.

Une planche native a été rendue sous `artifacts/polish/asset-family/`. Cette inspection a détecté puis corrigé un sens de faces inversé sur le capot ; les images d'essai restent conservées. L'ancien éclairage du showcase surexpose certaines surfaces et n'est pas une preuve d'acceptation finale. L'écran exécuté `artifacts/polish/asset-celadon-candidate.png` a aussi été inspecté à 390×844 : le bord est perceptible sans masquer les voies. La comparaison recevable utilise ensuite le vrai jeu, son éclairage final et l'APK Android.

Le repère de départ a été déplacé/épaissi après relecture et vérifié dans `asset-arrows-390x844.png`, avec les colis présents. L'essai de fenêtre nommé `asset-arrows-1080x2400.png` n'est **pas** une preuve Android à cette taille : Windows a limité le framebuffer réellement enregistré à 1080×1175. Les dimensions réelles ont été lues dans le PNG ; ce fichier d'essai reste dans les intermédiaires, sans être rebaptisé en capture Android.

Tout ajout de géométrie est une création locale du projet. Fonte, textures et notices gardent leur provenance et leurs conditions antérieures ; aucun modèle, pack, photo ou identité concurrente n'est copié. Les sources et les contraintes des textures générées restent celles du manifeste existant. Les tests humains de reconnaissance en trois secondes et de préférence artistique ne sont pas réalisés par cette note.
