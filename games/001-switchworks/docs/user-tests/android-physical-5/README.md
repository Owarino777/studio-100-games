# Préparer cinq tests Android physiques

**Décision actuelle : GO pour les tests physiques ; HOLD artistique final et commercial. Aucun joueur testé, aucun résultat humain réussi.** La [revue finale](../../polish/REVUE_EXTERNE_FINALE_2026-11-14.md) a été lue intégralement. Elle remplace la précédente critique comme référence de cette décision ; ses limites de revue sur médias sont conservées.

Référence inchangée : branche `fix/archipel-postal-finition-p1-p2`, commit **`108e2b04a3109f8f67d00a65caf0d60d7f1c979e`**. Aucun changement de jeu, niveau, texture ou test Godot. Les présents documents/outils sont des ajouts de préparation non committés : la référence Git n'est pas avancée.

## À utiliser dans cet ordre

1. [Installation et constat technique](INSTALLATION.md) : préparer le téléphone hors de la vue des participants.
2. [Protocole non guidé](PROTOCOLE.md) : mêmes consignes, une première exposition par personne ; lecture des rôles, rotations, erreurs, réception et avis visuel, puis Home/pause et conditions physiques séparées.
3. [Fiche individuelle](FICHE_OBSERVATION.md) : une copie par P01–P05, sans identité nominative. Cinq copies de travail vierges sont préparées sous `artifacts/user-tests/` ; aucune n'est une observation réalisée.
4. [Résultats détaillés vierges](resultats.csv) et [journal tactile vierge](evenements_tactiles.csv). UTF-8, séparateur virgule ; importer comme texte/CSV si le tableur attend un autre séparateur. Les cinq lignes restent `NE`, toutes les mesures vides. La [synthèse courte](synthese_5_joueurs.csv) reprend les indicateurs principaux sans remplacer les observations détaillées.

Les seuils sont **proposés avant collecte**, à confirmer avant de voir les réponses. Une préparation assistée ne devient pas une résolution autonome ; une erreur logique n'est pas une erreur tactile. Cinq cas qualitatifs ne valident pas un marché. Les décisions de contenu ou publication ne sont jamais automatiques.

## État constaté sur ce poste

- APK existant vérifié : **61 448 663 octets**, SHA256 `6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965` ; API 24+, GLES 3.0, bibliothèques ARM64. [Vérification locale](VERIFICATION_INSTALLATION.md).
- ADB existant détecté ; inventaire réel du serveur 5037 : **aucun appareil connecté** au passage de préparation. Aucune installation ni ouverture sur un téléphone n'a été effectuée.
- Le script d'installation est prêt à être utilisé après branchement et autorisation USB par le propriétaire. Son inspection locale et ses contrôles d'outillage ne sont pas des tests physiques ou humains.

Les données collectées réelles et enregistrements autorisés vont dans `games/001-switchworks/artifacts/user-tests/`, ignoré par Git. Les gabarits de ce dossier restent vierges. Aucun recrutement, message, upload, push GitHub ou publication store n'a été réalisé.
