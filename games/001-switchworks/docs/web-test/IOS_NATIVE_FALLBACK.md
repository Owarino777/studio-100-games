# Voie iOS native si Safari ne permet pas le test

**Préparation du 14 novembre 2026. Aucun build Xcode, signature ou lancement iPhone natif exécuté ici.** Un échec Safari doit d'abord être caractérisé par sa version iOS, son origine HTTPS, son build et sa preuve. Un export réussi ou un outil WebKit de bureau ne prouve ni fonctionnement ni échec sur le téléphone.

## Déclencheur et portée

Si l'iPhone réel ne charge pas le jeu, perd son contexte graphique, ne permet pas les gestes ou ne retrouve pas une préparation de façon exploitable, conserver le cas et décider avec le propriétaire d'un correctif Web ciblé ou d'un essai natif. Ne pas engager une nouvelle refonte ou une migration de moteur pour contourner une hypothèse non vérifiée. Le niveau et Archipel Postal restent inchangés.

La documentation [Godot 4.7 — export iOS](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_ios.html) exige **macOS avec Xcode** et les modèles d'export. Elle requiert un Team ID valide et un bundle identifier pour générer le projet Xcode. L'éditeur Windows ne remplace donc pas cette chaîne ; aucune promesse de binaire iOS installable depuis ce poste n'est faite.

## Prérequis à faire confirmer

| Élément | Préparation / preuve à obtenir |
|---|---|
| Accès à un Mac | Matériel disponible et autorisé ; aucun achat/location/cloud n'est engagé sans accord |
| Xcode stable | Vérifier la compatibilité du macOS, du SDK et de l'iOS réel dans la [matrice Apple](https://developer.apple.com/xcode/system-requirements) ; ne pas installer une bêta par défaut |
| Godot | **4.7.2 stable Standard** et modèles iOS de la même version ; conserver le projet/base `108e2b04`, sans mélanger les exports Web |
| iPhone | Modèle/iOS réel, câble ou connexion Xcode autorisée, espace disponible et accord du propriétaire |
| Signature de développement | Apple Account/Team disponibles, identifiant de bundle de test validé ; aucun identifiant ou mot de passe dans le dépôt |
| Réglages du téléphone | Le propriétaire effectue les autorisations nécessaires, dont le mode développeur si demandé ; [procédure Apple](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device). Aucun réglage de sécurité automatisé |
| Coûts / diffusion | Clarifier le cas de test personnel ou de distribution avant toute adhésion ; aucun store, TestFlight ou dépense automatiquement autorisé |

Apple décrit une [Personal Team dans Xcode](https://developer.apple.com/help/account/basics/about-your-developer-account) pour le test sur appareil personnel, avec reprovisionnement périodique ; les profils gratuits expirent après sept jours. Il faut vérifier que l'identité/Team et le projet Godot sont effectivement signables dans le cas du propriétaire. Cela ne garantit pas une distribution aux cinq joueurs ou une autorisation commerciale. Ne pas conclure qu'un abonnement est requis ou suffisant avant ce contrôle.

## Parcours technique borné sur Mac

1. Créer une branche native de test depuis la référence convenue, sans déplacer `main` ou la branche de finition ; transférer uniquement les sources nécessaires et notices. Aucun secret ni sauvegarde personnelle.
2. Importer dans Godot 4.7.2 Standard, exécuter les suites conservées et vérifier le projet avant export. Le niveau, ports et règles doivent rester identiques. Reprendre les overrides de plateforme seulement si justifiés.
3. Ajouter un preset iOS local de test avec Team ID/bundle identifier réellement validés. Les clés/profils confidentiels restent hors Git. Exporter vers un dossier neuf, puis ouvrir le projet Xcode produit.
4. Sélectionner l'iPhone réel et l'équipe de développement autorisée ; résoudre les prérequis de signature avec le propriétaire, sans automatiser ses identifiants ou dialogues d'authentification.
5. Construire et installer une version de développement. Contrôler le vrai rendu, toucher, rotation, réception, mouvement réduit, sauvegarde et Home/reprise. Vérifier le renderer actuel avant d'en proposer un autre ; aucune identité de rendu n'est présumée entre Web et natif.
6. Garder build/commit, versions Xcode/macOS/iOS, empreintes et captures authentiques. Une erreur de signature reste un blocage documenté, pas un succès ou une demande de publication.

Le plan d'acceptation reprend les mêmes tâches, avec le contexte **IOS_NATIVE** dans des fiches distinctes. Une personne déjà exposée à Safari possède un effet d'apprentissage à consigner. Le [protocole Safari](../user-tests/safari-web-5/PROTOCOLE.md) et celui d'Android ne doivent pas recevoir les résultats de cet essai natif.

## État à ce jalon

| Vérification | Statut de cette préparation |
|---|---|
| Mac/Xcode disponible et compatible | NE |
| Team/signature réellement fonctionnels | NE |
| Export iOS de ce projet | NE |
| Installation et rendu sur l'iPhone | NE |
| Sessions humaines iOS natives | NE |

Les accès matériels, comptes, autorisations et éventuels coûts restent à décider. Aucune distribution externe n'est préparée comme déjà autorisée. Le statut artistique définitif et commercial reste **TEST / HOLD**.
