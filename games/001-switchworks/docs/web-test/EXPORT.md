# Export Web de test — Godot réel

14 novembre 2026. Référence native : `108e2b04a3109f8f67d00a65caf0d60d7f1c979e`. Branche de travail : `test/archipel-postal-web-iphone`. Aucun déploiement, upload ou accès externe n'est réalisé par les commandes de ce document.

## Configuration vérifiée

Un quatrième preset **Web Safari Test** est ajouté à `export_presets.cfg`. Les **20 831 octets** des trois presets précédents sont conservés comme préfixe exact ; aucun réglage de leurs sections n'est réécrit. Le projet de référence utilise déjà Compatibility et les features `archipel_slice` choisissent la scène jouable existante sans remplacer la mire par défaut.

| Option | Valeur |
|---|---|
| Plateforme | Web, export release |
| Scène par feature existante | `res://scenes/archipel_postal.tscn`, `archipel_slice,web_test` |
| Renderer | Compatibility / WebGL 2 |
| `variant/thread_support` | `false` |
| `variant/extensions_support` | `false` |
| Compression de textures desktop et mobile | Toutes deux `true` |
| PWA / service worker | Désactivés |
| Isolation ajoutée par service worker | Désactivée |
| Shell HTML de ce premier export | Modèle Godot par défaut, aucun poster/jeu HTML substitué |
| Canvas resize | Adaptive (`2`) |
| Données hors ressources incluses | `data/*.json`, notices texte Godot et OFL |
| Exclusions | Tests, QA de famille, outils, docs, artefacts, sorties de build |

Les noms d'options ont été rapprochés de la [source officielle du plugin d'export 4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/web/export/export_plugin.cpp). La [documentation Web Godot 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_web.html) précise le besoin WebAssembly/WebGL 2 et l'intérêt du mode sans threads sur iOS ; elle relève aussi des limites de Safari. Une compilation réussie ne prouve pas leur absence sur l'iPhone du propriétaire.

## Outils existants et commandes exécutées

Le binaire local **Godot 4.7.2.stable.official.ed1daf0bf Standard** a réellement été exécuté. Les modèles `web_nothreads_release.zip` et `web_nothreads_debug.zip` étaient déjà présents dans son `editor_data/export_templates/4.7.2.stable/`. Aucun téléchargement ou remplacement du moteur, aucun SDK Android/iOS ni signature n'est nécessaire à cet export.

