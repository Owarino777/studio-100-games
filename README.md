# Studio 100 Games — Kit Codex

Kit d'instructions complémentaires au catalogue `gamedev-skills/awesome-gamedev-agent-skills`, qui possède déjà son propre routeur automatique. **Ne pas créer un deuxième routeur**.

## État et organisation du monorepo

L'[audit initial du 14 novembre 2026](docs/AUDIT_ENVIRONNEMENT_2026-11-14.md) est conservé comme état historique. La mise en place opérationnelle est décrite dans la [recette du socle](docs/RECETTE_BOOTSTRAP_2026-11-14.md) et l'[ADR 0001](docs/decisions/0001-socle-godot-mobile.md). Git est initialisé localement sur `main`, sans remote ni premier commit. Godot 4.7.2 stable Standard et ses modèles sont installés localement ; `games/001-switchworks` contient une mire exécutable en GDScript typé. Les résultats exacts Android et les limites iOS figurent dans la recette.

Pour préparer les outils, lancer les tests ou exporter le paquet de vérification, utiliser les [commandes du studio](tools/README.md). Aucun développement graphique complet de SWITCHWORKS n'a commencé.

| Emplacement | Rôle |
|---|---|
| `games/NNN-slug/` | Un jeu autonome et sa documentation ; `001-switchworks` contient le projet minimal de vérification |
| `shared/` | Ressources réellement réutilisées par plusieurs jeux, avec dépendances explicites |
| `platform/` | Configuration et procédures communes Android/iOS, sans secrets |
| `tools/` | Outils de développement et de vérification du studio |
| `docs/decisions/` | Décisions techniques et leurs conséquences |
| `docs/market-research/` | Études datées, sources et hypothèses de marché |
| `docs/third-party/` | Licences et attributions des composants tiers copiés |
| `imports/` | Zone locale ignorée, jamais une dépendance implicite d'un build |
| `.agents/skills/` | 80 skills du catalogue, routeur inclus, et 5 skills locaux `studio-*` |

Nommer les jeux avec un numéro de trois chiffres et un slug ASCII en minuscules séparé par des tirets (`NNN-slug`). Conserver les conventions natives du moteur dans chaque jeu. Pour Godot : fichiers et dossiers en `snake_case`, types GDScript en `PascalCase` ; documenter la version exacte de l'éditeur, des modèles d'export et les commandes dans le README du jeu. Le moteur est choisi par jeu.

Les tests vivent dans le jeu concerné (`tests/`) ; les sorties sont placées dans son `build/` ou `artifacts/`, ignorés par Git. Les preuves de recette sélectionnées vivent sous `docs/recette/`. Éviter les chemins absolus et les dépendances vers `imports/`. Tout usage de `shared/` doit être inclus par une procédure reproductible. Les responsables seront indiqués dans les README des modules lorsqu'ils seront attribués.

`skills-lock.json` suit les 80 copies du catalogue, pas les 5 skills rédigés localement. Il contient des empreintes de contenu, sans commit amont ; ne pas le présenter comme un verrouillage complet de révision. Les notices du catalogue sont conservées dans [docs/third-party/gamedev-skills](docs/third-party/gamedev-skills/README.md). Aucune licence du catalogue n'est attribuée par extension aux jeux du studio.

## Installation Windows (PowerShell)

1. Vérifier Node : `node --version` (minimum 22.20 d'après la documentation du catalogue).
2. Installer tous les skills et le routeur pour Codex, de façon globale si souhaité :

```powershell
npx skills add gamedev-skills/awesome-gamedev-agent-skills -a codex -g
```

Pour prévisualiser : `npx skills add gamedev-skills/awesome-gamedev-agent-skills --list`. Pour limiter la taille du catalogue, installer seulement le routeur et le bundle du moteur/projet si l'installateur le permet ; l'installation complète n'est pas nécessairement optimale quand de nombreux skills sont déjà présents. Mettre à jour avec `npx skills check` puis `npx skills update`.

Le catalogue est déjà installé localement dans ce dossier : inutile de le réinstaller pour l'audit. La commande ci-dessus concerne une autre installation ou une mise à jour choisie explicitement.

3. Copier ce kit complémentaire dans un autre dossier de projet existant :

```powershell
.\Installer-StudioKit.ps1 -ProjectPath 'C:\Dev\MonJeu'
```

Le script copie uniquement les cinq skills `studio-*`, les trois modèles/documents du kit vers `docs/studio-quality/`, `AGENTS.md` et le prompt de lancement. Il préserve les fichiers et skills existants et refuse sa propre source comme destination. Il n'installe pas le catalogue et ne copie pas son lock.

Si PowerShell interdit l'exécution du script, copier manuellement les cinq dossiers `.agents/skills/studio-*`, les trois documents du kit et les instructions manquantes ; ne pas changer globalement la politique d'exécution juste pour ce kit. Le script n'écrase pas un `AGENTS.md` existant.

4. Ouvrir le dépôt dans Codex, puis utiliser `/skills` pour vérifier les skills détectés. Coller `CODEX_PROMPT_DE_LANCEMENT.md` en message initial.

## Références
- https://github.com/gamedev-skills/awesome-gamedev-agent-skills
- https://github.com/gamedev-skills/awesome-gamedev-agent-skills/blob/main/docs/INSTALLATION.md
- https://learn.chatgpt.com/docs/build-skills
- https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
- https://interfaceingame.com/

## Portée et limites
`Installer-StudioKit.ps1` copie les instructions et les modèles. Le script distinct `tools/Setup-Studio.ps1` installe le socle Godot Windows ; il ne configure ni Xcode, ni SDK de monétisation, ni connexion GitHub. Les skills ne remplacent pas des graphistes, la recherche utilisateur et les tests sur téléphones réels.

Les commits et opérations distantes suivent les autorisations du propriétaire. Git a été initialisé selon sa décision explicite ; avant le premier commit, vérifier les fichiers sélectionnés et scanner les secrets. `.gitignore` réduit les ajouts accidentels ; il ne détecte pas un secret dans un fichier autorisé.
