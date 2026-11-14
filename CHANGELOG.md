# Journal des changements

## 2026-11-14 — Mise en place opérationnelle du studio

- Initialisation Git locale sur `main`, sans commit ni remote ; règles de fins de ligne explicites et exclusions des outils, caches et paquets générés.
- Installation officielle vérifiée par SHA512 de Godot 4.7.2 stable Standard et de ses modèles correspondants, dans une installation portable propre au studio.
- Réutilisation du JDK, des SDK et de l'image Android existants ; ajout côte à côte des paquets manquants.
- Scripts de préparation, diagnostic, lancement, tests headless, exports Android et émulation isolée.
- Projet minimal de vérification en GDScript typé dans `games/001-switchworks`, sans gameplay ni réalisation graphique complète.
- ADR du socle et recette avec résultats réels, captures et limites ; audit initial conservé comme historique.

## 2026-11-14 — Audit initial de l'environnement

- Audit du routeur, des cinq skills locaux, du YAML, du suivi de contenu, de Git, des secrets et des prérequis Godot Android/iOS.
- Exclusions supplémentaires pour clés et profils mobiles, identifiants d'export Godot et configuration Android locale.
- Documentation des rôles du monorepo et des conventions de nommage ; conservation des dossiers réservés par leurs README.
- Restauration des notices de licence et d'attribution du catalogue tiers.
- Installateur limité au kit complémentaire, avec protection contre une destination identique à la source et conservation des fichiers existants.
- Aucun jeu créé, aucun dépôt Git initialisé, aucun commit ni changement distant.
