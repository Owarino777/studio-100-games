# SWITCHWORKS — revue externe de la passe Archipel Postal P1/P2/P3

Date : 14 novembre 2026  
État examiné : branche `fix/archipel-postal-finition-p1-p2`, commit `108e2b04` **déclaré par le producteur, non inspecté directement dans Git**.  
Statut : **GO pour une campagne de tests utilisateurs sur appareils physiques ; HOLD pour la validation artistique finale, l'extension du contenu et la commercialisation**.

## Corpus réellement inspecté

- `comparison-planning-1080x2400.png` : montage comparatif avant/après communiqué par le projet. Les deux colonnes montrent la préparation ; la planche n'est pas en soi une capture brute unique.
- `android-gameplay.mp4` : vidéo Android H.264 de 720 × 1600 px, durée 7,972 s ; vérification visuelle par échantillonnage et agrandissement de la séquence de réception. Le média ne possède pas de piste sonore exploitable.
- `REPORT(3).md` : recette détaillée du correctif P1/P2/P3 et des limites connues.

**Périmètre de vérification** : le jugement artistique/UX porte sur les images et la vidéo fournies. Aucune installation directe de l'APK, manipulation tactile, revue des sources Godot, appareil physique ou contrôle indépendant des suites automatisées n'a été réalisé dans cette revue.

## Tableau de décision

| Point | Appréciation | Motif |
|---|---|---|
| Départs / destinations | Corrigé sur l'image | Guichets fléchés d'un côté, boîtes avec pictogramme enveloppe de l'autre ; silhouettes distinctes. |
| Rails | Amélioration confirmée | Deux parcours identifiables, traverses visuellement réduites. |
| Ombres | Amélioration confirmée | Les ombres noires polygonales dominantes ont été largement atténuées. |
| Guidage par état | Cohérent sur les états montrés | La vidéo en transport affiche une consigne de livraison. Les états reprise et pause ne sont pas démontrés par cette vidéo seule. |
| Réception / victoire | Amélioration confirmée | Arrivée du colis A vers 1,70–2,15 s : ouverture du clapet, entrée en boîte, coche ; victoire vers 2,20 s. La réception B est visible dans la séquence globale. |
| Matières | Partiellement abouties | Bordures céramiques, volume des stations et palette cohérente, mais surfaces des tuiles très uniformes et peu riches à l'échelle de l'image. |
| Composition / HUD | À valider physiquement | Header plus compact et objectif mieux hiérarchisé ; plateau relativement petit au regard de la grande surface de ciel et des marges verticales. |

## Points à surveiller sans lancer une nouvelle refonte

1. **Lisibilité des indices de rôle** : sur la vidéo 720 × 1600, les flèches, enveloppes et éventuels indices de forme sont petits. Tester la distinction entre « départ » et « destination » sans explication orale, y compris lorsque A/B sont répétés sur le colis et la station.
2. **Ergonomie physique** : les rails et les tuiles occupent une partie limitée de la hauteur de l'écran. Vérifier que les rotations restent faciles, avec un doigt, sur un téléphone standard et un petit téléphone.
3. **Contraste de la hiérarchie** : vérifier en plein jour et à luminosité moyenne les compteurs, le texte et les indices d'action. Ne pas conclure à une conformité d'accessibilité sur la seule inspection visuelle.
4. **Direction artistique** : le thème est reconnaissable et plus cohérent, mais encore sensiblement moins riche que l'illustration conceptuelle. L'éventuelle passe de matériaux doit être pilotée par retours utilisateurs et contrainte de performance.
5. **Récompense sensorielle** : la réception possède un comportement local lisible, mais l'extrait est muet ; impact audio et haptique non évalué. Ne pas présumer de leur présence.

Aucun défaut fonctionnel bloquant n'a été établi par les trois pièces examinées. Cela ne prouve pas son absence dans l'APK.

## Protocole de validation humaine conseillé

Organiser cinq sessions individuelles exploratoires avec des personnes n'ayant pas participé au développement. Le seuil historique « 4/5 » est un **critère décisionnel proposé**, non une preuve statistique de qualité.

- Installer l'APK sur un téléphone Android ARM64 physique ; relever modèle, OS, taille d'écran et mode d'affichage. Tester idéalement un deuxième format de téléphone.
- Donner une consigne neutre : « Voici un jeu de livraison. Essaie de réaliser la tournée sans aide. » Ne pas expliquer les flèches, les boîtes, les rotations ni le bouton Expédier à l'avance.
- Observer sans aider : identification des deux départs, des deux destinations et de l'objectif ; rotation de voies ; lancement d'une tournée ; compréhension de la réception et du résultat ; utilisation d'Annuler ou d'Indice en cas de blocage.
- Dans un second temps, faire tester Home/reprise et pause ; observer si les consignes restent compréhensibles.
- Relever pour chaque tâche : réussite autonome, temps indicatif, erreurs, mauvais appuis, hésitations, demandes d'aide et verbatims. Demander ensuite une appréciation libre du style visuel et de l'envie de rejouer, sans suggérer les réponses.
- Ajouter une observation à une main et sur luminosité extérieure si possible. Ne pas considérer les résultats de l'émulateur comme des mesures thermiques ou de confort physique.

### Critères de sortie proposés

- **Bloquant** : impossibilité de finir une tournée en raison d'un problème de contrôle, perte de progression ou interaction critique inaccessible.
- **GO pour une itération de contenu limitée** : au moins 4 personnes sur 5 comprennent sans aide le but et différencient les rôles, aucune anomalie bloquante, et aucun défaut majeur récurrent de rotation/réception sur les appareils testés. Ce seuil sert uniquement au triage produit précoce.
- **REWORK ciblé** : incompréhension récurrente d'un rôle, geste difficile, consigne ambiguë ou problème de lisibilité ; corriger sur le même niveau, puis réévaluer.
- **HOLD** : si l'exécution sur un vrai téléphone ou le test indépendant ne peuvent pas être réalisés.

Un GO de cette session ne vaudra ni validation commerciale, ni autorisation de publication, ni vérification iOS.

## Instruction de suite à Codex

Ne pas coder de nouveaux niveaux pour l'instant. Conserver le commit `108e2b04` et la branche de finition comme références locales. Préparer **uniquement** le protocole et un modèle de fiche d'observation à partir des critères ci-dessus, puis faciliter une installation debug sur appareil Android physique (sans signature ou publication commerciale). Attendre les retours constatés avant de retoucher l'identité visuelle, le HUD ou les mécaniques. Les anomalies doivent être rattachées à des preuves et priorisées, puis les suites Godot/Android doivent être rejouées après correction.
