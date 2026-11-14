# SWITCHWORKS — Brief de tranche verticale native après sélection

Date : 14 novembre 2026. **Document de préparation, aucun gameplay ajouté par ce brief.** Le propriétaire doit encore choisir A/B/C, accepter les corrections de la direction et arrêter le périmètre. Le statut commercial reste TEST/HOLD. Ne pas assimiler la mire Godot existante à un portage du prototype G3.

## Entrées conservées et inconnues

- Socle : Godot 4.7.2 Standard, GDScript typé, Android sur Windows, iOS sur macOS ultérieurement ; [ADR 0001](../../decisions/0001-socle-godot-mobile.md).
- Règles héritées : G1 p. 2, G2 p. 3, G3 p. 2 ; voir [synthèse](../../SYNTHESE_REFERENCE_SWITCHWORKS_2026-11-14.md).
- Sources HTML/JS, `levels.json`, tests et schéma de sauvegarde historiques absents des archives fournies : les retrouver si possible. Ne pas fabriquer un convertisseur ni annoncer les anciens niveaux restaurés.
- Garder la scène `verification.tscn`, ses tests et tous les prototypes. La tranche aura des scènes de gameplay supplémentaires, sans écraser la mire ni modifier silencieusement le démarrage de référence.
- Une image pleine page n'est pas une famille d'assets. Les concepts sont des références de matière et d'intention ; ils ne sont ni le plateau ni le HUD de production.

## Périmètre proposé à confirmer

Trois micro-niveaux **nouvellement rédigés**, chacun avec une solution vérifiée : un flux/droite-coude ; double flux A/B ; signal partagé fixe avec délai 0–4. Le troisième peut être reporté uniquement par décision explicite, car il porte l'hypothèse de synchronisation. Pas de reprise supposée des 18 niveaux historiques.

Livrer une boucle courte : choisir le niveau → préparer → expédier → comprendre un échec ou réussir → corriger/recommencer/continuer. Ajouter pause/reprise, annulation et réglage de mouvement réduit. Aucun compte, backend, classement, boutique, publicité, achat, collecte automatique ou nouveau système monétaire.

## Contrat de gameplay à figer avant codage

| Élément | Contrat proposé issu des archives / décision restante |
|---|---|
| Plateau | 6×6, ports N/E/S/W ; droites et coudes avec deux ports ; cases vides et stations fixes ; indices invalides refusés |
| Rotation | Quart de tour de la pièce, pas bascule d'une branche ; quatre rotations rendent l'état initial |
| Simulation | Déterministe, départ volontaire, A/B simultanés dans le district 02 ; erreurs de port, destination et boucle expliquées |
| Signalisation | Croisement fixe et collision au signal au même temps ; délai entier 0–4 dans le district 03 ; ne pas inventer de règle générale de collision différente sans décision |
| Modèle et vue | Modèle de plateau sans dépendance à l'affichage ; une action renvoie un nouvel état et des événements ; la vue les anime sans décider de la réussite |
| Annulation | Restaurer exactement l'état logique précédent ; préciser la sémantique des compteurs essais/rotations/indices avant scoring, à partir des sources si retrouvées |
| Récompense | Les archives documentent étoiles et PAR ; ne pas présenter le nombre de rotations d'une solution témoin comme un minimum prouvé |
| Sauvegarde | Schéma natif versionné et écritures atomiques ; aucune compatibilité localStorage G2/G3 prétendue sans échantillons et contrat de migration |

La [planche illustrative](EXEMPLE_PLATEAU_6X6.json) fournit un premier cas témoin à deux flux : son état initial échoue, deux rotations connues raccordent les deux routes. Son validateur 7/7 est une vérification de données de conception, pas le futur moteur GDScript, ni une preuve d'optimalité.

## Familles d'assets et pipeline proposé

