# SWITCHWORKS — Revue privée d'Archipel Postal

**14 novembre 2026. Candidat expérimental TEST / HOLD.** Ce dossier permet de décider d'une passe de finition limitée au niveau actuel. Il ne demande pas de valider une qualité commerciale ou un jeu complet.

## Commencer sans lire les conclusions

1. Montrer `media/01-entree-preparation.png` pendant trois secondes, puis masquer. Demander le but, le premier geste et les départs/arrivées. Noter la réponse dans `GRILLE_REVUE.csv` avant toute aide.
2. Ouvrir `media/02-gameplay.png`, puis `media/03-reussite.png` et la vidéo `media/04-gameplay-android.mp4`. Les images sont des captures Android non retouchées ; la vidéo est l'enregistrement réel, sans audio, d'environ 7,95 s.
3. Pour les tâches de toucher, d'annulation ou de reprise, utiliser le vrai APK fourni séparément par le propriétaire. Ce ZIP léger n'inclut pas le build de 61 Mo. **Avec les médias seuls, marquer ces tâches CN/NE**, jamais réussies par déduction.
4. Après les réponses spontanées, comparer à `reference/B-concept.png` — illustration générée, pas capture du moteur — puis lire `ANOMALIES.md`, `PERFORMANCES_ET_LIMITES.md` et `DECISIONS_HUMAINES.md`.

La première image tient le rôle d'« accueil » de cette tranche : **entrée directe en préparation**. Il n'existe pas de menu d'accueil autonome. Aucun écran titre n'a été ajouté pour ce dossier. `annexe/reprise-preparation.png` est une quatrième capture de preuve, consacrée au défaut de guidage de reprise ; elle ne remplace pas les trois vues principales.

## Grille et méthode

`GRILLE_REVUE.csv` est un CSV UTF-8, séparateur virgule. Dupliquer une grille par participant avec un identifiant anonyme ; toutes les notes et observations sont vierges. NE = non évalué, CN = conditions non réunies, NA = non applicable avec motif. Une tâche est S sans aide, A assistée, E échouée ou AB abandonnée. Ne pas compter une solution fournie comme une résolution autonome.

Pour les critères : 0 impossible, 1 défaut majeur, 2 réserve nette, 3 clair et cohérent, 4 finition convaincante dans le contexte réellement observé. Justifier chaque note par une observation ou un timecode. Ne pas calculer une moyenne qui masque un bloqueur. Les seuils proposés sont dans `DECISIONS_HUMAINES.md` et restent à accepter avant collecte.

Le premier audit et ces seconds regards sont des revues par agents techniques, dont certains distincts des auteurs de la tranche. **Ce ne sont pas des avis humains externes ou des résultats de joueurs.** Aucun participant n'a été recruté ou contacté. Lire les anomalies avant les tâches biaiserait la première impression.

## Provenance et intégrité

Godot 4.7.2 Standard, scène `res://scenes/archipel_postal.tscn`, package debug `org.studio100games.switchworks.archipel.slice`. APK SHA256 : `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1`. Captures : Studio_API_36, Android 16/API 36 x86_64, écran 1080×2400. La vidéo seule est en 720×1600. Aucun pixel des PNG, aucun timing ni piste de la vidéo n'a été retouché ou réencodé pour ce dossier.

`PROVENANCE.json` conserve les empreintes et les chemins relatifs des sources originales. Le ZIP ajoute `REFERENCE_GIT.txt` et `ZIP_MANIFEST.json` après le commit local, pour identifier la version exacte et vérifier tous ses fichiers. L'archive reste locale ; sa création ne constitue pas un envoi ni une publication.

Le concept, les trois textures de jeu générées et les créations natives ont une provenance documentée dans le dépôt. Fonte Nunito Sans : SIL OFL 1.1 ; notices Godot conservées dans le jeu. Les droits commerciaux des images générées restent à préciser avant diffusion commerciale. Aucun moteur, exécutable de décodeur, secret, journal brut de poste ou clé de signature n'est inclus dans ce kit.
