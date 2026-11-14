# Registre des ressources de la tranche

| Ressource | Origine et usage | Conditions / preuve |
|---|---|---|
| Géométries de porcelaine, voies, pavillons, colis, sélection | Création originale en GDScript, fabrique `scripts/visuals/postal_art_factory.gd` ; pivots et ports dans le [manifeste](archipel/asset-manifest.json) | Aucun modèle concurrent ou pack tiers copié ; code local du projet, sans licence publique ajoutée implicitement |
| Porcelaine, kraft et ciel papier PNG | Génération intégrée `image_gen` le 14 novembre 2026, sans image concurrente fournie | [Prompts et provenance](archipel/GENERATED_PROMPTS.md), originaux et SHA256 conservés ; conditions du fournisseur applicables, revue des droits commerciaux encore ouverte |
| Grain blanc du papier SVG, icône | Créations déterministes originales du projet | Aucun élément extrait d'une identité concurrente ; le SVG porcelaine antérieur est conservé comme étude |
| Nunito Sans variable | Fichier Google Fonts non modifié, renommé localement | SIL OFL 1.1 ; [source](fonts/SOURCE.json) et texte de licence embarqués ; aucune installation système |
| Sons discrets | Courtes ondes synthétisées dans `scripts/archipel/archipel_screen.gd` | Pas d'enregistrement, musique, voix ou banque tierce ; sons désactivés initialement, écoute humaine non réalisée |
| Moteur et composants tiers du moteur | Godot Standard 4.7.2 stable | [Notices officielles](licenses/README.md), incluses dans l'APK |

Les concepts du dossier artistique restent des références d'intention. Ils ne sont ni découpés en plateau jouable ni embarqués comme preuve de fonctionnalité. Le ciel seul est une image de décor ; les tuiles, rails, bâtiments, colis, textes et contrôles sont des objets natifs distincts.

La revue technique des ressources ne certifie pas une propriété intellectuelle ou une conformité commerciale exhaustive. Le projet reste **TEST / HOLD**.