Depuis la racine du studio :

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Web.ps1 -Action All
# Export seulement, pour une itération de shell ou de code Web :
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Web.ps1 -Action Export
# Contrôle autonome du filtre de données, pack séparé non servi :
powershell.exe -NoProfile -ExecutionPolicy Bypass -File games/001-switchworks/tools/Web.ps1 -Action PackSmoke
```

`Web.ps1` réutilise `tools/Studio.Common.ps1`. Il importe les ressources, vérifie l'édition/version et les templates locaux, exporte vers `build/web-safari/index.html`, inspecte les erreurs et calcule tailles/SHA256. En mode All, le smoke utilise **le PCK réellement servi**, sans le modifier. Le mode PackSmoke seul produit un pack distinct sous `build/web-safari-smoke/`.

Le traitement des certificats Windows a nécessité le droit de processus normal lors de ces exécutions ; aucune vérification TLS n'a été désactivée et aucun magasin de confiance système n'a été modifié. L'environnement utilisateur Godot reste sous `tools/.local` via le helper du studio.

## Résultat du premier export reproductible

Import, export release et lancement du pack : **codes 0**. Le pack affiche `SLICE_READY`, charge le niveau `archipel-double-flux-01` et la vraie scène. Aucun `ERROR:`/`SCRIPT ERROR` dans ces passages. Le smoke est natif Windows headless : il contrôle le contenu du pack, **pas** WebGL, Safari, le toucher ou IndexedDB.

Le fichier généré confirme `GODOT_THREADS_ENABLED = false`, `canvasResizePolicy: 2` et `ensureCrossOriginIsolationHeaders: false`. Il n'exige pas de worker pthread ou de service worker PWA. Les deux fichiers audio worklet sont des éléments du template, pas la preuve que le jeu utilise des threads WebAssembly.

Snapshot baseline avant les adaptations Web spécifiques ultérieures :

| Fichier principal | Octets | SHA256 |
|---|---:|---|
| `index.html` | 5 458 | `f704366d9533661f0907dcfcad8170c5f03631f2419f2fb71f5871deeb6c3ae3` |
| `index.js` | 279 815 | `33c94cb3175f3333b82e2a3be5e8e86f77986f0aa2042b1631f6367a4e5bb6ba` |
| `index.wasm` | 39 514 754 | `fc74679e3b97f76878947fcd4fbe1268cbfa6188182a2e33bbc3f5dc9bfa57d0` |
| `index.pck` | 4 523 388 | `844e7d024344387e4e5d5b6197b6f8f3b0f30b7189a5eb22b0a5d52b78e8b901` |

Les neuf fichiers exécutables/support du snapshot totalisent **44 364 789 octets non compressés**. Le manifeste effectif est `artifacts/web-test/export/web-files.json` ; une réexportation peut changer les empreintes. Le débit, la compression HTTP, le cache et le démarrage Safari doivent être mesurés sur le chemin de livraison retenu, pas déduits de cette taille.

Journaux : `artifacts/web-test/export/{import.log,web-export.log,pack-smoke.log,reproducible-run.log}`. Le premier essai d'outil exportait ensuite un autre PCK au même chemin et en changeait l'empreinte ; cette séquence a été corrigée, puis le second passage a vérifié que le manifeste reste identique après smoke. Ce premier essai n'est pas le snapshot reproductible ci-dessus.

Un fichier `.gdignore` est créé dans chaque dossier de sortie afin d'éviter d'importer les PNG de l'export pendant une prochaine passe éditeur. Des `.png.import` issus du premier essai peuvent rester dans la sortie locale : ils sont exclus du manifeste et **ne doivent pas être servis**. La racine HTTP doit autoriser seulement les neuf fichiers d'export nécessaires, jamais le dépôt ou `tools/.local`.

## Gates restant à vérifier

Le shell Godot généré n'est pas une nouvelle maquette : son canvas charge le moteur WASM et le pack de la vraie scène. Les tests navigateur, les éventuels ajustements Web de safe area/sauvegarde/reprise et l'accès HTTPS sont traités séparément. **iPhone Safari réel non testé par ce sous-travail.** Aucune donnée de joueur ou approbation artistique/commerciale n'est générée par l'export.

Une URL HTTPS externe ou un tunnel transmettrait le build à un service tiers et ne doit pas être lancé sans l'autorisation explicite du propriétaire. Les clés/certificats éventuels restent hors du pack et du dépôt. Les tests Android natifs demeurent une campagne séparée.

## Adaptation minimale du shell après le baseline

Le preset utilise maintenant `res://platform/web/godot_shell.html`. C'est une copie du `godot.html` du ZIP officiel déjà installé, avec seulement deux changements de métadonnées : `lang="fr"` et viewport `width=device-width, initial-scale=1.0, viewport-fit=cover` (retrait de `user-scalable=no`). Le corps, le canvas, le démarrage et la gestion d'erreur du moteur ne sont pas réécrits. Le copyright et le texte MIT complet sont inclus dans un commentaire ; [provenance et empreintes](../../platform/web/SOURCE.json), [notice](../../platform/web/NOTICE.md).

Le contrôle différentiel restaure exactement les octets du template d'origine après retrait du commentaire de notice et des deux substitutions de métadonnées. Aucun padding de page n'est ajouté : la prise en compte des encoches appartient au code GDScript Web, pour ne pas appliquer deux fois les marges. Aucun worker PWA, CDN ou accès extérieur n'est ajouté par ce shell.

Le réglage Web seulement `application/config/name.web` est désormais `SWITCHWORKS - Archipel Postal Web Test` ; la valeur native reste celle de la référence. La réexportation suivante doit confirmer ce titre dans `index.html`, puis remplacer les empreintes baseline par celles de son propre manifeste. Les empreintes de la section précédente restent un snapshot antérieur et ne décrivent pas ce shell dérivé.

## Rejouer les contrôles navigateur locaux

Depuis la racine du studio, réutiliser Node.js, Python et Chrome installés. Le contrôle utilise Playwright **1.65.1** sous `tools/.local/web-browser/`, sans navigateur téléchargé et sans profil personnel. S'il est absent sur une nouvelle machine, l'installation locale optionnelle est `npm install --prefix tools/.local/web-browser --ignore-scripts --no-audit --no-fund playwright@1.65.1` ; ne pas réinstaller ici. La licence Apache-2.0 du paquet et ses notices restent dans son installation locale, pas dans le jeu.

```powershell
# Terminal local, sans tunnel ni exposition LAN :
python games/001-switchworks/tools/serve_web_test.py
# Autre terminal, depuis la racine du studio :
$env:STUDIO_WEB_PROFILE = 'pro' # puis 'max' ou 'landscape'
node games/001-switchworks/tools/test_web_browser.cjs
```

Le script attend actuellement Chrome Windows à `C:/Program Files/Google/Chrome/Application/chrome.exe`. Les reçus et profils isolés sont écrits sous `artifacts/web-test/`. Pour le tunnel déjà autorisé, `STUDIO_WEB_URL` désigne l'URL HTTPS et `STUDIO_WEB_PASSWORD_FILE` un fichier ignoré, jamais la valeur du secret dans une commande. Ces contrôles restent Chrome, y compris avec le toucher émulé : ils ne remplacent pas le contrôle physique Safari. Le build courant est décrit par [la recette](REPORT.md) et son manifeste, pas par les empreintes du premier export ci-dessus.
