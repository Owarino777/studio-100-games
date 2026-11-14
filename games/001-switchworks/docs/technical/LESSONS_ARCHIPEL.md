# Enseignements vérifiés de la tranche Archipel

14 novembre 2026. Ces constats concernent cette tranche et ce poste ; ils ne deviennent pas automatiquement des normes pour les 100 jeux.

1. **Lire les règles avant les pixels.** Le scénario 6×6 et les deux ports sont des données ; la vue anime des résultats. Des captures attrayantes ne peuvent pas valider la connectivité ou remplacer le moteur.
2. **Une variation de fonte doit être réellement appliquée.** Les premières lettres étaient trop fines malgré un poids demandé. Le tag OpenType entier obtenu par `TextServer.name_to_tag("wght")` a rendu la graisse attendue ; le vrai fichier Nunito et son OFL sont conservés.
3. **Mesurer les glyphes à l'écran.** `font_size=64` dans un `Label3D` ne signifie pas 64 pixels de téléphone. Projection, `pixel_size` et échelle ont d'abord rendu les A/B illisibles. Une seule enseigne par station et un badge sur le colis remplacent les codes redondants empilés.
4. **La matière est un système.** Le papier chaud multiplié par la teinte d'un toit ternissait l'azur ; un grain blanc pour les papiers colorés et un albedo chaud pour le kraft séparent ces rôles. Les surfaces pâles ont besoin de marge d'exposition et d'une inspection native.
5. **Le sens de rotation doit être partagé.** N/E/S/W et la rotation horaire du modèle correspondent à une rotation Y négative dans la vue 3D. Animer par rapport à l'angle courant évite des sauts sur les coudes déjà orientés.
6. **Un port est une géométrie, pas seulement une étiquette.** Les sources à l'est et réceptions à l'ouest sont réellement raccordées, à la même hauteur que les voies. Un test géométrique complète l'inspection des silhouettes.
7. **Cache statique et monde animé sont deux régimes.** Le plateau ne change pas entre les actions ; il peut rester dans son viewport mis en cache. Toute mutation et reprise de surface Android invalide ce cache ; les déplacements et tweens gardent un rendu continu.
8. **Tester l'interface dans ses états réels.** Recommencer et les préférences appartiennent à Pause, pas à l'écran initial. Les tailles minimales natives des boutons et labels ont révélé un dépassement inférieur et un bilan trop long, corrigés après captures et tests.
9. **L'intervalle mural est distinct du delta moteur.** Un delta lissé proche de 16,67 ms ne suffit pas à établir la cadence vécue. Les métriques finales précisent le contexte de chauffe, le plafond de FPS et la plateforme ; un émulateur n'est pas un téléphone physique.
10. **La recette est un livrable.** Les touchers ADB, snapshots du seul package expérimental, PNG binaires, logs par PID et empreintes permettent de relier les affirmations à un APK. Les contrôles négatifs restent séparés des passages positifs.
11. **Attention au texte envoyé à un programme natif.** Un titre JSON avec accent est devenu `?` dans un pipeline PowerShell 5.1 ; la source a été corrigée en UTF-8. Conserver les originaux, préférer les écritures UTF-8 explicites et vérifier les métadonnées visibles.

Les limites humaines, physiques et commerciales restent celles du [rapport](../vertical-slice/REPORT.md). Le code partagé entre jeux ne sera extrait qu'après un deuxième usage démontré, pas à partir de cette seule expérience.
