# Accès HTTPS temporaire — test iPhone

14 novembre 2026. Le propriétaire a **explicitement autorisé un tunnel Cloudflare temporaire protégé par mot de passe**, limité aux fichiers clients du jeu. Aucun GitHub, store, dépôt source, APK ou clé privée n'est publié.

## Accès courant

URL de cette session : **https://drops-discover-bicycle-wear.trycloudflare.com/**

- Utilisateur : `studio`.
- Mot de passe : fichier local ignoré `tools/.local/web-https/20261114T065232518691Z/access-secret.txt` ; il n'est ni recopié dans les documents ni versionné.
- Ouvrir dans **Safari normal**, pas dans un aperçu intégré ni en navigation privée, puis attendre le chargement réel du jeu avant le chronométrage d'un participant.
- Aucun certificat ou application à installer sur l'iPhone. Les fichiers de certificat local préparés auparavant ne sont pas installés sur les téléphones ou dans Windows.
- Le PC doit rester allumé, éveillé et connecté ; le tunnel et son serveur doivent rester actifs. L'URL est temporaire, sans garantie de disponibilité, et change après recréation du tunnel. Le stockage navigateur dépend de cette origine : conserver la même URL pendant une session/campagne, noter tout changement.

Ce tunnel utilise un HTTPS public reconnu par Safari et rejoint **un serveur HTTPS authentifié sur loopback**. Le client Cloudflare vérifie le certificat d'origine à l'aide de la CA locale explicite ; aucune option `no-tls-verify` n'est utilisée. Aucune règle de pare-feu entrant et aucune confiance certificat système n'ont été ajoutées.

Cloudflare termine la connexion publique et peut donc traiter les fichiers clients et les identifiants temporaires de cette protection. Ce mot de passe ne protège aucun autre compte. Les personnes autorisées peuvent télécharger les artefacts clients du jeu, notamment le PCK ; cette protection ne constitue pas un chiffrement anti-extraction du jeu.

Le [service Quick Tunnels officiel](https://developers.cloudflare.com/tunnel/get-started/quick-tunnels/) est destiné aux tests. Aucun compte, domaine ou abonnement n'a été créé. Client local `cloudflared 2026.11.0`, exécutable officiel vérifié SHA256 `d5c1d82031da6253dcdcff64c944cd0fe063016edeb2e4fd088075fc9bd52d0a`, sous `tools/.local/cloudflared/` uniquement.

## Périmètre réellement servi

`serve_web_test.py` fige en mémoire les neuf fichiers attendus de l'export et refuse tout autre chemin : HTML de lancement Godot, JS, WASM, PCK, icônes/splash et deux worklets audio. Pas de listing de répertoire, `res://`, `.import`, certificat, clé, APK ou source du monorepo. Aucun journal de requêtes avec adresse IP, URL ou en-tête Authorization n'est écrit par ce serveur.

Vérification HTTPS effectuée : accès anonyme **401**, accès authentifié **200** avec HTML byte-identique à l'export. Les contrôles du vrai WASM ont également passé via l'URL publique authentifiée sur Chrome de bureau. Cela ne prouve pas encore Safari sur l'iPhone.

## Arrêter ou relancer

Les PID et commandes possédés sont conservés dans `tools/.local/cloudflared/session-web-108e/` et `artifacts/web-test/server-*.pid`. Pour arrêter, utiliser `tools/stop_web_test.ps1` ; il vérifie les exécutables/arguments avant de fermer uniquement ces processus de test. Ne pas tuer tous les Python ou navigateurs du PC.

Pour refaire un accès, d'abord exporter avec `Web.ps1 -Action All`, puis lancer `serve_web_test.py` sur loopback avec un certificat et secret locaux. Le serveur fige les octets au démarrage : un nouvel export ne remplace pas un serveur déjà actif. Refaire les vérifications d'empreinte et d'authentification après tout redémarrage. Les fichiers TLS locaux ont une durée de trois jours ; renouveler explicitement s'ils expirent.

La commande du tunnel utilisée est, avec les chemins locaux existants :

```text
cloudflared tunnel --no-autoupdate --url https://127.0.0.1:8766 --origin-ca-pool <ca.pem locale> --metrics 127.0.0.1:20241 --loglevel info
```

Ne pas passer en niveau debug : il pourrait enregistrer les en-têtes d'authentification. Ne pas partager le secret ou une URL avec identifiants intégrés. L'ancienne préparation HTTPS Wi-Fi n'est pas activée : aucun profil CA n'est nécessaire avec la voie Cloudflare choisie.
