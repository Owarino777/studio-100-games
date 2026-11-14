# Archive locale des sources de la tranche

`package_slice_sources.py` requiert Python 3.10+ et Git, sans paquet Python externe. Il ne compile rien, n'effectue aucun commit et n'accède à aucun service distant. Il archive les **sources du monorepo**, y compris documentation, preuves sélectionnées, assets, licences et outils de préparation ; les binaires Godot et SDK doivent être réinstallés par les procédures du studio.

Attendre la fin des modifications et de la recette avant de créer le livrable final. Depuis la racine du studio :

```powershell
python games/001-switchworks/tools/package_slice_sources.py --help
python games/001-switchworks/tools/package_slice_sources.py --output games/001-switchworks/build/delivery/switchworks-archipel-sources.zip --dry-run
python games/001-switchworks/tools/package_slice_sources.py --output games/001-switchworks/build/delivery/switchworks-archipel-sources.zip
python games/001-switchworks/tools/package_slice_sources.py --verify games/001-switchworks/build/delivery/switchworks-archipel-sources.zip
```

Les chemins relatifs se rapportent à la racine du studio, même si le script est appelé depuis un autre répertoire. La création est limitée à cette racine et refuse un fichier existant. Choisir un nouveau nom pour un nouveau snapshot. En cas d'échec, le script retire uniquement l'archive qu'il vient de créer exclusivement, après vérification de son identité ; il ne supprime jamais une archive préexistante.

## Sélection et intégrité

- Inventaire par `git ls-files --cached --others --exclude-standard -z`, puis filtrage strict, y compris pour un fichier ignoré qui aurait déjà été suivi par Git.
- Exclusions supplémentaires permanentes : `.git`, `.local`, `.godot`, `build`, `artifacts`, `dist`, caches, imports locaux, clés/certificats, fichiers de credentials et paquets/exécutables générés. `.env.example` peut être inclus seulement si son contenu passe les contrôles.
- Refus des chemins absolus/traversées, collisions de casse, liens symboliques/jonctions, fichiers manquants ou non réguliers et sources dépassant 64 Mio. Les chemins de sortie ne peuvent pas cibler `.git`.
- Lecture des octets du working tree **sans normalisation**. Les sources historiques protégées par `.gitattributes` gardent leurs CRLF/BOM éventuels et leurs empreintes ; les fichiers ZIP ne subissent pas les filtres Git.
- Préflight de contenu et seconde lecture vérifiée avant ajout de chaque fichier. Une modification de source ou d'inventaire pendant l'opération fait échouer le paquet plutôt que de l'annoncer comme snapshot stable.
- `SOURCE_ARCHIVE_MANIFEST.json` intégré : commit et branche informatifs, indicateur de working tree modifié, liste des fichiers avec taille et SHA256, exclusions et limite du scan. Les fichiers non suivis sont inclus s'ils ne sont pas ignorés ; le commit seul ne décrit donc pas forcément tout le contenu.
- Vérification du ZIP, de ses chemins, des CRC et de toutes les tailles/empreintes avant succès. Le mode `--verify` ne décompresse aucun fichier sur le disque.

## Limites à conserver

Le scan détecte des signatures usuelles de secrets dans les octets bruts et refuse les noms sensibles. Il ne remplace pas la revue préalable : des secrets encodés ou comprimés, notamment dans PDF/images ou formats propriétaires, peuvent lui échapper. Le script ne prétend pas certifier une absence exhaustive de secrets.

Les dates du ZIP et du manifeste sont celles de sa création : le contenu et ses SHA256 sont vérifiables, mais le ZIP n'est pas promis identique bit pour bit entre deux créations. Le manifeste n'est pas une signature cryptographique. Les sous-modules, symlinks et dépendances hors dépôt ne sont pas vendus comme inclus ; cette tranche n'en exige pas. Le livrable ne contient pas l'historique Git, les SDK, les keystores, les APK ou les caches. Les sorties Android sont à fournir séparément avec leur recette et leur empreinte.

Après extraction dans un nouveau dossier, suivre le README racine et les commandes `tools/Setup-Studio.ps1`, puis les commandes de `games/001-switchworks/tools/Slice.ps1`. La présence d'un ZIP valide ne remplace ni ce démarrage depuis une extraction réelle ni la recette Android. SWITCHWORKS reste TEST / HOLD.

## Recette d'extraction exécutée le 14 novembre 2026

Le candidat `build/delivery/switchworks-archipel-sources-rc1.zip` contient **458 fichiers**, 75 357 124 octets sources. ZIP : 69 046 338 octets, SHA256 `4b6cd485b28f5401b58e65e5d1a29897983beee85767d45173a447e7264bc011`. Il a été extrait dans un dossier neuf sous `tools/.local/source-smoke-20261114-rc1/`, après vérification des chemins, CRC et 458 empreintes intégrées. Aucun fichier existant n'a été remplacé.

Le binaire Godot 4.7.2 Standard déjà installé a ensuite été choisi explicitement, avec `--path` dirigé vers **le projet extrait** : import de ses huit ressources à partir des sources, bootstrap **36/0**, gameplay **137/0**, interface **476/0**, tous codes 0 et sans `ERROR:`/`SCRIPT ERROR`. Une exécution GPU de sa scène a enregistré un vrai framebuffer 390×844 ; cette image a été ouverte et inspectée. [Log d'import/tests](../vertical-slice/evidence/logs/source-extraction-smoke.log), [log de rendu](../vertical-slice/evidence/logs/source-extraction-render.log), [capture](../vertical-slice/evidence/desktop/source-extracted-390x844.png).

La recette de packaging du script a aussi passé **14 contrôles de fixture** : manifeste, extraction, octets CRLF/BOM, inclusion PNG/MP4/TTF, exclusions même forcées dans l'index, refus d'écrasement/traversée/collision, détection de modification et motif de secret. Le test OS d'un véritable symlink n'a pas été exercé faute de permission Windows ; cette limite est conservée.

Le ZIP final `build/delivery/switchworks-archipel-sources.zip` ajoute les preuves et documents de clôture à ce candidat. Les sources runtime et assets sont inchangés ; son manifeste est revérifié. Son empreinte est publiée **localement** dans `build/delivery/SHA256SUMS.txt`, avec celle de l'APK. Le paquet ne prétend pas inclure un moteur/SDK : ce test réutilise explicitement les outils présents, sans simuler une installation sur un ordinateur vierge ou une certification multiplateforme.
