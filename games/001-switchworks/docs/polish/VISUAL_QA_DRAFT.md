# Archipel Postal — contrôle visuel intermédiaire indépendant

14 novembre 2026. **Candidat examiné : `candidate-03.png`, Windows 390×844, préparation.** Ce rapport est provisoire : il ne porte pas sur l'APK final, les autres états, les trois ratios Android, les animations ou le téléphone physique. Le relecteur est un agent distinct des auteurs des correctifs, avec contexte partagé ; aucun avis humain ou résultat joueur n'est prétendu.

## Preuves ouvertes et méthode

Les deux documents utilisateurs [REVUE_CRITIQUE](../revue-critique-ia-2026-11-14/REVUE_CRITIQUE.md) et [PROMPT_CODEX](../revue-critique-ia-2026-11-14/PROMPT_CODEX.md), ainsi que les skills `studio-art-direction` et `studio-visual-qa`, ont été lus intégralement.

Trois images ont été réellement ouvertes avec `view_image` :

- [Concept B v3](../../../../docs/art/switchworks/concepts/b-archipel-postal-v3.png), illustration non implémentée.
- [Avant natif Windows 390×844](../vertical-slice/evidence/desktop/desktop-390x844-planning.png), référence de la tranche avant correction.
- [Candidat 03](evidence/candidates/candidate-03.png), vrai framebuffer Godot du travail en cours.

La comparaison porte sur le même format et l'état de préparation. Les compteurs sont initiaux dans les deux rendus natifs. Aucun concept n'est substitué à une capture du jeu. Le contrôle n'a modifié aucun pixel, asset ou code. Les paramètres d'éclairage annoncés par le responsable ne sont pas une mesure de pénombre ou de performance par ce rapport.

## Améliorations réellement visibles

| Domaine | Avant → candidat 03 | Conclusion limitée à l'image |
|---|---|---|
| Ombres | Masses noires crénelées derrière pavillons/fleurs → ombres beaucoup moins présentes et moins distrayantes | **Amélioration forte et visible**, pas une simple différence de compteurs de tests. La douceur à résolution Android reste à vérifier. |
| Rails | Petites traverses blanches très répétées → appuis plus rares et discrets, courbes plus continues | **Amélioration nette de la hiérarchie du parcours.** Les deux routes restent suivables. |
| Rôles | Deux pavillons presque jumeaux → guichet à gauche et petite boîte à enveloppe à droite | **Différenciation désormais perceptible.** Le nouveau joueur doit encore nommer les rôles sans aide ; l'icône ne suffit pas à prouver la compréhension humaine en trois secondes. |
| Objectif / marque | Gros SWITCHWORKS et grands compteurs → titre de famille, petit nom de jeu, objectif « Livrez A → A et B → B », compteurs compacts | **Meilleure priorité de la tâche.** Le but explicite est immédiatement accessible à l'inspection. |
| Consignes | Aide sous le plateau plus pied redondant → une aide au-dessus du plateau, plus d'aide collée sous les actions | **Amélioration de la composition et de la marge basse.** Les autres phases ne sont pas montrées par ce PNG. |
| Famille | Les mêmes tons ciel/crème/bleu/corail sont conservés | La passe conserve Archipel Postal ; elle ne remplace pas globalement l'identité. |

Ces gains justifient de poursuivre la recette du correctif. Ils ne justifient pas de qualifier toute la facture graphique de finie.

## Réserves à traiter ou à arbitrer avant le verdict final

### VQ-P01 — Majeur artistique : matière encore trop peu incarnée

**Observation :** dans `candidate-03.png`, les grandes faces de tuiles restent presque uniformes, crème clair, avec un petit contour beige. Le biseau apporte une séparation, mais la glaçure, la douceur du volume et la différence de matière avec le papier restent discrètes à cette échelle. Les surfaces de toiture et de corps des objets sont encore très simples. Le concept montre une porcelaine et des plis nettement plus perceptibles ; la comparaison n'exige pas sa reproduction pixel à pixel.

**Zones de lecture :** la rangée vide supérieure du plateau et les cases vides centrales, puis le toit bleu de gauche et le corps clair du réceptacle droit. Observer sans agrandir artificiellement la capture : le détail qui n'existe qu'en zoom ne résout pas le problème mobile.

**Correction ciblée prioritaire proposée :** reprendre une seule tuile, un toit et un colis comme référence. Renforcer un bord céramique et un reflet large/sobre ou une modulation de volume qui se lit à taille réelle ; garder le papier plus mat et ses plis lisibles. Ne pas ajouter du bruit sur toutes les cases ou des reflets qui masquent les ports. Répéter cette référence seulement après inspection native.

**Acceptation encore ouverte :** porcelaine/papier/kraft distinguables à taille de téléphone, sans explication préalable des matières, avec routes toujours prioritaires. L'amélioration esthétique doit se constater dans le prochain framebuffer, pas seulement dans une valeur de roughness ou un test géométrique.

### VQ-P02 — Réserve de composition : espace libéré encore peu réaffecté

Le HUD est plus léger, mais les grandes plages de ciel demeurent : entre statistiques, aide et plateau, puis entre plateau et commandes. Le plateau garde à peu près sa même emprise dans l'écran. À 390×844, son centre reste lisible et aucune impasse n'est démontrée ; il n'est donc pas justifié de transformer cette réserve en bloqueur.

Un ajustement de rythme vertical peut rapprocher aide/plateau et réduire le vide inférieur, sans écraser les actions de 48 unités ou modifier la caméra. Le but n'est pas d'occuper chaque pixel : il faut donner une intention aux respirations. Si la composition actuelle est conservée pour la tenue à une main ou la comparaison stricte, le documenter et la confronter aux ratios natifs.

### VQ-P03 — Contrôle indispensable restant : réception et états

Le réceptacle nouveau offre un support crédible à l'animation. Ce PNG ne permet pas de juger ouverture, entrée du colis, sceau, retour au repos, victoire ou mouvement réduit. La réception ne doit pas être déclarée corrigée sur ce seul visuel. L'aide contextuelle de trajet et la reprise prête doivent aussi être inspectées dans les captures réellement correspondantes.

## Avis provisoire

**GO pour terminer et comparer la recette Android ; HOLD pour l'acceptation artistique finale.** Les ombres, rails, rôles et la hiérarchie ont réellement progressé. La réserve de matière VQ-P01 reste majeure dans ce candidat ; un export techniquement propre ne la ferme pas. VQ-P02 est un arbitrage de composition, VQ-P03 une preuve encore absente dans ce sous-contrôle.

À titre de repères experts non agrégés : lecture des parcours **3/4**, hiérarchie **3/4**, ombres dans ce PNG **3/4 provisoire**, distinction des rôles **3/4 provisoire**, incarnation des matières **2/4**, identité/finition complète **non acceptées**, animation/tactile/Android physique **NT**. Aucun total et aucune validation commerciale ne sont calculés.

Ce document reste une trace du candidat 03. Il ne doit pas être réécrit comme s'il avait examiné les corrections ou captures ultérieures.


Note de conservation : seuls les liens de copie des preuves ont ?t? r?adress?s pour le checkout ; l'analyse historique est inchang?e. [Rapport original octet pour octet](evidence/reports-original/VISUAL_QA_DRAFT.md).
