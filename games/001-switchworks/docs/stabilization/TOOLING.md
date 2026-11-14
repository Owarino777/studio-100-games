# Outillage de lecture et preuves de stabilisation

Le moteur, Git, Python et les outils de préparation déjà présents ont été réutilisés. Aucun changement système, nouvelle dépendance du jeu ou installation globale n'a été réalisé. L'interface de lecture pilotable a échoué avec `Computer Use native pipe is unavailable` ; aucun visionnage humain via ce lecteur n'est revendiqué.

FFmpeg/FFprobe, OpenCV, PyAV et imageio n'étaient pas disponibles dans les chemins/outils Python examinés. Un décodeur a donc été décompressé uniquement sous `tools/.local/review-media/imageio-ffmpeg-0.8.1/`, ignoré par Git, à partir du wheel Windows de la [distribution PyPI imageio-ffmpeg](https://pypi.org/project/imageio-ffmpeg/0.8.1/). Empreinte SHA256 vérifiée avant extraction : `f27ca4cb85e2d4946deedbce1a81245dfd942a2bcf94b53676fb3956aa95bf1b`, 38 893 483 octets. Source exacte :

```text
https://files.pythonhosted.org/packages/82/0c/a1d49f3dd2688bd750b4986f8e271ad11f8e729a896070ea25f587b44da8/imageio_ffmpeg-0.8.1-py3-none-win_amd64.whl
```

La commande réellement exécutée `ffmpeg -version` donne **9.0.2 essentials**. Le wrapper est annoncé BSD-2-Clause par PyPI ; la configuration du binaire est GPL avec `--enable-version3`. Le binaire et son wheel sont des outils d'analyse locaux, **absents du dépôt versionné, du jeu et du kit externe**. Aucune licence de ce décodeur n'est attribuée aux assets du jeu.

Avec ce binaire explicitement sélectionné, depuis la racine du studio :

```text
ffmpeg -nostdin -hide_banner -i games/001-switchworks/docs/vertical-slice/evidence/android/android-gameplay.mp4 -map 0:v:0 -vf showinfo -f null -
ffmpeg -nostdin -hide_banner -n -i games/001-switchworks/docs/vertical-slice/evidence/android/android-gameplay.mp4 -vf "select='not(mod(n,15))',showinfo" -fps_mode vfr games/001-switchworks/artifacts/stabilization/video-frames/frame-%03d.png
```

Le premier passage décode toute la piste vidéo, le second extrait 29 images sans remplacer le MP4. Les images extraites servent à la lecture temporelle ; elles ne sont pas présentées comme de nouvelles captures natives PNG. La première passe finit avec code 0. Le fichier contient deux pistes de métadonnées Android signalées à durée nulle ; elles ne sont pas une erreur de décodage de la vidéo.

Les journaux et métriques pertinents sont conservés sous `video-evidence/`, avec un manifeste SHA256. Les intermédiaires volumineux restent sous `artifacts/stabilization/`. Les outils PowerShell/Git ont requis les permissions de processus normales pour les certificats et l'accès Git du propriétaire ; aucune sécurité TLS, politique globale ou configuration d'un autre projet n'a été modifiée.
