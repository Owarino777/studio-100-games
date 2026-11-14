# Intégrité de la tranche — revue indépendante

Revue en lecture seule du **14 novembre 2026**, sur la branche `feat/archipel-postal-vertical-slice`. Référence de préservation : commit `68548a4` (fondation et préproduction validées avant la tranche). Aucun runtime, APK, réglage d'émulateur ou clé n'a été modifié par cette revue ; seul ce rapport est créé. Aucun commit ou push n'est effectué par l'auditeur.

## Paquet réellement testé

| Champ | Résultat observé |
|---|---|
| Fichier local | `build/android/switchworks-archipel-slice-debug.apk` |
| Taille | **61 432 091 octets** |
| SHA256 | `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1` |
| Package | `org.studio100games.switchworks.archipel.slice` |
| Version | `versionName=0.1.0`, `versionCode=2` |
| SDK | Minimum **24**, cible/compilation **36** |
| Architectures | `arm64-v8a`, `x86_64` |
| Signature | `apksigner verify --verbose` : code 0, **v2 et v3 valides**, un signataire |
| Nature debug | Manifeste `application-debuggable` ; sujet du certificat public selon la convention Godot, et non une preuve de signature release |
| Permissions listées par badging | **Aucune ligne `uses-permission`** dans le badging observé |
| Alignement | `zipalign -c -P 16 4` : code 0 ; ne certifie pas seul tous les segments ELF |
| Archive APK | `zipfile.testzip()` ne retourne aucun membre corrompu |

Les schémas v1/v3.1/v4 et SourceStamp ne sont pas annoncés comme vérifiés. Les outils lisent le certificat public embarqué ; aucune clé privée ni valeur de mot de passe n'a été affichée ou consultée par cette revue. Le fichier correspond à l'empreinte du passage Android réel de 67/67 contrôles.

## Contenu embarqué et licences

Inspection de **46 entrées d'assets** dans l'APK :

- `data/archipel_double_flux.json` est présent et ses octets correspondent au fichier source testé.
- `assets/fonts/OFL-NunitoSans.txt`, `assets/licenses/GODOT_LICENSE.txt` et `assets/licenses/GODOT_COPYRIGHT.txt` sont présents **octet pour octet**.
- La fonte n'est pas stockée comme un TTF brut : le fichier `.ttf.import` pointe vers une ressource `.fontdata` de **301 679 octets**, bien présente. C'est le mécanisme d'import de Godot, pas une police manquante. Le TTF local correspond au hash de blob enregistré dans `assets/fonts/SOURCE.json`.
- Les remaps importés de la fonte, des PNG papier/porcelaine/ciel et du SVG de fibres de papier pointent tous vers des ressources effectivement présentes dans l'APK.
- Aucun chemin de tests, QA, `art_showcase`, `check_art_family`, runner de tests ou outil Python/PowerShell de recette n'est présent dans le paquet.
- Aucun nom de keystore, `export_credentials`, clé privée ou fichier `.env` n'est présent parmi les entrées du paquet.

Les empreintes et tailles des cinq textures sources correspondent au manifeste. Les notices Godot correspondent aussi aux SHA256 de leur registre de provenance local. Les champs d'import des quatre textures utilisées ont été rapprochés des preuves d'import/packaging ; cette mise à jour documentaire ne change pas l'APK.

Cette revue constate présence, intégrité et provenance déclarée des fichiers. Elle n'accorde pas une certification juridique : les conditions du fournisseur des textures générées et les droits commerciaux restent à revoir avant une publication. La fonte OFL et les notices du moteur ne donnent pas une licence globale aux autres contenus du jeu.

## Préservation et exclusions

Comparaison Git contre `68548a4` : **aucune modification** des scripts/scène/tests/icône d'origine de la mire, des outils de racine, de `platform/`, `shared/`, `.agents/` ou `skills-lock.json`. Les nouveaux tests et la nouvelle scène sont des ajouts séparés.

