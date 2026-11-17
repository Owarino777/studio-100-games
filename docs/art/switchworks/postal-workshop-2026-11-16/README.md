# SWITCHWORKS — Comptoir maritime, refonte UI/UX native

Exécution du brief du 16 novembre, poursuivie le **17 novembre 2026**. Une seule grille existante, pas nouveau niveau. Branche `feat/switchworks-postal-ui-ux`, base `2b53f3a`. Aucun achat, crédit de génération ou push.

- [Contrat de conception, pages du PDF et diagnostic](DESIGN_CONTRACT.md).
- [Recette critique et preuves avant/après](REPORT.md).
- [HUD éditable en scène native](../../../../games/001-switchworks/ui/workshop/postal_hud.tscn), [thème global](../../../../games/001-switchworks/ui/workshop/workshop_theme.tres), [tokens](../../../../games/001-switchworks/ui/workshop/tokens.tres).
- [Sources de modèles](../../../../games/001-switchworks/assets/postal-workshop/sources/) et [GLB](../../../../games/001-switchworks/assets/postal-workshop/models/), [provenance](../../../../games/001-switchworks/assets/postal-workshop/PROVENANCE.md).
- [Banc limité](../../../../games/001-switchworks/experiments/postal_workshop/workbench.tscn) et [niveau jouable](../../../../games/001-switchworks/experiments/postal_workshop/game.tscn).

Depuis la racine du studio :

```powershell
./games/001-switchworks/tools/PostalUi.ps1 -Action Run
./games/001-switchworks/tools/PostalUi.ps1 -Action Bench
./games/001-switchworks/tools/PostalUi.ps1 -Action Capture -Resolution 360x640
./games/001-switchworks/tools/PostalUi.ps1 -Action Capture -Resolution 390x844 -Grayscale
./games/001-switchworks/tools/PostalUi.ps1 -Action Capture -Resolution 360x640 -TextScale 1.25
./games/001-switchworks/tools/PostalUi.ps1 -Action Video
./games/001-switchworks/tools/PostalUi.ps1 -Action Test
python games/001-switchworks/tools/validate_postal_ui_assets.py
```

Les sorties sont datées sous `artifacts/ui-ux-refonte-2026-11-16/runs/`. Video enregistre le viewport configuré **450×800**, 30 images/s de simulation ; sa cadence de traitement ne mesure pas les FPS de jeu. Les PNG comparatifs sont indépendamment capturés en 390×844 et 360×640. Grayscale est une passe de shader **dans le moteur**, réservée à la QA ; aucun PNG brut couleur n'est retouché.

## Édition

Modifier la disposition avec les `Container`, anchors et propriétés de `ui/workshop/postal_hud.tscn`, sans replacer les boutons à des coordonnées propres à une capture. Les styles par défaut viennent réellement de `workshop_theme.tres`. `tokens.tres` est la source sémantique utilisée par le constructeur de thème ; les variantes de taille de texte de QA sont générées depuis ces tokens.

Pour modifier les objets : éditer `assets/postal-workshop/sources/*.tscn` dans Godot. Les pièces, matières et pivots restent séparés. `ReceptionLid`, `ReceiptSeal` et `Port1/2/4/8` sont des contrats fonctionnels. Réexporter avec **`PostalUi.ps1 -Action BuildAssets -ReuseSources`** pour conserver les TSCN modifiés. Sans ReuseSources, les sources sont volontairement régénérées depuis `workshop_models.gd`. Le grain céramique est original et déterministe (source GDScript et PNG), sans API d'image.

Blender n'a pas été installé ni simulé : sources natives TSCN et exports GLB réellement relus. Les anciennes familles restent conservées. Le banc montre le modèle de puzzle existant, une rotation/annulation et une réception vérifiée ; ce n'est pas un second niveau.

## Android et Web séparés des références

```powershell
./games/001-switchworks/tools/PostalUi.ps1 -Action ExportAndroid
./tools/Start-StudioEmulator.ps1 -Action Start -Gpu host
python games/001-switchworks/tools/verify_postal_ui_android.py
./games/001-switchworks/tools/PostalUi.ps1 -Action ExportWeb
python games/001-switchworks/tools/serve_web_test.py --root games/001-switchworks/build/web-postal-ui --port 8779 --revalidate-cache
```

APK : `build/android/switchworks-postal-ui-debug.apk`, paquet `org.studio100games.switchworks.postal.ui`. Il ne remplace pas le paquet de finition. La sauvegarde garde le fichier et le schéma hérités (`littoral_composition_v1.json`, version 1), dans le sandbox du paquet de recette. Pas de migration, effacement ou changement d'undo/simulation. Le mode orientation capteur et le dimensionnement Android en dp concernent ce seul preset/scène.

Web : `build/web-postal-ui/`, neuf fichiers clients Godot, release, Compatibility, sans threads/PWA/extensions. Le serveur ci-dessus écoute **127.0.0.1 uniquement** ; ce n'est pas un accès depuis l'iPhone. Le cache optionnel est privé et revalidé par ETag, sans changer le défaut des anciens serveurs. Les anciens exports sont conservés.

Le test navigateur utilise le Playwright local déjà installé et un Chrome isolé, jamais le profil personnel :

```powershell
$env:POSTAL_UI_URL='http://127.0.0.1:8779/'
$env:POSTAL_UI_PROFILE='pro' # compact ou landscape également
node games/001-switchworks/tools/test_postal_ui_web.cjs
```

Ces résultats ne sont pas Safari ou un téléphone Android physique. La durabilité Web dépend de la synchronisation asynchrone d'IndexedDB : fermeture très rapide après un geste à qualifier séparément du rechargement et d'une fermeture après synchronisation observée. Le test de persistance ne force jamais une API privée FS et n'écrit pas une sauvegarde à la place du jeu.

Le propriétaire conserve l'acceptation artistique finale. Les cinq joueurs indépendants, les performances/chaleur physiques et la validation commerciale restent distincts. SWITCHWORKS reste TEST / HOLD commercial.
