# Comptoir maritime — provenance et conditions

Création des 16–17 novembre 2026, version expérimentale `0.0.1-postal-ui`. [Inventaire et empreintes](asset-manifest.json). Pas d'approbation artistique finale ou de licence commerciale accordée à des tiers par cette note.

## Géométrie et matières

Dix modèles originaux assistés par Codex : guichets A/B, boîtes A/B, voie droite/coude, tuile, colis A/B et socle. Sources GDScript et **TSCN éditables**, GLB réellement exportés et relus avec **Godot 4.7.2.stable.official.ed1daf0bf Standard**. Le générateur est `experiments/postal_workshop/workshop_models.gd`, l'exporteur réutilise les fonctions vérifiées de l'étude précédente ; aucun ancien asset n'est écrasé.

Les primitives/biseaux et glyphes géométriques A/B réutilisent des helpers originaux du studio. Les formes et assemblages nouveaux sont définis dans le code, pas extraits du PDF ni d'une planche. Le grain 256×256 est calculé localement, source déterministe dans `grain()` ; ce PNG n'est ni une texture tierce ni un appel à un générateur payant.

Les sources sont normalisées avant sauvegarde : sens des faces, normales, triangles dégénérés. Les GLB regroupent les meshes statiques par matière tout en conservant les pivots articulés et les ports. Les tubes ouverts aux raccords s'assemblent ; il ne s'agit pas de modèles pour fabrication industrielle. Le validateur indépendant contrôle structure, buffers, dépendances embarquées, géométrie et sorties réelles des rails ; pas de certification Khronos complète prétendue.

Les matériaux PBR sont éditables : céramique satinée, métal peint, ferrure mate, kraft/toile, bois rare. La marge des couleurs claires est ajustée pour le rendu LDR Compatibility ; leur apparence n'est pas déduite d'un nom « premium ». Les dalles statiques sont instanciées, avec de faibles variations. Leurs projections d'ombre sont désactivées pour éviter l'acné sur petits formats ; les ombres des objets restent actives.

## Interface et références

Thème Godot `.tres`, tokens `.tres`, HUD `.tscn`, état de présentation GDScript et quatre icônes SVG originales (Annuler, Indice, Expédier, Rejouer), même grille 24 unités/trait 2. Le shader de niveaux de gris est un outil QA, pas une altération des preuves couleur ni un effet de gameplay.

Le PDF utilisateur du 16 novembre et les planches antérieures sont des **sources internes de conception**. Aucun de leurs pixels n'est intégré dans les nouveaux modèles ou le HUD. Leurs conditions de redistribution ne sont pas inventées. Les conventions de jeux commerciaux sont étudiées sans copie de personnage, logo, texture, identité ou composition distinctive.

Nunito Sans : fichier existant inchangé, **SIL OFL 1.1**, notice `assets/fonts/OFL-NunitoSans.txt` et provenance `assets/fonts/SOURCE.json`. Godot : **MIT**, notice `assets/licenses/GODOT_LICENSE.txt`. Les classes héritées du projet conservent certaines ressources chargées historiquement ; aucune nouvelle ressource générée payante n'est ajoutée, et le ciel ancien n'est plus un élément de cette interface.

Conditions des nouvelles ressources : création interne du studio, assistée par IA en code ; aucun pack, modèle ou composant commercial tiers acquis. Pas de licence open source générale ou de garantie juridique d'originalité commerciale donnée ici. Le propriétaire conserve sa revue de droits avant toute commercialisation.

## Budget et outillage

**0 € de dépense additionnelle ; aucun crédit/API d'image consommé.** Godot, Python, Pillow, Playwright, Chrome, outils Android et FFmpeg déjà installés sont réutilisés. Ils ne sont pas embarqués comme binaires de redistribution avec les modèles. Pas de Blender, Krita, ComfyUI ou MCP installé pour feindre un pipeline DCC. Sources, formats et limites sont explicites.
