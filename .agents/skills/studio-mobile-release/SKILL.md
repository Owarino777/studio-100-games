---
name: studio-mobile-release
description: "Préparer, auditer et livrer un jeu Android/iOS : packaging, versions, signatures, builds, achats intégrés, publicités, RGPD, accessibilité, compatibilité, CI/CD, revue store et publication contrôlée."
---

# Gate de distribution Android / iOS

## Préparation
- Vérifier les dernières règles officielles de Google Play et Apple App Store au moment de la release ; confirmer versions SDK/outils, architecture et permissions.
- N'exposer aucune clé privée, secret ou service account dans le dépôt, le build, les captures ou les logs. Utiliser stockage de secrets CI adapté.
- Contrôler versionName/versionCode, CFBundleShortVersionString/CFBundleVersion, migrations de sauvegardes, rollback, notes de version et changelog.

## Fonctionnel et conformité
- Tester sur appareils physiques ciblés et cas d'interruption réseau, arrière-plan, mémoire, suppression/réinstallation si pertinent.
- Vérifier consentement, données collectées, finalités, suppression de compte, déclarations de collecte sur les stores, licences et droits des assets.
- Vérifier que récompenses et achats sont validés côté serveur et que le hors ligne n'octroie pas de gains compétitifs non vérifiés.
- Évaluer accessibilité mobile, réduction du mouvement, lisibilité, feedback non chromatique et performance énergétique.

## Distribution
- Générer paquets signés/testables via pipeline réplicable, conserver preuves, checksums, captures et traces d'approbation.
- Ne pas déployer ni engager de dépense sans accord explicite du propriétaire.
- Documenter toutes les vérifications impossibles. Les tests simulés ne valent pas validation physique.
