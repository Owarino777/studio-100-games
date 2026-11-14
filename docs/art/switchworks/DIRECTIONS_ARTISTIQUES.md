# SWITCHWORKS — Trois directions artistiques à comparer

14 novembre 2026. **Concepts non implémentés, sans choix de direction encore accepté.** Les trois écrans représentent une proposition de gameplay mobile, pas un rendu Godot ni une fonctionnalité livrée. Le code et les 36 tests du bootstrap restent conservés. La [synthèse historique](../../SYNTHESE_REFERENCE_SWITCHWORKS_2026-11-14.md) fixe ce qui est documenté et ce qui reste à valider.

## Comparaison visuelle

[Planche des trois directions finales](concepts/comparaison-finale.png) — ouvrir les écrans individuels pour juger la lecture au téléphone :

| A — Atelier 17, précision claire | B — Archipel Postal | C — Nuit de Service |
|---|---|---|
| [Écran A v5](concepts/a-atelier-17-v5.png) | [Écran B v3](concepts/b-archipel-postal-v3.png) | [Écran C v2](concepts/c-nuit-de-service-v2.png) |
| Aluminium clair, polymère cobalt, geste précis | Porcelaine, papier et lumière aérienne | Graphite, métal et présence nocturne |
| Alternative contemporaine au bois/laiton écarté | Prolonge la chaleur/céramique de G3 | Réinterprète l'intention nocturne de G2 |

Les versions précédentes sont conservées dans `concepts/` et classées dans le [manifeste](asset-manifest.json). Les V1 sont hors référence mécanique ; A v2/v4 ont sept rangées ; l'ancien A bois/laiton a été écarté après comparaison avec Parcel Flow. Les versions finales corrigent ces écarts. Les numéros v5/v3/v2 sont des itérations d'images, **pas les versions historiques G1/G2/G3**.

Les [contrôles raster](RASTER_QA.json) passent sur les 12 fichiers PNG (10 rendus conservés et 2 planches), avec format, dimensions réelles et décodage vérifiés. Ces images opaques ne nécessitent pas d'alpha ; elles ne sont pas des sprites prêts à importer. Le manifeste conserve empreintes, provenance, prompts et limites. Le [validateur de la planche](validate_reference_board.py) est reproductible en Python standard et passe 7/7 contrôles de données ; aucun de ces contrôles n'exécute le futur gameplay.

## Art bible commune à cette étude

- **Règle visible :** grille 6×6 ; droites/coudes à deux ports ; rotation 90° ; stations fixes ; deux colis A/B, départ volontaire. Pas de Y/T pivotant, troisième flux, compte à rebours ou nouveau geste de tracé.
- **Scénario :** [NATIVE-EXEMPLE-01](EXEMPLE_PLATEAU_6X6.json), une nouvelle topologie illustrative, pas un niveau historique retrouvé. Deux rotations corrigent les routes ; l'image montre la préparation terminée, zéro livraison sur deux, avant « Expédier ». Le JSON est la référence des connexions, jamais les pixels générés.
- **Hiérarchie :** mission/compteurs en haut ; plateau dominant ; « Annuler / Expédier / Indice » dans la zone du pouce. Carte des niveaux, réglages et pause seront natifs après sélection, sans boutique ou monnaie non prévue.
- **Repères :** A bleu + cercle + lettre ; B corail + triangle + lettre. Source avec sortie fléchée ; réception avec entrée orientée vers le rail. Aucun état ou colis ne dépend exclusivement de la couleur.
- **Cadre natif proposé :** portrait 390×844 unités de référence, vérification à 360×640 et 412×915, safe areas réelles ; cibles d'action d'au moins 48 unités logiques à mesurer sur appareil. Les PNG conceptuels font environ 830×1894/1895 et ne sont pas des maquettes cotées de ces écrans.
- **Assets :** objets séparés avec états normal/sélectionné/invalide, ombre/éclairage cohérents, pivot au centre de case. Le HUD sera du vrai texte dans des contrôles Godot ; aucune image complète ne sera utilisée comme faux gameplay ou interface figée.

## A — Atelier 17 : précision claire

**Intention :** comprendre une machine compacte, nette et manipulable. La famille finale remplace complètement le premier atelier antique ; elle ne conserve ni son bois, ni ses plaques ivoire/laiton, ni le plateau pétrole.

