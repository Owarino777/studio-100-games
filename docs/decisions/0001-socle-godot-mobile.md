# ADR 0001 — Socle du studio et premier projet mobile

- Date : 14 novembre 2026
- Statut : accepté par le propriétaire dans sa demande de mise en place
- Périmètre : monorepo `studio-100-games`, premier projet `games/001-switchworks`

## Contexte et décision

Le studio utilise un monorepo Git local sur `main`. SWITCHWORKS utilise **Godot 4.7.2 stable, édition Standard**, et du **GDScript typé**. Android est la première cible de travail sur Windows ; iOS sera construit et testé ultérieurement sur macOS. Les autres jeux du monorepo garderont un choix de moteur explicite par projet.

Les 85 skills installés sont utilisés sélectivement via le routeur existant. Leur présence ne remplace pas les vérifications par l'éditeur, les tests et les builds réels.

## Installation et isolation

Godot et les modèles correspondants proviennent de la [release officielle 4.7.2](https://godotengine.org/download/archive/4.7.2-stable/). Les archives sont vérifiées par SHA512 avant extraction. Le SDK Android, Android Studio, le JDK et l'image d'émulation existants sont réutilisés ; seules les versions de paquets manquantes sont ajoutées côte à côte.

L'éditeur portable et ses préférences vivent sous `tools/.local/godot/4.7.2/`, avec `_sc_`. Les données de test `APPDATA`, les caches Gradle et Android sont également isolés par processus sous `tools/.local/`. Aucun PATH, paramètre Windows, driver ou hyperviseur n'est changé par les scripts. Les chemins propres au poste restent dans des fichiers ignorés et ne deviennent pas des dépendances du code versionnable.

Un AVD propre au studio réutilise l'image Android 36 installée. Son serveur ADB utilise le port 5041, distinct du port habituel 5037 ; les AVD des autres projets ne sont pas modifiés.

## Projet de vérification

La scène initiale est une mire technique native, avec version du moteur, plateforme et bouton de contrôle. Elle ne définit pas le gameplay ni la direction artistique complète. Le renderer Compatibility permet de vérifier un chemin OpenGL/GLES ; les choix graphiques du produit final feront l'objet d'une décision et de mesures distinctes.

Les presets `Android APK` et `Android AAB` produisent des paquets **debug** de vérification, avec l'identifiant provisoire `org.studio100games.switchworks.verification`. Ils ne constituent ni l'identifiant commercial définitif, ni une configuration de publication. Les clés release et comptes stores restent hors du périmètre.

## Alternatives et conséquences

- L'édition .NET/C# n'est pas retenue : aucun SDK .NET supplémentaire n'est nécessaire.
- Une installation Godot globale est évitée pour conserver les préférences des autres projets.
- Les templates Gradle sont générés par le moteur et les dépendances mises en cache localement ; ils sont exclus du suivi Git. Les scripts les recréent à partir du template exact.
- Les premiers téléchargements nécessitent un accès réseau. Les scripts sont idempotents sur les installations contrôlées ; ils ne certifient pas la présence de tous les outils sur une nouvelle machine sans exécution de `Doctor` et de la recette.
- Le dépôt est initialisé sans remote. Le premier commit et toute publication sont des actions distinctes ; aucun commit n'est effectué dans cette mise en place.

## Vérification

La [recette de mise en place](../RECETTE_BOOTSTRAP_2026-11-14.md) consigne les versions exécutées, les empreintes, les tests, les exports, les captures authentiques et les limites. L'[audit initial](../AUDIT_ENVIRONNEMENT_2026-11-14.md) reste inchangé en tant qu'état historique validé.
