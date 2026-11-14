# Tests iPhone Safari Web — cohorte séparée

**Préparation du 14 novembre 2026. Aucun test iPhone ou humain déclaré exécuté par ces gabarits.** Le jeu Web doit être l'export Godot réellement exécuté, depuis la base `108e2b04`, et non une maquette. La branche de finition Android et son APK restent les références de la campagne native future.

| Contexte | Identifiant de campagne | Ce que le résultat peut documenter |
|---|---|---|
| Safari sur l'iPhone physique | `SAFARI_WEB_IPHONE`, SW01–SW05 | Ce navigateur, cette version iOS, ce build Web et cette origine HTTPS |
| Android natif physique, prévu ultérieurement | `ANDROID_NATIVE`, campagne Android conservée | L'APK précis sur les Android effectivement utilisés |
| WebKit/Chromium de bureau ou émulation de viewport | Contrôle technique distinct | Exécution du build dans cet outil, pas exécution Safari iPhone ou Android natif |

Les résultats des trois lignes ne sont pas fusionnés. Ni un chargement Web réussi, ni cinq sessions Safari favorables ne ferment la validation Android. Les limites d'iOS natif restent également distinctes.

Le propriétaire déclare deux appareils disponibles : **iPhone 15 Pro** et **iPhone 15 Pro Max**, tous deux sous **iOS 27.2**, sur le même Wi-Fi que le PC. Il a ensuite confirmé sur le **15 Pro** l'accès, la rotation au toucher, sa conservation après reload et l'affichage de « Reprendre » après Home. Il juge insatisfaisants matériaux/relief, rails/bâtiments et interface, et le démarrage lent. Ce retour technique propriétaire est séparé de la cohorte ; aucune manipulation distante instrumentée n'a été effectuée sur le téléphone. Réception, animations, confort, durée de chargement et Pro Max restent à vérifier. Une répartition préalable de trois premières expositions sur D01 et deux sur D02 est possible ; cela reste cinq personnes, pas dix.

## Documents prêts à utiliser

- [Protocole et critères proposés](PROTOCOLE.md) : contrôle du build, chargement, cinq tâches non guidées puis interruptions et persistance.
- [Fiche individuelle vierge](FICHE_OBSERVATION.md) : une copie par joueur, stockée hors des sources.
- [Résultats SW01–SW05](resultats.csv) : cinq lignes prévues, statut `NE`, mesures vides.
- [Contrôles techniques iPhone](controle_technique.csv) : lignes de contrôle prévues, aucun succès précoché.
- [Journal des gestes](evenements_tactiles.csv) : en-tête seul, intention et effet à consigner réellement.
- [Synthèse par contexte](SYNTHESE.md) : ne pas convertir les observations Web en qualification native.
- [Voie iOS native si nécessaire](../../web-test/IOS_NATIVE_FALLBACK.md).

Les CSV sont UTF-8, séparateur virgule. Les copies réelles et médias autorisés vont sous `games/001-switchworks/artifacts/user-tests/safari-web/`, ignoré par Git. Garder ces gabarits vierges. Aucun contact, recrutement, envoi ou hébergement externe n'est effectué par ce dossier.

L'accès choisi ensuite a été explicitement autorisé par le propriétaire : [tunnel Cloudflare temporaire authentifié](../../web-test/ACCESS.md). Il n'exige pas de certificat sur l'iPhone. Sa vérification technique sur Chrome n'est pas une session SW01–SW05 ; le retour propriétaire est également séparé des cinq joueurs. La recette générale indique les observations physiques réellement obtenues.

## Avant toute collecte

Le propriétaire doit ouvrir l'adresse HTTPS autorisée sur son iPhone et compléter le contrôle technique. Renseigner le SHA du build **effectivement servi**, le modèle, iOS et Safari ; ces valeurs ne sont pas inventées ici. Ne pas copier un token de lien, mot de passe, numéro de série, IP privée ou certificat dans les fiches partagées. L'origine publique peut être remplacée par un code O01, avec sa correspondance conservée localement par l'opérateur.

L'autorisation d'une mise à disposition extérieure, d'une dépense ou d'un changement de confiance de certificat reste séparée. Aucun avertissement TLS ne doit être traité comme un test réussi en le contournant. La validation artistique définitive et commerciale demeure **HOLD**.

Le Wi-Fi commun rend un accès local envisageable, sans prouver qu'un certificat est accepté ou qu'un port est joignable. Aucun changement de confiance de certificat ni règle de pare-feu n'est présumé autorisé. Ne pas annoncer une URL iPhone prête avant ces vérifications et la véritable ouverture sur Safari.
