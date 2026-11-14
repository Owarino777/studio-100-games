# Performances et limites de mesure

APK SHA256 `7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1`, inchangé depuis la recette. Godot 4.7.2 Standard / Compatibility. Les observations applicatives ci-dessous proviennent de la recette Android conservée, pas d'un nouveau benchmark physique.

Plateforme : Studio_API_36, Android 16/API 36 x86_64, écran 1080×2400/densité 420, rendu GPU host via OpenGL ES 3.1 / Android Emulator Translator / NVIDIA RTX 4060 Laptop, pilote 621.24. L'émulation et la puissance du GPU hôte ne représentent pas un téléphone.

| Mesure | Observation | Limite |
|---|---:|---|
| Repos après échauffement, 11 s, 540 intervalles | Compteur 60 FPS ; p50 16,686 ms ; p95 18,118 ms | Intervalles muraux après 60 images ; plafond moteur 60 FPS, pas temps GPU pur |
| Coût du rendu au repos | 23 draw calls | Le viewport 3D est en cache ; ne prédit pas le coût du trajet |
| Pendant animation et enregistrement | Relevé 55 FPS / 460 draw calls ; p95 mural 18,858 ms | Fenêtre roulante mêlant plusieurs états ; capture et émulateur participent au coût |
| Mémoire | 55 563 880 octets statiques Godot ; PSS 201 777 KiB | Snapshot de processus, pas plafond d'endurance |
| Lancement | `am start -W TotalTime` 960 puis 573 ms ; premier framebuffer 1 527 puis 1 552 ms après `_ready` | Départs de chronométrage différents ; pas délai complet icône → jeu prêt |

Décodage complet de l'enregistrement : **7,95 s**, H.264, **720×1600**, **430 images**, PTS croissants, aucune piste audio. Intervalles entre PTS : médiane 16,70 ms, p95 33,267 ms, maximum 67,022 ms ; 21 intervalles dépassent 33,4 ms. Ce sont les horodatages de la capture encodée. Ils montrent une cadence irrégulière du fichier, **sans isoler une saccade du moteur, un retard tactile ou une cause GPU**. Ne pas annoncer « vidéo à 60 FPS constants ».

Le décodeur termine avec code 0. Les pistes de métadonnées Android à durée nulle sont écartées lors de l'analyse vidéo ; aucun réencodage n'est fourni comme original. Les logs applicatifs de recette n'ont pas d'erreur Godot `ERROR:`/`SCRIPT ERROR` ni d'exception fatale détectée. Les avertissements de cache shader recompilé et `ashmem` déprécié sont conservés dans le dépôt ; aucun zéro-avertissement n'est prétendu.

Les contrôles techniques historiques sont 36 bootstrap, 137 modèle, 476 UI, 386 assertions géométriques ; Android 67/67 et ratios supplémentaires 28/28. Ce sont des assertions/outils, pas des joueurs ni une validation artistique. Les ratios Android réellement exercés sont 1080×2400, 720×1280 et 1200×1600 ; les cinq formats Windows ne prouvent pas une prise en main Android paysage.

Non mesurés : téléphone physique/ARM64 réel, confort à une main, encoches/navigation gestuelle réelle, TalkBack, écoute audio, haptique, batterie, température, endurance, iOS et préférence de joueurs indépendants. L'analyse temporelle par images échantillonnées ne remplace pas une séance jouée. Choisir un appareil de référence et un budget avant tout verdict de performance mobile.
