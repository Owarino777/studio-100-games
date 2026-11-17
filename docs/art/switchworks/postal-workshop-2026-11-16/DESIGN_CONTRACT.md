# SWITCHWORKS — atelier postal littoral de précision

16 novembre 2026. Branche `feat/switchworks-postal-ui-ux`, base `2b53f3a`. Cahier des charges : PDF du 16 novembre, **16 pages entièrement lues et rendues**, SHA256 `8fe437351807bf980422c7d7d9bb89720c5582e891e8b9beccb3faa1d1caa8af`. Pages 11–15 : instruction de production ; pages 2–10 : critères de conception ; page 16 : corpus et limites. Aucune acceptation artistique humaine ou commerciale n'est présumée.

## Audit et traçabilité initiale

Le PDF décrit sept captures, mais contient **six images uniques intégrées** (réutilisées sur les pages 1, 3 et 4). La deuxième rotation est citée page 16 sans image unique supplémentaire. La baseline du moteur est donc recréée pour les sept états, plutôt que d'inventer ce qui n'est pas intégré au PDF.

| Priorité / page | Constat ou risque | Vérification / décision |
|---|---|---|
| P0, p.2–3 | Bandeau sombre tronqué sur les voies | Reproduit par vrai survol après rotation : le texte correspond exactement à `PostalBoardView.tooltip_text`. Contrôle A/B avec cette seule propriété désactivée avant correction de sa source ; pas un état du solveur |
| P1, p.5–7,12 | Matières plates et silhouettes proches | Banc séparé de quatre familles, géométrie et matières originales, distinction guichet ouvert / boîte fermée ; comparaison Godot avant intégration |
| P1, p.6,13 | En-tête et cartes dominent, vides internes | Marque secondaire unique, objectif et progression groupés, plateau sans ciel ni cadre ornemental ; Container/anchors |
| P1, p.4,8,13 | Victoire avant réception et pause sur victoire | Résultat intégré, aucune grande modale de victoire ; un seul calque de pause, focus et reprise cohérents |
| P1, p.8,14 | États et retours causaux | État de présentation dérivé de la simulation existante ; raccord confirmé sans montrer une solution partielle ; arrivée/clapet/sceau réels |
| P1, p.9,14–15 | Régression, occlusion, troncature, tactile | Suites conservées + parcours et contrôles de géométrie d'UI sur tailles ciblées ; pt/dp distingués des unités Godot |
| P2, p.14 | Démarrage et poids Web | Mesures locales froid/chaud qualifiées, export distinct ; aucun résultat physique iPhone inventé |

Les données du niveau, ports, rotations, compteurs, ordre de simulation, undo et schéma de préparation sont intangibles. Le fichier de sauvegarde hérité de l'étude et son contrat sont conservés ; APK de recette séparé pour ne pas remplacer les références. Les anciens assets et scènes restent disponibles.

## Art bible opérationnelle

**Promesse :** un instrument postal miniature précis et accueillant, posé dans un atelier clair. Gameplay avant décor. Détails seulement là où ils expliquent l'usage.

- Sol céramique ivoire à variation de grain/rugosité très faible, joints fins, faible biseau ; pas de dalle jaune épaisse répétée, fleurs, ciel texturé dominant ou liserés dorés.
- Rails peints en encre pour A, cuivre sombre pour B ; double file et traverses régulières mais peu nombreuses. Droites/coudes à deux ports seulement : « jonction/aiguillage » du PDF ne crée pas de T/Y ni de nouvelle mécanique.
- Guichet d'expédition : structure ouverte, auvent bas, rampe vers l'est, flèche, colis présent. Boîte de réception : corps compact fermé, bouche/volet à l'ouest, enveloppe. Leur forme précède la couleur.
- A/cercle/bleu et B/triangle/terre cuite sur colis, station et réception. Lettres lisibles sur face orientée vers la caméra ; aucun logo généré.
- 1 unité = 1 case ; pivots centrés ; extrémités des rails sur les milieux des côtés. Corps de station nominal 0,86 case ; la casquette du guichet porte l'encombrement constructif à environ 0,93 case, sans franchir le bord de sa cellule ; seuls les embouts atteignent les milieux des côtés. Poignée de rotation locale hors des deux passages ; pas de levier suggérant une bifurcation.
- Lumière principale douce et unique, remplissage froid faible, ombre courte. Compatibility sans SSAO, bloom, effets Forward+ ou reflets temps réel obligatoires.

Palette sémantique de départ : fond atelier `#E8EBE6`, surface `#F5F3EA`, texte `#183B47`, secondaire `#52636A`, action primaire `#234F5D` avec texte ivoire, adresse A `#306C87`, B `#A9563F`, état confirmé `#3B7158`, erreur `#A63E32`. Les ratios de contraste seront calculés sur les tokens et confrontés au rendu, pas déduits des seuls noms de couleur.

Matières : céramique satinée roughness 0,50–0,64 / metallic 0 ; métal peint 0,32 / 0,12 ; ferrure mate 0,62 / 0,18 ; kraft/toile 0,90 / 0 ; bois rare 0,68 / 0. Pas de matières « luxe » ou de décor sans fonction. Grain original déterministe, source éditable, sans API d'image ni pixels du PDF.

Nunito Sans OFL existante. Deux niveaux : objectif 18–20, marque 12 ; aide 14–16 ; action 17–18 ; compteurs secondaires 12–13. Tokens d'espacement 4/8/12/16/24. Rayons sobres 8–12, un seul contour, focus encre net. Une famille d'icônes SVG originales, trait 2 unités et libellés lisibles.

## Composition et état de présentation

Content = header léger → objectif/progression → plateau pleine largeur sûre → feedback réservé → commandes. Les petits formats n'ont pas de bandeau flottant sur les voies. Le gris neutre du fond remplace le « tableau de bord sur ciel ». Le 6×6 reste entier et non déformé ; tout espace restant sur les écrans très hauts est mesuré et justifié, pas rempli par une décoration cachant le puzzle.

Préparation/rotation : sélection immédiate, quart de tour 160 ms, easing court, aucun déplacement caméra. Prêt : confirmation des raccords du circuit complet, jamais une solution donnée à un circuit incomplet. Transport : statut et commandes verrouillées explicitement. Réception : ouverture, entrée, confirmation (environ 380 ms de présentation), validation logique inchangée. Victoire : bilan discret après les réceptions, Rejouer disponible ; aucun grand panneau masquant les arrivées. Pause : seul calque modal actif, contexte terminé ou préparation, options/focus/restauration conservés. Mouvement réduit : états instantanés sans supprimer l'information.

## Porte de validation du banc

Avant le niveau complet : montrer une tuile, une voie rotative, départ/réception et un morceau de HUD exécutés ; comparer silhouettes, joints, matières, dimensions et interactions au rendu précédent. Captures brutes, géométrie relue, branche et sources identifiées. Si le gain visuel n'est pas clair, REWORK sur ce banc. Un GO technique/expert n'est pas une approbation artistique du propriétaire.

Références de conventions : étude existante Railbound (lecture du réseau), Mini Motorways (masses et espace négatif), inbento (objectif/problème/actions), sans reprise de leurs compositions ou identités. Aucun outil, modèle ou crédit payant ; aucune nouvelle publication sans autorisation.