| Famille | Minimum à produire après choix |
|---|---|
| Plateau | Terrain 6×6, bordures/safe areas, cases vides ; décor séparé du plan interactif |
| Rails | Droite et coude, orientations, pivots centrés et ports exacts ; variantes sélection/erreur séparées ; cohérence de lumière entre orientations |
| Stations | Sources A/B orientées vers l'est, réceptions A/B à entrée ouest ; silhouette fixe et sens explicite |
| Colis | Deux silhouettes/sceaux cohérents A cercle/B triangle, lettres et teintes ; ni boîte supplémentaire sur un objectif vide, ni label seul à la place du volume |
| Signal | Croisement fixe, états de sécurité et délai uniquement pour le niveau concerné |
| HUD | Vraies fontes licenciées, texte localisable, Annuler/Expédier/Indice/Pause et focus ; aucun texte peint dans un fond |
| Feedback | Rotation, départ, réception, erreur et victoire ; son/haptique optionnels et réduction du mouvement |

Tester d'abord un rail droit, un coude et une station à la taille réelle. Comparer sprites 2D pré-rendus et petits modules 3D orthographiques si nécessaire ; décider par lisibilité, cohérence de lumière et coût mesuré, pas par une promesse de performance. Garder le renderer Compatibility tant qu'une migration n'est pas motivée et vérifiée. Pas de nouvelle dépendance d'animation sans besoin démontré.

Manifeste par asset : source/outil/licence, dimensions, alpha, pivot, orientations, états, échelle, compression, révision et statut. Les ressources générées seront contrôlées techniquement puis dans le vrai moteur ; les concepts de ce dossier ne sont pas prêts à être découpés automatiquement en sprites.

## Critères d'acceptation vérifiables

| ID | Vérification attendue avant réception de la tranche |
|---|---|
| NV-01 | Niveau initial non résolu ; solution témoin atteint chaque bonne station ; échec de connexion reproduit et expliqué |
| NV-02 | Stations fixes non rotatives ; entrée hors plateau refusée ; quatre rotations identité ; annulation restaure un hash d'état complet |
| NV-03 | Double flux déterministe ; aucune divergence entre événements du modèle, animation et résultat |
| NV-04 | Si niveau signal inclus : collision reproduite puis évitée par le délai 0–4 ; règles et ordre de résolution testés |
| NV-05 | Contrôle négatif du runner retourne non-zéro ; import et logs sans erreur de script ; les 36 contrôles bootstrap restent verts |
| NV-06 | Toucher réel de toutes les cases utiles, cibles mesurées, focus visible, clavier, safe areas ; aucun état essentiel communiqué seulement par couleur |
| NV-07 | Réserves A/B/C corrigées ; vrais contrastes du HUD et fontes vérifiés ; raccords/pivots/alpha contrôlés après import et compression |
| NV-08 | Réussite, échec, annulation, redémarrage, pause/Home/reprise et sauvegarde/rechargement observés sur l'export ; pas seulement headless |
| NV-09 | Captures du vrai build pour niveau simple, double flux, erreur, réussite et pause/reprise, avec moteur/OS/résolution/scène/commit |
| NV-10 | Temps de chargement, FPS/mémoire et consommation relevés sur Android ciblé ; limites matérielles/iOS explicitement consignées |
| NV-11 | Au moins cinq tâches sans aide observées chez des participants indépendants selon le protocole retenu ; aucun résultat synthétique présenté comme terrain |

Les seuils commerciaux et échantillons historiques restent dans le [registre produit](../../market-research/SWITCHWORKS_HYPOTHESES_ET_TESTS_2026-11-14.md). Une préférence de style ne franchit pas un gate commercial. Les budgets de performance et le niveau d'effort sont à fixer avant l'implémentation ; aucune durée ou recette physique n'est inventée ici.

## Décisions nécessaires à l'entrée du prochain jalon

1. Direction A v5, B v3 ou C v2 ; corrections associées acceptées.
2. Sources historiques à réutiliser si fournies, sinon distinction explicite des micro-niveaux nouveaux.
3. Sémantique des compteurs/annulation/PAR, sauvegarde et périmètre du signal partagé.
4. Appareil Android physique de référence et budget de production/mesure de la tranche.

La mise en œuvre native commencera sur cette base revue, sans publication distante ou dépense implicite.
