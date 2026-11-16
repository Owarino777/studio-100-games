# ADR 0003 — Étude littorale modulaire, une composition avant généralisation

Date : 16 novembre 2026. Statut : **retenu pour l'expérimentation autorisée ; direction artistique à valider par le propriétaire**.

## Contexte

La tranche de référence fonctionne mais son propriétaire juge insuffisants matières, relief, rails/bâtiments et interface. Les deux nouvelles planches définissent une intention plus concrète, avec des géométries de rails et des échelles parfois incompatibles avec le niveau 6×6. SWITCHWORKS reste TEST / HOLD ; aucun niveau, achat ou refonte complète n'est autorisé par cette étude.

## Décision

- Isoler `experiments/littoral/composition.tscn` sur une branche locale depuis `af5cc28`, sans modifier `main` ni la branche de finition `108e2b04`.
- Garder le modèle déterministe, le fichier du niveau, les scènes et suites de référence. Le contrôleur ne reçoit qu'une fabrique `_create_board_view` dont le retour par défaut reste PostalBoardView ; la scène expérimentale substitue une sous-classe de vue, pas un autre moteur.
- Construire trois familles de modèles éditables dans Godot et leurs supports, avec sources TSCN et GLB relus. Pas de Blender installé/retouché, pas de faux fichier `.blend`, pas d'image conceptuelle servant de fond de gameplay.
- Utiliser une caméra orthographique plus oblique et limiter l'empreinte des stations à leur case ; les entrées/sorties du rail et les lettres/formes A/B priment sur la composition illustrée.
- Conserver les animations existantes et les brancher sur les groupes articulés des nouveaux modèles. Sauvegarde d'étude séparée `littoral_composition_v1.json` et paquet Android séparé, pour préserver la référence.
- Réduire les appels de dessin mesurés en instanciant les 36 dalles par surface et en regroupant le décor statique ; ne pas modifier la simulation ou la densité du puzzle pour gagner des FPS.

## Alternatives et conséquences

Des sprites pré-rendus pourraient gagner en richesse picturale mais exigeraient des orientations et ombres cohérentes ainsi qu'une famille d'états complète. Copier les planches ne résoudrait ni les ports, ni la modularité. Installer un DCC libre reste envisageable ultérieurement ; il n'est pas nécessaire pour rendre ces sources modifiables et vérifiables aujourd'hui.

Le pipeline natif donne un relief et des pivots contrôlables, mais ne reproduit pas toute la richesse des illustrations. L'éclairage LDR Compatibility exige de garder de la marge dans les matières claires ; aucun effet Forward+ non disponible sur Web n'est requis. Les mesures de PC/émulateur ne prédisent pas l'iPhone, la mémoire GPU, la chauffe ou le confort tactile.

Les preuves et le verdict expert sont dans [le dossier d'étude](../art/switchworks/littoral-study-2026-11-16/REPORT.md). Elles autorisent une revue de composition, pas une acceptation artistique automatique, une extension de contenu ou une publication. Le propriétaire choisit la suite après inspection du vrai rendu.
