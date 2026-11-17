# ADR 0004 — UI native en conteneurs et état de présentation dérivé

Date : 17 novembre 2026. Statut : retenu pour la refonte expérimentale demandée, validation artistique finale du propriétaire en attente.

## Contexte

Le PDF du 16 novembre exige une refonte UI/UX au-delà de bordures décoratives, sans modifier le puzzle, les données ou la sauvegarde. L'étude 2b53f3a fournit des sources modulaires mais reste trop chargée et ses couches de fin/pause se superposent. Un bandeau sombre est reproductible : infobulle native du TextureRect de plateau, sans rapport avec le solveur.

## Décision

- Conserver l'historique et isoler la refonte dans `feat/switchworks-postal-ui-ux`. Valider un banc de composants exécuté avant intégration sur le seul niveau existant.
- Employer un HUD éditable `.tscn`, un thème global `.tres`, des tokens `.tres` et une classe pure `PostalPresentationState` dérivée du contrôleur. Le modèle de puzzle reste inchangé ; pas de seconde logique de simulation.
- Préserver les méthodes de sauvegarde et leur schéma hérités, et utiliser des paquets/presets d'essai séparés pour protéger les références. Aucun compte, service ou progression supplémentaire.
- Supprimer l'infobulle de plateau dans sa source et garder sa description d'interaction accessible. Consignes dans un emplacement HUD réservé hors du plateau.
- Attendre la fin de la présentation locale des réceptions pour le bilan intégré, tout en conservant la victoire logique et Rejouer immédiat. Pause = seul calque modal avec fond non focalisable ; pas de modale de victoire.
- Calculer le placement via Container/anchors et minima de contenu. Sur Android, le nouveau seul écran/preset utilise le DPI rapporté pour ses unités et l'orientation capteur ; les profils QA vérifient taille de fenêtre réelle et densité, pas le nom du profil.
- Nouveaux modèles originaux en TSCN/GLB ; aucun pixel conceptuel importé. La simplicité de construction et les silhouettes guident la matière, sous Compatibility.

## Conséquences et limites

Les anciennes scènes, assets et branches restent les comparateurs. Le correctif d'infobulle est le seul changement à leur vue de base ; il traite un défaut constaté, sans altérer les ports ou commandes.

Le navigateur conserve une synchronisation de fichiers asynchrone gérée par Godot. La QA observe IndexedDB par l'API publique en lecture seule, sans forcer FS ni changer le format. Rechargement, fermeture après synchronisation et fermeture très rapide sont trois cas distincts ; aucune garantie de durabilité iOS n'est déduite de Chrome.

Les mesures PC/émulateur ne certifient ni framerate mobile réel, ni chauffe, ni accessibilité complète. Les profils texte agrandi et les contrastes sémantiques sont des contrôles de base, pas une conformité RGAA/WCAG. L'acceptation artistique et commerciale reste une décision humaine après preuves et tests appropriés.
