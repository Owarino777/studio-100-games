# Intégrité du build Web et de l'accès temporaire

Relecture indépendante en lecture seule du **14 novembre 2026**. Seul ce rapport est écrit par cet auditeur : aucun index, commit, branche, appareil, serveur, certificat système ou pare-feu n'est modifié par cette revue. Les requêtes HTTP sont des lectures du tunnel **explicitement autorisé par le propriétaire**, jamais une publication supplémentaire.

## Références préservées

Au snapshot de contrôle : branche active `test/archipel-postal-web-iphone`, base/HEAD `108e2b04a3109f8f67d00a65caf0d60d7f1c979e`. La branche de finition `fix/archipel-postal-finition-p1-p2` conserve ce même commit. `main` reste `68548a4b004a047e43d9ce0c77f248ffc07af23d`.

Comparaison contre `108e2b04` : **aucune modification** des données/niveaux, scripts du domaine, assets, icônes, scènes, tests, outils de racine ou skills. Le contrôleur reçoit des conditions Web ; la configuration du projet ajoute un nom spécifique Web. Les adaptations ne sont pas présentées comme une validation de tous les comportements physiques.

Les **20 831 octets** du fichier des trois presets natifs précédents restent un préfixe **byte-identique** du nouveau `export_presets.cfg` ; seul le preset Web est ajouté après eux. L'APK Android conservé reste SHA256 `6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965`.

La revue finale et les préparatifs Android non suivis présents avant ce travail sont conservés. Cet audit ne les transforme pas en résultats de joueurs.

## Export réellement contrôlé

Les **neuf fichiers** du manifeste `artifacts/web-test/export/web-files.json` correspondent à leurs tailles et SHA256 locaux. Ils ont ensuite été téléchargés **par le tunnel HTTPS authentifié** et comparés au même manifeste : **9/9 conformes**. Le PCK réellement servi est :

```text
5ba7b0e797f60642cdd9fb458338a395a13510c27ef0485ff9298041212f8da6
```

`index.wasm` est **byte-identique** à l'unique WASM du modèle installé `web_nothreads_release.zip`, Godot 4.7.2 Standard : **39 514 754 octets**, SHA256 `fc74679e3b97f76878947fcd4fbe1268cbfa6188182a2e33bbc3f5dc9bfa57d0`. Le contrôle ne repose donc pas uniquement sur un libellé HTML. Celui-ci confirme aussi `GODOT_THREADS_ENABLED=false`, `lang=fr`, `viewport-fit=cover` et le titre Web attendu. Le projet reste en Compatibility.

Les sorties `.png.import` résiduelles, `.gdignore`, journaux et métadonnées d'export ne font pas partie de cette liste servie. Aucun service worker/PWA n'est annoncé par le preset contrôlé.

## Protection de l'accès observée

URL de session contrôlée : `https://drops-discover-bicycle-wear.trycloudflare.com/`. Cette URL temporaire n'est pas une garantie de disponibilité future. Le secret a été lu en mémoire pour vérifier les réponses ; **sa valeur n'est ni imprimée par cet auditeur, ni copiée dans ce rapport**.

| Vérification en lecture | Résultat observé |
|---|---|
| Requête sans identifiants | **401**, aucun contenu de jeu retourné |
| Neuf fichiers autorisés avec identifiants | **200**, tailles/hashes conformes au manifeste |
| Type de `index.wasm` | `application/wasm` |
| `ca.key`, `server.key` | **404** |
| `index.png.import`, `export_presets.cfg`, `README.md`, `project.godot` | **404** |
| Origine HTTPS loopback, contexte TLS avec CA locale explicitement fournie | Certificat vérifié, PCK conforme |

Le serveur possède une liste fermée de noms, pas un service de répertoire du dépôt. Un chemin traversant ou un fichier voisin ne devient pas un fichier autorisé. Le contenu est figé en mémoire au démarrage ; un nouveau build exige un redémarrage et un nouveau contrôle des empreintes. La correction Windows `SO_EXCLUSIVEADDRUSE` et `allow_reuse_address=False` empêche les nouveaux serveurs d'occuper simultanément le même port de test.

Le `log_message` HTTP est désactivé pour éviter d'enregistrer URL, identifiants ou adresses de testeurs dans le journal d'accès. Un point de robustesse découvert lors de cette revue — `compare_digest` sur une chaîne Authorization non ASCII — a été corrigé par le responsable : la comparaison utilise désormais des octets UTF-8/ASCII. La source corrigée a été relue ; le responsable a vérifié une réponse 401 sur ce cas. Cette garde ne vaut pas audit exhaustif d'un serveur de production.

`stop_web_test.ps1` ne vise que les PID enregistrés, après vérification du nom, de l'exécutable et des arguments attendus ; il ne tue pas globalement Python/Chrome. Son AST a été vérifié par le responsable. Il n'a pas été exécuté par cet audit pendant l'utilisation de l'accès.

Les outils TLS préparent les fichiers dans `tools/.local/`, sans fonction d'installation dans un magasin de certificats ou de modification du pare-feu. La voie effectivement choisie utilise Cloudflare, pas un profil de confiance sur l'iPhone. Les clés locales et le secret ne figurent pas dans la liste servie ni dans les candidats Git contrôlés. Cloudflare termine le TLS public et peut traiter les fichiers/identifiants temporaires, comme expliqué dans [ACCESS.md](ACCESS.md).

## Scan et limites

Snapshot : **700 fichiers candidats**, dont **570 textes décodés UTF-8/UTF-16**. Aucun motif de secret connu détecté. La valeur exacte du mot de passe temporaire est également absente des 700 fichiers candidats. Les dossiers `.local`, sorties de build, archives, caches et clés restent exclus de cet inventaire.

Le scan s'appuie sur signatures brutes et textes décodés ; il ne certifie pas une absence exhaustive de contenu secret encodé ou comprimé. Les ajouts de rapports, captures ou preuves postérieurs à ce snapshot doivent être inclus dans la clôture du responsable avant tout commit/diffusion.

Les observations sont conservées sous `artifacts/web-test/integrity-local.json` et `integrity-http.json`, ignorés par Git. Des scripts de lecture ont interrogé les références Git, comparé les octets des presets/templates/exports, inspecté l'AST Python et utilisé `urllib` avec TLS vérifié. Aucune nouvelle publication ni téléchargement de données personnelles n'a été effectué par l'auditeur.

**Avis : intégrité locale et accès protégé conformes dans ce périmètre.** Le jeu servi est le vrai export, pas une maquette. Les reçus Chrome/émulation de toucher ou une connexion HTTPS réussie **ne prouvent pas Safari sur l'iPhone**, ni le confort, la sauvegarde durable d'iOS ou cinq sessions indépendantes. Ces contrôles restent à consigner à partir des manipulations réellement effectuées ; le statut artistique/commercial demeure HOLD.