Les quatre sections des **deux premiers presets** (`preset.0`, `preset.0.options`, `preset.1`, `preset.1.options`) gardent leurs mêmes clés et valeurs. `run/main_scene` reste `res://scenes/verification.tscn`. Le nouveau `run/main_scene.archipel_slice` sélectionne la tranche uniquement avec sa feature d'export dédiée. Le preset `Android Archipel Slice` utilise `archipel_slice` et inclut explicitement les données JSON et notices ; ses exclusions de tests/QA/docs/artefacts ont été recoupées avec le ZIP réel.

Neuf cas Git ont été vérifiés : outils locaux/keystore, credentials `.godot`, APK, artefacts et cache Python exclus ; fonte, OFL, JSON du niveau et runner source versionnables. Les caches, dépendances de poste, sorties de build et clés ne deviennent pas des sources implicites du jeu.

## Contrôles statiques et secrets

Le premier snapshot de scan comporte **440 fichiers candidats** (suivis et nouveaux, à cet instant, avant la clôture des derniers documents). Aucun motif de secret, fichier sensible candidat ou chemin absolu de poste dans les nouveaux fichiers runtime n'a été détecté. Le scan inclut les logs de preuve déjà copiés et ne se limite pas aux scripts ; les textes de documentation peuvent légitimement décrire l'environnement de la machine.

Les motifs contrôlés comprennent clés privées, tokens usuels, URL avec identifiants et affectations littérales de secrets. Aucune valeur potentiellement sensible n'est imprimée. Un scan par motifs ne démontre pas une absence exhaustive de secrets. Les ajouts documentaires ou preuves postérieurs au snapshot doivent rester soumis au scan de clôture du responsable de livraison.

Un passage complémentaire couvre les **59 fichiers** alors présents sous `docs/vertical-slice/`, preuves et logs compris, après ajout des essais Android de proportions : aucun motif détecté. Les preuves de packaging encore à produire ne sont pas prétendues couvertes par ce snapshot.

`check_godot_project.py games/001-switchworks` : **0 erreur, 0 avertissement dans 106 fichiers contrôlés**. L'analyse AST des trois outils Python (`package_slice_sources.py`, `verify_android_slice.py`, `verify_android_layouts.py`) passe ; le parseur PowerShell ne relève aucune erreur dans `tools/Slice.ps1`. La compilation globale et le contrôle géométrique final sont exécutés séparément par le responsable de recette ; ils ne sont pas remplacés par ce contrôle de chemins.

## Commandes et limites

Commandes réellement exécutées, avec les outils déjà installés :

```text
apksigner.bat verify --verbose [--print-certs] <APK>
aapt.exe dump badging <APK>
zipalign.exe -c -P 16 4 <APK>
python .agents/skills/godot-nodes-scenes/scripts/check_godot_project.py games/001-switchworks
git diff 68548a4 --name-only -- <chemins protégés>
git check-ignore --no-index -q <cas d'exclusion>
```

Des scripts Python de lecture ont aussi comparé les sections ConfigFile, les octets ZIP/source, les remaps d'import, les empreintes et les motifs de secret. Les sorties détaillées de scan sont conservées sous `artifacts/slice-tests/final-integrity-scan.json`, ignorées par Git. Les chemins SDK sont découverts depuis le SDK existant du poste ; aucun outil n'est réinstallé.

Le statut Git est celui d'une revue **avant commit de livraison**, pas une attestation de dépôt propre final. Aucun test iOS, physique, juridique ou de sécurité exhaustive n'est déduit de ces résultats. SWITCHWORKS reste **TEST / HOLD** ; le paquet est expérimental et debug.

`git fsck --full` retourne le code 0 et signale le blob non référencé `2bbf7d9259ee93c24ff0b16a495779c34511429a` (39 647 octets). Le contrôle supplémentaire de ses motifs de secret ne détecte aucun résultat ; son contenu n'est pas affiché. Un objet non référencé n'est pas une corruption : aucun prune, nettoyage ou réécriture d'historique n'est effectué.
