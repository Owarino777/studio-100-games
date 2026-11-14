# Stabilisation et revue indépendante — référence locale

14 novembre 2026. **HOLD pour l'acceptation artistique/UX ; TEST / HOLD pour le produit.** Le niveau actuel est fonctionnel, assez lisible pour être évalué, et ne justifie pas encore une extension du gameplay. Une passe de finition limitée au même écran est défendable après arbitrage humain des réserves.

## Version protégée

La branche est `feat/archipel-postal-vertical-slice`. Le parent avant ce gel et la référence `main` sont `68548a4b004a047e43d9ce0c77f248ffc07af23d`. Le commit local de référence contient la tranche, les preuves historiques et ce dossier. Son identifiant exact est obtenu avec `git log -1 --format=%H` et ajouté au ZIP partageable dans `REFERENCE_GIT.txt` après commit. Aucun push, déploiement ou changement de `main` n'est autorisé par ce dossier.

L'APK de référence reste `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1`. **Aucun script de gameplay, niveau, scène, matériau ou texture n'a été retouché pendant cette stabilisation.** Le build Android et ses rapports originaux sont conservés. La recette initiale décrit un état alors non commité ; elle reste une preuve historique, pas la description du statut Git après ce gel.

Deux anomalies de sécurité/intégrité locales ont été corrigées avant staging : exclusions de fichiers privés insuffisantes dans `.gitignore` et normalisation CRLF/LF qui aurait invalidé 11 preuves et cinq entrées du manifeste runtime après checkout. Les règles `-text` ciblées préservent leurs octets. Le recontrôle indépendant couvre **60 preuves + 32 sources gelées**, avec Git et SHA256 ; cinq exclusions sensibles passent. Voir [audit de sécurité](SECURITY_AND_REFERENCE.md).

## Avis artistiques distincts de la recette

| Relecture | Conclusion et portée |
|---|---|
| [Second regard statique](INDEPENDENT_ART_AUDIT.md) | Trois concepts A/B/C et cinq vrais PNG Android ; cinq anomalies majeures, trois mineures ; lecture 3/4 mais identité/cohérence/finition/fidélité 2/4 |
| [Second regard UX](INDEPENDENT_UX_AUDIT.md) | Deux majeures dont la distinction départ/réception et le guidage trompeur d'une préparation restaurée ; trois mineures ; cinq tâches proposées sans résultat humain |
| [Complément temporel](INDEPENDENT_MOTION_AUDIT.md) | Décodage et images échantillonnées de la vidéo réelle ; réception peu caractérisée jugée majeure, aide de rotation en trajet jugée mineure ; cadence et sensations distinguées |

Les relecteurs sont des agents distincts des auteurs de la tranche, avec contexte partagé. Ce n'est ni un test aveugle ni une revue humaine externe. Les constats ne deviennent pas des réponses de joueurs. Les notes plus exigeantes que celles de la première revue ne réécrivent pas cette ancienne revue ; elles rendent le désaccord inspectable.

**Aucun bloquant certain de lecture ou de parcours n'est démontré dans le lot**, sans garantie pour tous les appareils. Les anomalies majeures restent ouvertes : matières/cohérence, ombres/crénelage, rails, rôles des stations, guidage de reprise et caractérisation de réception. Certaines se recoupent. Les critères de réparation proposés ne sont pas des résultats déjà obtenus. Aucun test fonctionnel vert ne ferme ces points.

## Dossier externe léger

Le [kit autonome](review-kit/README.md) comprend trois PNG Android principaux non retouchés, une vidéo originale de 7,95 s, une capture annexe de reprise, le concept B explicitement étiqueté, la grille vierge, les anomalies, performances/limites et décisions humaines. Il n'embarque ni APK, ni SDK, ni logs bruts de poste. Les concepts A/C examinés restent dans le dossier artistique du dépôt ; le kit est centré sur B.

L'« accueil » fourni est l'entrée actuelle en préparation, sans menu d'accueil autonome inventé. Avec les seuls médias, les critères de toucher, interruption ou mouvement réduit restent CN/NE ; une revue interactive exige le vrai APK fourni séparément par le propriétaire. Aucun participant n'a été contacté et rien n'a été envoyé.

Préparer les copies/manifeste, puis après commit produire le ZIP local avec les outils standard existants :

```powershell
python games/001-switchworks/tools/prepare_review_package.py prepare
python games/001-switchworks/tools/prepare_review_package.py bundle --output games/001-switchworks/build/delivery/switchworks-archipel-revue-externe-20261114.zip
```

Le second mode exige un arbre propre sur la branche dédiée, `main` inchangé et un nouveau nom de ZIP. Il ajoute le SHA Git et un manifeste, vérifie CRC et octets, sans publication. Les médias copiés doivent rester strictement identiques à leurs originaux. Les nouveaux ZIP ne remplacent pas l'ancienne archive source.

## Contrôles et limites

Le moteur Godot 4.7.2 Standard a été relancé sur Windows : vrai framebuffer 390×844 enregistré et inspecté, code 0, pas d'erreur de script détectée. Les tests de référence et leurs sorties sont conservés dans `reference-evidence/`. Les résultats Android historiques 67/67 et 28/28 restent ceux de la recette, sans nouvelle mesure physique inventée.

Le contrôle des blobs préparés pour commit a passé 109 comparaisons d'empreintes de manifestes et un scan des fichiers changés (155 chemins, 118 textes décodés) sans motif de secret détecté. Le contrôle Git de blancs par défaut signale les CRLF, sorties brutes et espaces du texte OFL conservés : ces preuves et notices ne sont pas reformatées pour masquer ces avertissements. Le contrôle limité au code et Markdown rédigés, avec CR de fin de ligne admis et blancs de fin de fichier conservés, retourne 0. Les limites des scans par motifs restent applicables.

La vidéo originale a été décodée intégralement : 430 images, PTS croissants ; 29 échantillons extraits et lecture visuelle de passages clés, puis relecture indépendante de dix échantillons. Médiane/p95/max des intervalles encodés : 16,70/33,267/67,022 ms. Ce n'est ni une mesure de latence ni un profil GPU. La rotation, l'échec, la reprise et le mouvement réduit ne sont pas montrés par ce clip. Les outils et métriques sont documentés dans [TOOLING.md](TOOLING.md) et `video-evidence/` ; aucune lecture humaine en temps réel ou écoute n'est prétendue.

Les droits commerciaux des images générées, la perception réelle des matières, l'usage physique et l'iOS restent ouverts. Les cinq tâches et seuils de décision proposés doivent être acceptés avant collecte ; pas de note globale masquant un bloqueur. Le propriétaire doit choisir l'appareil et le budget de finition, et les relecteurs humains doivent motiver GO finition limitée / HOLD / révision. Une préférence artistique ne valide pas le marché.
