# Installer l'APK existant sur un téléphone ARM64

APK : `games/001-switchworks/build/android/switchworks-archipel-polish-debug.apk` — debug privé, version `0.1.1-polish.4` / code 6. **Ne pas reconstruire ou signer une nouvelle version pour cette campagne.** SHA256 : `6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965`.

Prérequis du téléphone : ARM64 (`arm64-v8a`), Android API 24 minimum et GLES 3.0 déclaré. Ces métadonnées ne garantissent pas le vrai rendu, le pilote, la fluidité ou le confort. Il faut encore ouvrir et observer l'application sur le téléphone.

## Chemin conseillé — USB et ADB déjà présent

Le propriétaire prépare lui-même le téléphone de test : câble de données, déverrouillage, options développeur/débogage USB si nécessaire et autorisation RSA de **ce PC**. Les étapes officielles et les éventuels besoins de pilote Windows sont décrits par [Android Developers](https://developer.android.com/studio/run/device). Aucun réglage de sécurité ni pilote n'est modifié automatiquement ; une installation de pilote ou une autre modification système sensible reste à faire approuver séparément.

Depuis la racine du studio :

```powershell
# Inspection seulement, aucune installation ou ouverture du jeu.
python games/001-switchworks/tools/install_physical_android.py inspect

# Reprendre EXACTEMENT l'identifiant local affiché pour le téléphone choisi.
python games/001-switchworks/tools/install_physical_android.py inspect --serial IDENTIFIANT_DU_TELEPHONE
python games/001-switchworks/tools/install_physical_android.py install --serial IDENTIFIANT_DU_TELEPHONE
python games/001-switchworks/tools/install_physical_android.py launch --serial IDENTIFIANT_DU_TELEPHONE
```

`IDENTIFIANT_DU_TELEPHONE` est un exemple à remplacer, pas une valeur fournie. Aucun appareil n'est choisi automatiquement, même si un seul est connecté. L'inventaire affiche l'identifiant pour cette sélection locale ; les reçus de travail n'enregistrent qu'un digest. Ne pas recopier cet identifiant dans les fiches joueurs ou un dépôt public.

Le script recherche le SDK installé (`ANDROID_HOME`, `ANDROID_SDK_ROOT`, puis emplacement utilisateur standard). Il utilise le port ADB 5037 sans tuer un serveur ou reconnecter les appareils. Un autre serveur déjà choisi par l'opérateur peut être précisé par `--port`. Il ne lance pas d'émulateur, ne fait pas de pairing réseau et refuse les indicateurs d'émulation.

Les commandes d'installation/mise à jour et de démarrage sont celles de [l'outil ADB officiel](https://developer.android.com/tools/adb). L'option `-r` conserve les données. Le script vérifie le SHA de l'APK local, l'ABI/API/GLES du téléphone, le code installé, puis le SHA de son `base.apk` après installation et avant lancement. Il refuse un code supérieur à 6, des splits inattendus ou un APK installé différent. Le package et le composant de lancement sont figés ; aucune commande n'agit sur un autre paquet.

Un reçu local horodaté est écrit sous `games/001-switchworks/artifacts/user-tests/physical-install-*.json`. `completed` pour l'installation signifie seulement installation technique confirmée. Le lancement signifie seulement activité démarrée : **ce n'est ni un contrôle du rendu ni un test joueur réussi**. `inspect` sans téléphone peut terminer normalement en indiquant zéro appareil et `installation: not attempted`.

## Si le téléphone n'est pas prêt

| Constat | Action du propriétaire, sans contournement automatique |
|---|---|
| Aucun appareil | Vérifier câble de données, déverrouillage et connexion USB ; relancer `inspect`. |
| `unauthorized` | Lire et accepter soi-même l'autorisation USB si le PC est reconnu ; le script n'accepte aucune clé à votre place. |
| `offline` | Vérifier câble/état du téléphone. Ne pas tuer tous les serveurs ADB ou réinitialiser les autres appareils. |
| Pilote Windows manquant | Consulter le constructeur et faire approuver l'installation système ; aucune réinstallation du SDK n'est nécessaire par défaut. |
| ABI/API/GLES insuffisant ou non vérifiable | Choisir un appareil compatible ; ne pas déclarer une exécution physique depuis l'émulateur. |
| Signature incompatible / `INSTALL_FAILED_UPDATE_INCOMPATIBLE` | Arrêt. Préserver l'application et ses données ; ne pas désinstaller pour contourner la signature. |
| Version installée plus récente | Arrêt, arbitrage du propriétaire ; aucun downgrade forcé. |
| `base.apk` non lisible, emplacement atypique ou `sha256sum` indisponible | Traçabilité non vérifiée : arrêt explicite du helper. Demander une vérification technique adaptée, pas une désinstallation ou un accès root. |
| Stockage, lancement ou écran noir | Conserver l'erreur et noter un incident technique, sans le convertir en réponse utilisateur. |

Le script n'emploie ni `pm clear`, ni désinstallation, ni `adb root`, ni changement de densité/taille ou de paramètres système. Il ne remplace pas les clés de signature et ne demande pas de désactiver une protection du téléphone.

## Sans ADB, transfert local manuel possible

Le propriétaire peut copier **ce même fichier APK** au téléphone par USB et l'ouvrir avec son gestionnaire de fichiers. Les autorisations d'installation depuis cette source restent des actions manuelles, limitées à une source reconnue ; ne pas désactiver globalement les protections. Aucun hébergement, lien public ou envoi de fichiers n'est créé par cette préparation. La vérification du fichier, de sa version et du rendu reste à consigner ; ce chemin n'a pas été exécuté ici.

## Mise en place avant un participant

Ouvrir le jeu hors de sa vue, contrôler visuellement Archipel Postal et l'absence d'erreur, puis utiliser **Pause → Recommencer**. Vérifier zéro rotation/essai et les deux colis au départ ; ne pas vider les données. Consigner les préférences et dimensions physiques réellement utilisées. Ne pas montrer au joueur la solution, la vidéo ou le concept avant ses réponses spontanées.

Le rendu, le toucher et les cinq sessions restent **non exécutés** tant que le téléphone et les personnes ne sont pas effectivement présents. Branche et commit de référence restent inchangés ; aucun déploiement store.
