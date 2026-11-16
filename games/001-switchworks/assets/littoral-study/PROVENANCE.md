# Provenance des composants de l'étude littorale

16 novembre 2026, version expérimentale 0.1. **Pas d'acceptation commerciale ou artistique finale.** Inventaire détaillé et empreintes : [asset-manifest.json](asset-manifest.json). Exports : [model-exports.json](model-exports.json).

## Modèles originaux et matériaux

Neuf modèles : guichets A/B, boîtes A/B, voie droite/coude, tuile et colis A/B. Géométrie originale rédigée pour le studio avec assistance Codex, sans achat, modèle tiers, génération d'image payante ou extraction de pixels des planches. Création interne au projet ; aucune licence open source ni cession à des tiers n'est accordée par ce document. L'exploitation commerciale du projet reste une décision du propriétaire et nécessite sa revue de droits générale.

Outil réellement exécuté : Godot **4.7.2.stable.official.ed1daf0bf Standard**. Source paramétrique : `experiments/littoral/littoral_models.gd`. Sources natives éditables : `sources/*.tscn` ; modèles d'échange : `models/*.glb`. Les primitives et fonctions de base réutilisent `scripts/visuals/postal_art_factory.gd`, déjà original au studio. Les normales et le sens des faces sont normalisés **avant la sauvegarde des sources** ; les triangles dégénérés sont retirés. Les GLB regroupent les éléments statiques par matière en préservant les groupes animés et les ports. Aucune texture n'est nécessaire aux nouveaux modèles ; leurs six familles de matières sont des paramètres PBR modifiables.

Tous les exports sont relus par GLTFDocument puis inspectés indépendamment en Python : structure, buffers, normales, triangles, dépendances et sorties physiques des rails. Ce contrôle ne constitue pas une certification complète Khronos ni une preuve d'absence de défaut. Les fonds de tube aux raccords sont volontairement ouverts pour s'assembler sans bouchon visible ; les petites pièces sont des solides distincts, pas un objet de fabrication industriel.

## Ressources existantes réutilisées

| Ressource | Conditions et usage |
|---|---|
| Nunito Sans | SIL OFL 1.1 ; `assets/fonts/OFL-NunitoSans.txt` et `SOURCE.json` existants. Police inchangée dans le HUD ; aucune fonte tierce ajoutée |
| Fond `assets/archipel/textures/sky-paper-v1.png` | Création générée pour le projet le 14 novembre, conditions fournisseur et revue de droits commerciale encore à confirmer, comme indiqué dans le manifeste existant. Réutilisé sans retouche ; pas une planche du 16 novembre |
| Fleur périphérique, primitives, thème et contrôleur | Sources originales existantes du studio ; réutilisées en code. Aucun pack sous licence tierce ajouté |
| Godot | Licence MIT, notice déjà conservée dans `assets/licenses/GODOT_LICENSE.txt`. Version et modèles existants réutilisés |

Les lettres A/B des modèles sont des tracés géométriques originaux. Un premier essai avec TextMesh/Nunito a échoué sur des contours de la fonte variable ; il n'est pas le modèle livré. Les textes du HUD restent de véritables contrôles et une vraie police OFL.

## Références conceptuelles

`docs/art/switchworks/references-2026-11-16/01-univers-et-intention.png` et `02-assets-etats-interface.png` ont été fournies comme illustrations originales générées. Le générateur exact et ses conditions détaillées ne sont pas fournis. Elles restent des références internes ; **aucun de leurs pixels n'est exporté dans le jeu**. Leur présence locale ne vaut pas preuve de licence de redistribution commerciale. Les empreintes des originaux sont conservées dans le manifeste de l'étude.

Les jeux concurrents du dossier de conventions servent uniquement à comparer lisibilité, hiérarchie et feedback ; aucun asset, logo, personnage, texture ou composition distinctive n'est réutilisé.

## Outillage et coût

Godot, Python, Pillow et le FFmpeg déjà présents sont utilisés localement ; aucun nouvel achat, abonnement, appel à une API de génération d'image ou service payant. Pillow/FFmpeg sont des outils de contrôle/encodage, pas des dépendances livrées dans le jeu. Aucun certificat, mot de passe, keystore, APK ou exécutable d'outillage n'est ajouté au répertoire des sources de modèles. Les exports ne contiennent pas de source externe par URL.
