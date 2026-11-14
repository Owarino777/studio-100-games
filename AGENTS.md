# Studio 100 Games — Règles de travail pour Codex

## Mission
Produire des jeux originaux, commercialement fondés, techniquement fiables, beaux et réellement jouables sur appareils mobiles. Ne pas confondre prototype, concept art, build et produit commercial.

## Compétences et orchestration
- Détecter le moteur à partir du dépôt (`project.godot`, `Assets/` + `ProjectSettings/`, `*.uproject`, etc.). Ne pas présumer un moteur unique pour les 100 jeux.
- Utiliser le routeur du catalogue `gamedev-skills/awesome-gamedev-agent-skills` pour sélectionner les compétences pertinentes. Ne lire que les skills nécessaires à la tâche. Si un skill n'est pas installé, le signaler et travailler avec les documentations officielles plutôt que feindre son utilisation.
- Utiliser `studio-product-discovery` pour l'opportunité et le positionnement, `studio-art-direction` pour concevoir les visuels, `studio-game-ux` pour les parcours, `studio-visual-qa` avant la livraison d'écrans, et `studio-mobile-release` à l'approche des stores.
- Agents supplémentaires uniquement si les tâches sont indépendantes et si leur coût de coordination est inférieur au gain attendu. Les résultats d'un agent sont vérifiés par un autre contrôle (tests, outils, revue humaine).

## Source de vérité et validations
- Une illustration générée, une maquette ou une capture Figma n'est jamais une preuve de fonctionnalité. Montrer des captures enregistrées depuis le vrai build, avec moteur, version, OS, résolution et scène.
- Ne pas présenter une suite de tests limitée comme une garantie « zéro bug », « zéro triche » ou de conformité RGAA/RGPD.
- Les références concurrentes servent à identifier des conventions, pas à recopier la composition ou la direction artistique d'un produit identifiable. Documenter les caractéristiques originales du jeu.
- Toujours vérifier le chemin utilisateur de livraison : archive extractible, procédure de démarrage reproductible, assets et dépendances inclus, aucun chemin local implicite.
- Tester sur les environnements réellement disponibles. Inscrire explicitement les tests non réalisables (iOS, matériel physique, paiement réel, conformité juridique) dans la recette ; ne pas inventer de résultat.
- Bloquer toute qualification « prêt pour les stores » si les critères bloquants ci-dessous échouent.

## Qualité de développement
- Architecture simple et modulaire ; données validées à la frontière ; erreurs gérées ; tests unitaires/intégration et parcours utilisateur pertinents ; performances et consommation mesurées sur cibles ; journal des décisions et CHANGELOG.md.
- Récompenses, achats, classements compétitifs et autres valeurs sensibles validés côté serveur lorsque la sécurité l'exige. Le code client ne constitue pas une frontière de confiance. Secrets et clés sensibles exclus des builds et dépôts.
- Données minimisées, consentement adapté aux SDK, droits des personnes, accessibilité des commandes et texte, options de réduction du mouvement, respect des politiques stores.
- Les commits, pushes, déploiements, dépenses et changements distants suivent les autorisations explicites du propriétaire.

## Gates de livraison
1. Produit : segment cible, promesse, concurrents, différenciation et preuves/risques documentés.
2. Art : art bible validée ; famille d'assets homogène ; lisibilité du gameplay en 3 secondes.
3. UX : prise en main sans explications longues ; commandes tactiles ; parcours sans impasse ; retours clairs en succès/échec.
4. Implémentation : capture du vrai jeu cohérente avec les références ; aucune image publicitaire mensongère.
5. Technique : tests fonctionnels et non-fonctionnels, logs, régression, performance et export reproductible.
6. Publication : conformité, notifications et achats, mentions et permissions, sauvegardes, rollback et checklist par store.

## En fin de tâche
Rendre : (a) chemins précis des fichiers changés, (b) commandes exécutées et résultats observés, (c) captures authentiques si UI modifiée, (d) limites restantes, (e) prochaines décisions nécessaires. Ne pas rallonger artificiellement le rapport.
