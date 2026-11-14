# Anomalies à confronter aux observations humaines

**Ne pas lire avant les tâches de première impression.** Les tests fonctionnels réussis ne donnent pas une note artistique. Les constats ci-dessous sont des avis techniques documentés ; les conséquences sur de nouveaux joueurs restent à mesurer.

Bloquant : empêche l'action ou la lecture essentielle. Majeur : affaiblit une information essentielle ou l'identité, à corriger ou à arbitrer avant acceptation. Mineur : polissage local sans impasse démontrée. **Aucun bloquant certain observé dans ce lot** ; cela ne couvre pas tous les appareils ou usages.

## Six groupes de défauts majeurs

| Groupe / références d'audit | Preuve visuelle non retouchée | Constat et contrôle de réparation proposé |
|---|---|---|
| **F01 — Matières et cohérence** (IA-01, IA-05) | [Entrée](media/01-entree-preparation.png), [concept B](reference/B-concept.png) | Tuiles proches d'aplats crème, plis et glaçure discrets ; ciel pictural, HUD lisse et objets facettés ne partagent pas encore une finition commune. Faire reconnaître porcelaine/papier/kraft sans nommer ces matières, puis comparer la cohérence d'un seul écran natif amélioré. Ne pas ajouter du détail qui gêne les ports. |
| **F02 — Ombres et contours** (IA-02) | [Entrée](media/01-entree-preparation.png) | Ombres sombres et dentelées des pavillons et fleurs, opposées à la douceur du ciel. Repères dans le PNG 1080×2400 : pavillon A gauche x≈150–250/y≈1000–1190 ; fleur gauche x≈55–150/y≈1660–1790. Vérifier un réglage d'éclairage/ombre sur les vrais ratios, puis sur téléphone physique, avec coût mesuré. |
| **F03 — Rails** (IA-03) | [Gameplay](media/02-gameplay.png), [réussite](media/03-reussite.png) | Doubles profils fins et traverses blanches très répétitives. Les routes se suivent, mais le rythme rayé concurrence la bande de rail ; B paraît brun face au toit corail. Tester largeur/relief/contraste sans modifier les ports ; suivre A/B à taille réelle et en niveaux de gris. Aucun échec joueur n'est déjà démontré par cette observation. |
| **F04 — Rôles des stations** (IA-04, UX-01) | [Entrée](media/01-entree-preparation.png), puis [trajet](media/02-gameplay.png) | Silhouettes et enseignes quasi identiques à gauche et à droite ; le colis initial est l'indice principal de départ. Faire nommer deux départs et deux réceptions après 3 s, avant explication. Décider d'une différence sobre de rôle, conservant les adresses A/B et les ports physiques. |
| **F05 — Guidage de reprise** (UX-02) | [Préparation restaurée](annexe/reprise-preparation.png) | Le réseau est déjà raccordé, avec six rotations et un essai, mais la consigne est « Tournez les voies ». Le code confirme une consigne générique après rechargement. Faire annoncer la préparation retrouvée et une action cohérente avec son état. La phase de planification après redémarrage est conforme au contrat ; le défaut est le guidage. |
| **F06 — Réception peu caractérisée** (IM-01) | [Vidéo réelle](media/04-gameplay-android.mp4), fin du trajet vers 1,77–2,20 s | Les colis restent posés devant le porche ; un tassement bref (4 % / 180 ms dans le code) et le bilan portent surtout le résultat. Le second regard estime ce geste trop peu caractérisé pour l'identité postale. Faire percevoir la réception propre à chaque quai avec un retour local sobre ; comparer en jeu réel, conserver la variante réduite et ne pas retarder les commandes. C'est un jugement artistique à arbitrer, pas une erreur logique démontrée. |

F01 regroupe deux observations liées ; les lignes ne représentent pas six refontes indépendantes ni un calcul de budget. Le second regard juge identité/cohérence/finition/fidélité à **2/4** et lecture statique à **3/4**, dans son lot. Ces notes ne remplacent pas des observations humaines.

## Points mineurs ou à confirmer

- **Hiérarchie** : marque et compteurs imposants, grands vides et répétition des consignes. Preuve : entrée. Tester la priorité du but et du premier geste, sans réduire les cibles tactiles.
- **Signalétique petite** : cercle/triangle de colis peu saillants au petit format malgré des lettres visibles. L'efficacité réelle à faible luminosité ou avec capacités visuelles variées n'est pas mesurée par ce kit 1080 px.
- **Victoire** : formulation provisoire « essai(s) » et sélection encore visible dans le PNG de réussite. Ne pas en déduire sa persistance à tous les instants de la vidéo.
- **Décor** : fleurs simplifiées, facettes nettes ; elles restent hors des ports. Leur enrichissement n'est pas prioritaire sur la lecture.
- **Aide pendant trajet** (IM-02) : le pied « Touchez une voie » reste affiché alors que la simulation verrouille l'édition. Les boutons désactivés indiquent l'état, mais le guidage devrait rester cohérent. Preuve : vidéo vers 0,51–1,77 s et capture de gameplay.
- **Orientation des colis** : le maintien des badges face à l'écran peut servir la lecture ; leur orientation fixe n'est pas automatiquement un défaut. Le choix reste à observer en jeu réel.
- **Bord inférieur** : proximité de l'aide au bord dans les petits formats de la recette. Occultation par une vraie navigation gestuelle non démontrée ; essai physique nécessaire.

## Portée de la vidéo

La vidéo montre départ volontaire, deux trajets et réussite, puis plusieurs secondes de bilan statique. Elle ne montre ni les rotations précédentes, ni l'erreur, ni la reprise, ni le mode de mouvement réduit. Aucun son n'est enregistré. Le fichier a été décodé entièrement (430 images) et examiné par échantillons avec leurs horodatages ; **aucune sensation humaine de fluidité, latence ou toucher n'en est certifiée**. Voir les limites de cadence dans le document de performances.
