# Archipel Postal — composition littorale exécutée

16 novembre 2026. Étude isolée, **un seul niveau existant**, pas refonte généralisée. Budget additionnel : 0 €. Aucun push, store ou nouvel hébergement externe.

- [Art bible courte et critique des références](ART_BIBLE.md).
- [Recette contradictoire, preuves et limites](REPORT.md).
- [Sources modifiables des modèles](../../../../games/001-switchworks/assets/littoral-study/sources/).
- [Neuf exports GLB](../../../../games/001-switchworks/assets/littoral-study/models/) et [provenance/licences](../../../../games/001-switchworks/assets/littoral-study/PROVENANCE.md).
- [Scène jouable](../../../../games/001-switchworks/experiments/littoral/composition.tscn) et [scène des modules](../../../../games/001-switchworks/experiments/littoral/module_sheet.tscn).
- [Décision technique et compromis](../../../decisions/0003-etude-littorale-modulaire.md).

Depuis la racine du studio, avec les outils déjà installés :

```powershell
./games/001-switchworks/tools/ArtStudy.ps1 -Action Run
./games/001-switchworks/tools/ArtStudy.ps1 -Action Modules
./games/001-switchworks/tools/ArtStudy.ps1 -Action Capture -Resolution 360x640 -Scenario planning
./games/001-switchworks/tools/ArtStudy.ps1 -Action Video
./games/001-switchworks/tools/ArtStudy.ps1 -Action Test
python games/001-switchworks/tools/validate_littoral_models.py
./games/001-switchworks/tools/ArtStudy.ps1 -Action ExportAndroid
```

Chaque exécution produit un dossier daté sous `games/001-switchworks/artifacts/art-study-2026-11-16/`, sans remplacer les rapports précédents. L'APK d'étude est `games/001-switchworks/build/android/switchworks-littoral-study-debug.apk`, paquet distinct `org.studio100games.switchworks.littoral.study`. Le preset de finition, son APK et sa sauvegarde ne sont pas remplacés.

Pour `Video`, Movie Maker utilise la taille configurée du projet **450×800** : l'outil aligne explicitement la fenêtre sur cette taille pour éviter un recadrage. `Resolution` sert à Run/Capture ; les PNG avant/après sont bien contrôlés séparément aux deux formats demandés.

## Modifier une pièce

Ouvrir un des fichiers `assets/littoral-study/sources/*.tscn` dans Godot. Les meshes, transformations, matières, glyphes et groupes articulés sont inspectables ; le clapet garde le pivot `ReceptionLid`, le sceau `ReceiptSeal`, les ports les noms `Port1/2/4/8`. Les noms et pivots font partie du contrat de l'animation et de la grille.

Après édition manuelle de ces sources, réexporter avec **`ArtStudy.ps1 -Action BuildAssets -ReuseSources`**. Cela conserve les TSCN édités et régénère les GLB. Sans `-ReuseSources`, BuildAssets régénère les neuf sources à partir de `experiments/littoral/littoral_models.gd` : réserver ce mode aux changements volontaires du générateur. Les réglages communs sont dans `mat`, `station`, `rail`, `tile`, `parcel` et `roof_patch`. La normalisation géométrique et le regroupement statique sont explicites, pas une conversion opaque.

Relancer le validateur, les tests, puis une capture réelle après toute modification. Les marqueurs de port seuls ne suffisent pas : le validateur vérifie aussi les intersections des meshes de rails avec les bords de case. Les `.glb.import` sont conservés pour le comportement d'import Godot. Les sources GLB sont sans images externes ni police embarquée ; les lettres A/B sont des traits géométriques originaux. Nunito Sans reste la vraie police du HUD.

Blender n'a pas été retenu ; aucun `.blend` fictif n'est livré. Les GLB permettent un échange vers un DCC ultérieur, sans imposer son installation. Les planches fournies restent des concepts, jamais des textures du jeu.

## Rejouer la recette Android

```powershell
./tools/Start-StudioEmulator.ps1 -Action Start -Gpu host
./games/001-switchworks/tools/ArtStudy.ps1 -Action ExportAndroid
python games/001-switchworks/tools/verify_littoral_android.py
```

Le script vérifie l'identité de l'AVD `Studio_API_36`, le serveur ADB dédié `5041`, le paquet d'étude, puis effectue ses entrées tactiles. Il restaure la résolution précédente de cet AVD en sortie ; pas de `clear`, désinstallation ou suppression de données. La première série est filmée par `screenrecord`. Ce sont des preuves **émulateur**, pas téléphone physique, Safari ou validation par cinq joueurs. Ne pas installer silencieusement un autre émulateur ou un SDK manquant.

Les tests humains des références `108e2b04` / `af5cc28` ne sont pas requalifiés en tests de cette nouvelle scène. L'approbation de la direction par le propriétaire reste nécessaire avant toute généralisation. SWITCHWORKS demeure TEST / HOLD commercial.
