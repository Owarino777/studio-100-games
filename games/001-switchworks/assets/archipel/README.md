# Archipel Postal — famille d'assets de la tranche expérimentale

Direction B retenue provisoirement le 14 novembre 2026. Ces objets sont des ressources **natives 3D réellement construites dans Godot** ; aucun poster conceptuel ne remplace le plateau ou le HUD.

## Construction et repères

`scripts/visuals/postal_art_factory.gd` fournit `PostalArtFactory` :

- `create_tile()` : tuile de porcelaine à bords arrondis/biseautés, emprise 0,972 × 0,972, dessus à Y = 0,12.
- `create_rail(ports, color)` : droite/coude à deux profilés, traverses fusionnées par matériau. Bits N=1, E=2, S=4, W=8 ; unité de case 1. Les extrémités sont sur les frontières de cellule à ±0,5. La convention monde est +X est, -Z nord.
- `create_station(label, is_source, color)` : pavillon bas, toit plié, porche, port physique est pour une source et ouest pour une réception. Les signes A/cercle et B/triangle sont de vraies géométries identiques à ceux des colis.
- Chaque station porte une seule enseigne inclinée à 45° vers la caméra, sans badge de sol redondant. Les colis gardent leur propre sceau, sur un petit support kraft de même matière que la boîte plutôt qu'une grande plaque blanche.
- `create_parcel(label, color)` : carton avec épaisseur, rabat, bandes et sceau ; base locale Y=0. Placer le carton devant le porche (source : X+0,30, réception : X-0,30), à environ Y=0,20, pour éviter l'occlusion par le toit.
- `create_island()`, `create_flower()`, `create_cloud()` : socle porcelaine, fleurs en périphérie et décor facultatif. Aucun objet décoratif n'encode une route ou une commande.
- `create_selection(color)` : cadre de sélection en huit équerres fusionnées dans un seul mesh, contraste encre par défaut ; à placer sur la case choisie. Les états erronés gardent aussi un message textuel dans le HUD.
- `configure_font(font)` : permet d'utiliser la vraie fonte embarquée pour les petits labels 3D. Les lettres ne sont pas peintes dans les textures.

Le constructeur partage ses meshes et matériaux. Un rail utilise deux instances de mesh : profilés et traverses ; les traverses ne sont pas autant de draw calls séparés. Il n'emploie ni GI, ni bloom, ni effet requis hors renderer Compatibility. L'éclairage et les états interactifs relèvent de la scène de jeu.

## Matières et provenance

| Ressource | Origine | Conditions / usage |
|---|---|---|
| Meshes biseautés, tubes, toits, badges et décor | Code original écrit pour cette tranche, sans téléchargement de modèle concurrent | Sources et paramètres dans `PostalArtFactory` ; pas de licence tierce de modèle ajoutée |
| `textures/porcelain-albedo-v1.png` | Génération intégrée `image_gen`, prompt dans `GENERATED_PROMPTS.md` | Texture albedo uniquement sur la vraie géométrie ; usage soumis aux conditions du fournisseur, droits commerciaux à revoir avant publication |
| `textures/paper-albedo-v1.png` | Génération intégrée `image_gen`, même registre | Idem ; pas de plis, ombres ou interface peints pour simuler une fonction |
| `textures/sky-paper-v1.png` | Génération intégrée `image_gen` | Décor de fond composé par la scène, pas plateau ; mêmes conditions |
| `textures/porcelain_micro.svg` | Motif déterministe original, graine 17 | Étude/fallback conservée, pas utilisée par les matériaux PNG de porcelaine |
| `textures/paper_fibres.svg` | Motif déterministe original, graine 17 | Grain de papier blanc pour les toits colorés, afin de conserver leur teinte ; les corps et colis utilisent le PNG de papier chaud |
| Fonte Nunito Sans | Source OFL embarquée par le projet sous `assets/fonts/` | Conserver le fichier OFL et son registre de provenance ; la licence des textures n'est pas attribuée à la fonte |

Les matériaux sont `StandardMaterial3D` : porcelaine à rugosité modérée, papier mat, émail lisible. Une marge de luminance est réservée aux surfaces pâles pour le renderer Compatibility. Les images générées sont opaques : aucune fausse transparence n'est utilisée. Le `asset-manifest.json` consigne dimensions, empreintes et contrôles techniques ; ce n'est pas une certification artistique ou commerciale.

## Vérification de famille

La scène `assets/archipel/qa/art_showcase.tscn` permet une inspection indépendante de la famille. Elle n'implémente pas le gameplay et ne constitue pas une preuve de réception tactile. Exemple depuis la racine du dépôt, avec l'environnement local du studio :

```powershell
$env:APPDATA = Join-Path (Get-Location) 'tools/.local/godot/4.7.2/editor_data/runtime-user'
& ./tools/.local/godot/4.7.2/Godot_v4.7.2-stable_win64_console.exe --path games/001-switchworks res://assets/archipel/qa/art_showcase.tscn
```

Import, compilation de la fabrique et smoke de cette scène ont été exécutés sans erreur. Les captures de travail sont sous `artifacts/art-factory/`, ignorées par Git. L'acceptation de la tranche repose sur les captures du jeu complet, y compris Android, et non sur cette seule planche de famille. Une caméra orthographique portrait doit préserver la largeur (`KEEP_WIDTH`) ; les lumières doivent être calibrées sur le vrai rendu pour ne pas écrêter la porcelaine.

Le contrôle `--headless --script res://assets/archipel/qa/check_art_family.gd` vérifie géométrie finie, normales, emprise des six masques de rails et cohérence des badges. Les triangles comptés par ce runner sont ceux des meshes custom inspectés, pas une mesure de performance du plateau. Les dimensions sources des textures et leur limite d'import 1024 sont conservées séparément ; les PNG d'origine ne sont pas redimensionnés ou écrasés.