| Élément | Spécification proposée |
|---|---|
| Palette | Brouillard `#E7ECF0` pour châssis ; encre `#182735` pour texte ; cobalt `#3153BD` pour commandes/modules ; vermillon `#E87555` pour colliers de raccord ; chartreuse `#CBD68B` réservée à de petits repères décoratifs |
| Typographie | IBM Plex Sans Condensed pour titres courts ; Plex Sans pour aide ; Plex Mono pour compteurs. Corps ouverts et chiffres tabulaires, pas de lettrage rétro. [OFL officielle](https://raw.githubusercontent.com/IBM/plex/master/LICENSE.txt) |
| Rails | Deux profilés aluminium brossé, joints et colliers vermillon ; droites et coudes géométriquement identiques aux autres directions ; pas de levier distinct de la tuile pivotante |
| Colis | Boîte rigide kraft avec bande technique et sceau A/cercle ou B/triangle ; silhouette courte, badge au-dessus ; un seul colis par source |
| Stations | Modules polymère cobalt, face étiquetée et connecteur latéral ; les réceptions se lisent comme logements vides, pas comme colis supplémentaires |
| Environnement | Châssis alliage poudré, joints fins et marquage sérigraphié ; aucun décor à l'intérieur des cases libres ; lumière froide diffuse et ombre douce |
| HUD | Bouton principal cobalt/texte blanc ; secondaires encre sur gris ; compteurs encastrés avec séparation nette et sans monnaie factice |
| Mouvement propre | Rotation crantée 140–180 ms, légère compression du bouton, arrêt mécanique exact ; réception avec petit verrou et son bref optionnel |
| Faisabilité Godot | 2D pré-rendue ou petits modules 3D orthographiques ; coût raisonnable si les reflets sont contenus. En pré-rendu, produire les orientations avec une lumière fixe : tourner une ombre peinte avec le rail serait incohérent |
| Réserve de sélection | Les crochets blancs sur tuile grise et les rails argentés doivent gagner un contour encre. Le changement d'identité réduit la proximité observée avec Parcel Flow, sans prouver une exclusivité commerciale ou juridique |

Cinq signes propres à défendre : modules cobalt, joints vermillon fonctionnels, châssis clair monobloc, signalétique de précision, réception à connecteur latéral. Ils ne suffisent pas, seuls, à prouver la différenciation du jeu.

## B — Archipel Postal : objets de courrier précieux

**Intention :** résoudre un petit système de livraison calme, tactile et chaleureux. Continuité proposée avec la céramique et la petite ville G3, sans prétendre que l'archipel ou les nuages étaient déjà approuvés.

| Élément | Spécification proposée |
|---|---|
| Palette | Porcelaine `#F5EFE2`, encre `#203C56`, céladon `#79BEB5`, abricot `#EDAA7D`, bleu courrier `#7095CF` ; contours encre pour les informations essentielles |
| Typographie | Nunito Sans régulier/semi-gras ; titres compacts, pas d'écriture manuscrite dans les règles. [OFL officielle](https://raw.githubusercontent.com/google/fonts/main/ofl/nunitosans/OFL.txt) |
| Rails | Doubles bandes émaillées sur petits appuis en céramique ; arêtes visibles et sorties de case non masquées par les motifs ; le virage reste un vrai coude à deux connexions |
| Colis | Papier plié, épaisseur et rabat visibles, ruban et sceau géométrique ; faire correspondre exactement le triangle B sur colis **et** réception (réserve restante de l'image B v3) |
| Stations | Pavillons postaux bas en papier sur socle porcelaine ; sources avec colis au porche ; ouvertures de réception à l'ouest, raccordées aux rails ; pas de tours impossibles |
| Environnement | Une île-plateau compacte, ciel discret, deux motifs floraux périphériques ; peu de craquelures et de motifs pour ne pas charger les connexions |
| HUD | Étiquettes ivoire, texte encre, bouton abricot avec texte encre ; aucun blanc fin sur abricot pour une action essentielle |
| Mouvement propre | Tuile qui se soulève à peine puis tourne, rabat papier à la réception, sceau confirmé ; environnement immobile pendant l'action, mouvement réduit disponible |
| Faisabilité Godot | Sprites pré-rendus sous caméra fixe pour la première tranche ; 3D orthographique possible si nécessaire. Prévoir quatre orientations et des ombres cohérentes ; surveiller l'occlusion des pignons et les raccords après compression |
| Réserve de sélection | Harmoniser le sceau B ; réduire la texture au téléphone ; nuages et fleurs restent décoratifs. Le décor ne doit jamais devenir une indication de chemin |

Cinq signes proposés : porcelaine fonctionnelle, pavillons postaux bas, colis à rabats, rails d'émail sur appuis, typographie encre sur papier. Éviter l'architecture d'illusion, les personnages et les compositions identifiables des références étudiées.

## C — Nuit de Service : logistique calme et habitée

**Intention :** un réseau utilitaire miniature pendant un service de nuit, avec une matière physique lisible sans néons. Cette piste réinterprète G2 ; elle ne supplante pas automatiquement la DA chaude G3.

| Élément | Spécification proposée |
|---|---|
| Palette | Bleu-noir `#111D2A`, ardoise `#34495C`, porcelaine claire `#E3EBED`, ambre `#F2B75F`, menthe glacée `#8FD1CD` ; couleurs A/B sémantiques conservées séparément |
| Typographie | Space Grotesk pour titres, Inter pour actions/aide et chiffres alignés. [Space Grotesk OFL](https://raw.githubusercontent.com/floriankarsten/space-grotesk/master/OFL.txt), [Inter OFL](https://raw.githubusercontent.com/rsms/inter/master/LICENSE.txt) |
| Rails | Profilés argentés encastrés dans des dalles graphite, petits repères de rive ; lumière fine et discontinue, sans ruban opaque couvrant la voie |
| Colis | Cartouches de courrier courtes, face de sceau mate et lisible ; agrandir silhouette et badge par rapport au concept C v2 avant import natif |
| Stations | Casiers en métal anodisé/verre dépoli ; réception éclairée sobrement ; rendre le port d'entrée ouest explicite, au lieu de suggérer une fente sud non raccordée |
| Environnement | Béton, fenêtres ambre et tuyauterie en périphérie ; pas de grande ville, d'hologrammes ou de décor plus lumineux que les rails |
| HUD | Cartouches encre, texte clair et commande principale ambre/encre ; lignes de séparation sobres, contrôle stable sans halo pulsant |
| Mouvement propre | Arrêt précis, témoin discret qui confirme la réception, bref glissement de verrou ; pas de flash global ni de secousse de caméra |
| Faisabilité Godot | 2D texturée et petits accents lumineux dessinés ou 3D orthographique très limitée ; doit rester lisible dans Compatibility sans dépendre du bloom. Tester l'overdraw et la luminosité sur le vrai Android |
| Réserve de sélection | Clarifier les entrées des destinations et grossir les colis. Les voyants du décor ne doivent pas ressembler à des commandes ou à des ports de connexion |

Cinq signes proposés : dalles utilitaires modulaires, cartouches plutôt que wagons, fenêtres de service ambre, lumière matérielle contenue, HUD de signalétique. Le calme nocturne n'implique ni obscurité illisible ni mécanique différente.

## Contrastes des tokens proposés

Calcul sRGB exécuté sur les paires ci-dessous ; **ce ne sont pas des mesures des pixels des concepts ni un audit d'accessibilité**. Les textures, tailles, ombres et autres états restent à contrôler dans le HUD natif.

| Paire | Rapport calculé |
|---|---:|
| A encre sur brouillard | 12,79:1 |
| A blanc sur cobalt primaire | 6,77:1 |
| B encre sur porcelaine | 9,95:1 |
| B encre sur abricot primaire | 5,78:1 |
| C texte clair sur bleu-noir | 14,09:1 |
| C bleu-noir sur ambre primaire | 9,50:1 |

Les familles de polices ont des sources OFL vérifiées dans l'[étude des références](REFERENCES_ET_CONVENTIONS.md), mais aucun fichier de police n'est encore embarqué. Le dessin des lettres dans les PNG ne prouve pas l'usage de ces fontes. Conserver leurs licences et noms réservés lors du futur téléchargement.

## Interaction, motion et critères d'acceptation communs

| Événement | Proposition de réponse, à implémenter et mesurer après sélection |
|---|---|
| Appui sur une tuile | Sélection nette au toucher ; rotation d'un quart de tour et compteur mis à jour ; aucune translation, pose ou branche nouvelle |
| Expédier | Verrouiller la modification pendant la simulation ; deux départs simultanés dans le district 02 ; vue pilotée par les événements du modèle |
| Rupture / mauvaise destination | Segment et cause identifiés en texte ; permettre correction, annulation ou remise à zéro ; pas de publicité ni de pénalité ajoutée |
| Livraison | Colis reçu, sceau et compteur confirmés ; 180–240 ms proposés pour le feedback, pas un timing concurrent mesuré |
| Victoire | Résumé simple et suite accessible ; pas d'animation bloquant la relance ; pas de caméra secouée |
| Réduction du mouvement | États instantanés ou fondus courts ; aucun flash global ; son et haptique optionnels, pas uniques porteurs d'information |

Acceptation de la **direction** : le propriétaire choisit une identité après lecture de la [QA expert](QA_CONCEPTS_2026-11-14.md), avec les réserves listées. Acceptation de la **tranche native** : objets séparés, connexions correctes, vraie typographie, toucher/focus/safe areas, erreur/réussite/annulation/reprise, mouvement réduit et mesures Android réellement passés. Ces critères ne sont pas remplis par les seuls concepts.

Conseil expert, pas résultat d'étude : comparer B en premier pour la continuité G3, A pour la clarté de l'instrument et C pour le ton nocturne. Aucun choix n'est imposé et aucune préférence joueur n'a été mesurée. Le [brief natif](BRIEF_TRANCHE_VERTICALE.md) attend cette sélection et le périmètre approuvé.
