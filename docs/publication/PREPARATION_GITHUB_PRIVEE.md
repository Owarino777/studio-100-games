# Versionnement initial et préparation GitHub privée

État vérifié le 14 novembre 2026. La publication distante n'est pas autorisée à cette étape.

## Fondation versionnée

| Élément | Preuve |
|---|---|
| Premier commit local sur `main` | `9687b0e71c91b7be39bc7d86fc12171d9cffd543` — `chore: initialize verified Godot mobile studio` |
| Arbre du commit | `cb1183c44b17332396b593a34d7d8f49aa427c5c` |
| Périmètre | Exactement les 296 fichiers de la fondation technique validée ; aucun nouveau livrable produit/art de la phase suivante inclus |
| Historique | Un commit racine, sans parent ; `git fsck --full --strict` code 0, aucun diagnostic |
| État juste après ce commit | Index vide, `git status --porcelain` vide ; les travaux suivants sont des changements distincts |
| Préparation distante locale | `origin` = `https://github.com/Owarino777/studio-100-games.git` |

Contrôles exécutés avant le commit : manifeste SHA256 des 296 fichiers ; sélection explicite de ces seuls chemins ; comparaison des blobs indexés avec les filtres Git applicables ; scan des fichiers et des blobs indexés sans motif de secret détecté ; 9 contrôles positifs du détecteur ; **31/31 exclusions ou autorisations Git conformes**. Les outils, caches, clés, sorties APK/AAB, `.godot/`, templates Gradle et imports locaux sont exclus.

Les 80 skills tiers correspondent à leurs empreintes du lock ; 85 frontmatters et 13 fichiers YAML sont valides. Les copies Apache-2.0 de `LICENSE` et `NOTICE` sont présentes dans `docs/third-party/gamedev-skills/` et leurs empreintes correspondent au relevé initial. Le commit conserve les octets du corpus et des notices ; il n'attribue pas leur licence aux cinq skills locaux ou au jeu. Les fins de ligne CRLF du corpus et certains espaces des logs de preuve sont conservés volontairement. Le contrôle de whitespace du code/documentation du studio hors corpus et logs bruts passe sans anomalie.

Le scan par motifs ne prouve pas l'absence exhaustive de secrets. Aucune clé de signature release n'est incluse et les données de test restent locales.

## Destination préparée, sans publication

Destination demandée : **`Owarino777/studio-100-games`**, visibilité exigée : **privée**. Seule l'URL du remote local a été configurée. Aucun dépôt GitHub n'a été créé, aucune visibilité distante modifiée, aucun push ou requête vers le dépôt cible exécuté.

Le programme `gh` n'est pas disponible sur le PATH de ce poste lors du contrôle. L'existence du dépôt distant, sa visibilité et les droits du compte n'ont donc pas été établis. Une URL Git locale ne définit pas la confidentialité d'un dépôt GitHub.

## Séquence prête pour une autorisation ultérieure

Ces commandes sont préparées pour revue ; **elles n'ont pas été exécutées**. Après disponibilité d'un moyen d'accès GitHub autorisé, vérifier le compte utilisé, la destination et le commit final à publier.

1. Si le dépôt existe, lire ses propriétés et exiger `nameWithOwner = Owarino777/studio-100-games`, `isPrivate = true` et `visibility = PRIVATE` avant toute publication :

   ```powershell
   gh repo view Owarino777/studio-100-games --json nameWithOwner,isPrivate,visibility,url
   ```

   Ces champs sont documentés dans le [manuel officiel `gh repo view`](https://cli.github.com/manual/gh_repo_view).

2. S'il n'existe pas et après autorisation de sa création, créer un dépôt privé vide, sans README ni licence de dépôt ajoutés automatiquement :

   ```powershell
   gh repo create Owarino777/studio-100-games --private
   ```

   La création privée et le push sont des opérations distinctes de la CLI ; cette commande omet volontairement `--push`. [Manuel officiel `gh repo create`](https://cli.github.com/manual/gh_repo_create)

3. Relire la visibilité privée, le contenu des commits sélectionnés et les exclusions. Si des refs distantes existent, examiner leur histoire sans écrasement ni push forcé. Un refus d'accès ne prouve pas que le dépôt n'existe pas.

4. Après autorisation explicite du propriétaire pour le push du snapshot final vérifié :

   ```powershell
   git push -u origin main
   ```

5. Vérifier ensuite la ref distante et la visibilité privée. Aucune clé, token ou donnée d'authentification ne doit être ajouté à l'URL de `origin`.

La connexion GitHub, la création distante et le push restent à effectuer uniquement après autorisation. Les nouveaux livrables de préparation produit et artistique ne font pas partie du commit de fondation ci-dessus ; leur versionnement doit rester identifiable dans l'historique suivant.
