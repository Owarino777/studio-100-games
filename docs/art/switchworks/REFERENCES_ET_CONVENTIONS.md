# SWITCHWORKS — Références artistiques et conventions d'interface

Date de collecte : **14 novembre 2026**. Statut : **étude documentaire et audit expert**, avant choix de direction. Ce document ne rapporte ni test utilisateur, ni validation commerciale, ni recette d'une tranche verticale. La base détectée est Godot 4.7.2 Standard, GDScript et renderer Compatibility ; le projet existant est encore une mire technique. Les archives G1–G3 ont ensuite été relues intégralement : leur [reconstitution traçable](HISTORIQUE_PROTOTYPES.md) prime sur les suggestions mécaniques d'une première exploration visuelle.

## Méthode et périmètre des preuves

Les neuf skills demandés ont été relus : `router`, `studio-art-direction`, `studio-game-ux`, `studio-visual-qa`, `create-game-assets`, `game-ui-ux`, `game-feel`, `puzzle`, `level-design`. Leur composition donne : règles de puzzle et de niveau avant habillage ; système d'assets cohérent ; HUD natif et accessible ; feedback attaché aux événements ; comparaison dans le vrai moteur après sélection.

Un échantillon officiel de chacun des cinq jeux de référence a été téléchargé dans `tools/.local/reference-review/`, puis **inspecté visuellement** avec `view_image`. Ces images restent dans le cache ignoré et ne sont pas redistribuées dans le dépôt. Les copies concurrentes ne constituent pas des assets de SWITCHWORKS. Les images promotionnelles de titre et les petites icônes App Store ont été écartées de l'analyse du gameplay. Une vigilance supplémentaire sur Parcel Flow, issue de la recherche produit, est explicitée séparément ci-dessous.

| ID | Jeu et source primaire | Échantillon inspecté | Limite |
|---|---|---|---|
| R1 | [Railbound — App Store, Afterburn](https://apps.apple.com/us/app/railbound/id1636439801) | Capture iPhone `1_Screen_6in_World_1_Stand`, 643 × 297 : chariots 1/2, rail, grille et décor | Aperçu paysage réduit ; pas mesure des zones tactiles réelles |
| R2 | [Mini Motorways — site et presskit Dinosaur Polo Club](https://dinopoloclub.com/press/mini-motorways/) | [Capture officielle publiée sur Steam](https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1127500/ss_b241a6cb9eedbe6126ce4ecc9b15218ba6670d09.1920x1080.jpg?t=1771361624), 1920 × 1080 | Échantillon PC ; la disponibilité Apple Arcade est confirmée par le développeur, pas l'ergonomie de l'édition mobile dans cette capture |
| R3 | [Mini Metro — site et presskit Dinosaur Polo Club](https://dinopoloclub.com/press/mini-metro/) | [Capture officielle publiée sur Steam](https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/287980/ss_c7bc5df7e606504709e9f53ff9c7584ac4c01b18.1920x1080.jpg?t=1724386220), 1920 × 1080 | Échantillon PC ; versions iOS/Android attestées dans le presskit |
| R4 | [inbento — page de l'éditeur sur Steam](https://store.steampowered.com/app/1567440/inbento/) et [édition mobile App Store Japon](https://apps.apple.com/jp/app/%E3%82%A4%E3%83%B3%E3%83%99%E3%83%B3%E3%83%88%E3%82%A6/id1468115950) | [Capture officielle du puzzle 4-7](https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/1567440/ss_6526429b7d860410b0c9f957b89d23d80cce3690.1920x1080.jpg?t=1738150422), 1920 × 1080 | Composition PC ; ne pas transposer ses boutons latéraux tels quels sur téléphone portrait |
| R5 | [Monument Valley 2 — App Store, ustwo games](https://apps.apple.com/us/app/monument-valley-2/id1187265767) | Capture portrait `Purple113/417c27f8…/pr_source`, 300 × 650 : architecture violette, soleil et deux personnages | Capture réduite ; matière et perspective observables, coût GPU et temps d'animation non mesurables |

Les sources Afterburn directes renvoyaient HTTP 403 lors de cette collecte ; les pages de publication des stores ont servi de sources primaires. Aucun prix, chiffre de vente, revenu, rétention ou performance n'est déduit des images.

### Vigilance ciblée : Parcel Flow et l'hypothèse « atelier chaleureux »

La [fiche Google Play officielle de Parcel Flow: Route Puzzle, ByteEra Labs LLC](https://play.google.com/store/apps/details?id=com.byteeralabs.parcelflow) décrit le tracé d'un itinéraire par geste continu, puis un départ au relâchement, dans un atelier miniature chaleureux. Deux captures de cette fiche ont été inspectées : plateau à rebords bleu-vert/ivoire, plaques crème, vis et accents dorés, petits colis, table en bois et atelier en fond.

**Risque observé dans les anciennes A v1–v3 :** ces explorations Atelier 17 partageaient plusieurs choix combinés de ce vocabulaire, malgré une autre mécanique de rotation. Elles restent archivées, sans preuve d'originalité. La piste finale **A v5** a changé de système : aluminium gris clair, modules en polymère cobalt, profilés argentés et raccords orange, sans bois, laiton ni émail bleu-vert. La proximité visuelle particulière relevée précédemment est donc réduite ; cela ne prouve ni l'originalité commerciale ni l'absence de risque juridique. Continuer à tester la reconnaissance à l'aveugle et éviter le fond d'atelier cosy avec fenêtre, plantes et lumière de table comme composition complémentaire. La [QA des trois versions finales](QA_CONCEPTS_2026-11-14.md) distingue cette révision des variantes écartées.

## Observations, interprétations et limites de réutilisation

### R1 — Railbound : la topologie ferroviaire doit se lire avant le décor

**Observé dans la capture :** rails doubles très clairs avec traverses régulières ; grille au sol discrète ; chariots courts numérotés ; caméra oblique ; arbres et rochers repoussés en bordure. Les contours foncés des objets les séparent du sol. Les repères des véhicules restent visibles malgré le détail du paysage.

**Interprétation pour SWITCHWORKS :** donner aux connexions une largeur constante, laisser de l'air autour des aiguillages et distinguer un colis par son sceau/identifiant. Le numéro ou symbole doit être posé sur une face lisible depuis la caméra.

**À ne pas reprendre :** personnages canins, voyage en train, contours de bande dessinée, locomotive et paysages traités dans la combinaison reconnaissable de Railbound. La présence commune de rails ne suffit pas à différencier notre jeu.

### R2 — Mini Motorways : les masses et l'espace négatif simplifient un réseau dense

**Observé :** routes pâles, bâtiments réduits à des volumes colorés, ombres orientées de façon homogène ; grande surface libre ; très peu de texte. Les marqueurs de destination sur les bâtiments sont plus contrastés que le fond cartographique. Les outils du bas forment un groupe compact.

**Interprétation :** réserver les accents les plus francs aux objets avec lesquels le joueur agit. Une station doit rester reconnue même si l'environnement est désaturé. Une ombre peut donner du poids à un objet sans ajouter une texture détaillée à chaque case.

**À ne pas reprendre :** la carte de ville, ses maisons/blocs, les marqueurs en épingle, les boucliers numérotés d'autoroute et la disposition du HUD comme identité complète. La page développeur documente aussi des modes de couleur ; cela ne prouve pas l'accessibilité de SWITCHWORKS.

### R3 — Mini Metro : doubler les codes et protéger la lecture des connexions

**Observé :** réseau épais et coloré sur fond clair, stations géométriques avec contour sombre ; symboles de passagers distincts ; trains représentés par des segments pleins. Le décor reste sous le réseau et l'information de temps/score est isolée en haut à droite.

**Interprétation :** les charges peuvent porter une lettre et un motif de sceau, en plus de leur couleur. Le suivi d'un trajet doit être possible sans lire le HUD. Les couleurs du décor ne doivent pas avoir l'intensité des états de livraison.

**À ne pas reprendre :** une carte de métro abstraite à lignes multicolores et stations cercle/triangle/carré comme composition principale. Pour SWITCHWORKS, les rails restent des objets matériels et les colis des volumes transportés.

### R4 — inbento : montrer le problème, le but et les moyens dans trois zones

**Observé :** plateau central de neuf cases, objectif miniature séparé, pièces disponibles regroupées dans un plateau bas. Les bords sombres et ombres simples ferment les volumes. Les textures sont spécifiques aux ingrédients, mais ne brouillent pas leur silhouette. Le niveau et les actions de retour ne recouvrent pas le puzzle.

**Interprétation :** associer un objectif bref « livrer 3 colis » à un plateau dominant, puis aux commandes principales dans une zone de pouce. La différence entre état courant et résultat souhaité doit être visible sans panneau de tutoriel long.

**À ne pas reprendre :** boîte-repas, ingrédients, carnet relié, plateau de cuisine et récit de chats. Le principe de trois zones est une convention de hiérarchie, pas une licence de reproduire cet habillage.

### R5 — Monument Valley 2 : une seule intention lumineuse peut donner une finition forte

**Observé :** grandes masses violettes, une silhouette architecturale isolée, éclairage directionnel, fond peu détaillé et grands vides. De petits éléments clairs signalent les personnages/points actifs. L'image garde une hiérarchie malgré une palette proche en teinte.

**Interprétation :** limiter la matière et la lumière à quelques règles constantes ; laisser respirer le plateau plutôt qu'ajouter de la décoration partout. La profondeur est utile seulement si elle ne masque aucun raccord.

**À ne pas reprendre :** tours impossibles, architecture sacrée, personnages à silhouette conique, géométrie d'illusion, grands soleils en disque et composition monumentale verticale. Un archipel postal doit être conçu autour de quais de livraison et de supports lisibles, sans temples impossibles.

## Mouvement et feedback : ce qui est documenté et ce qui reste à tester

Les pages éditeur décrivent des trains qui circulent et se raccordent pour Railbound, des véhicules qui parcourent un réseau pour Mini Motorways/Mini Metro, la rotation et l'insertion de pièces pour inbento, ainsi que la manipulation d'architecture pour Monument Valley 2. Ces faits renseignent le **lien action → conséquence**. Les captures inspectées sont statiques : aucun timing, courbe d'easing, temps de réponse ou ressenti haptique concurrent n'a été mesuré. Les bandes-annonces listées dans les presskits ne sont pas présentées ici comme un playtest.

Proposition de vocabulaire de mouvement, à vérifier dans la future tranche verticale :

| Événement | Signal prioritaire | Valeur de départ proposée, pas mesure concurrente | Réduction du mouvement |
|---|---|---|---|
| Voie rotative sélectionnée | Cerclage local et repère d'orientation ; pas de levier suggérant une bifurcation T/Y | Transition 100–140 ms | Changement de contour instantané |
| Voie orientée | Rotation de 90° avec arrêt net ; clic discret optionnel | 140–180 ms, retour exact à l'orientation logique | Bascule instantanée, aucune caméra mobile |
| Trajet pendant la simulation | Quelques marqueurs espacés au-dessus des rails, pas un ruban opaque | Progression douce, arrêt sur pause | Marqueurs statiques et flèches |
| Colis livré | Sceau confirmé + compteur incrémenté + petit tassement du colis | 180–240 ms ; amplitude faible | Confirmation texte/symbole immédiate |
| Route invalide | Segment concerné souligné + explication près de l'action | Une impulsion locale 160 ms | Contour fixe ; pas de flash global |
| Victoire | Confirmations des deux flux A/B vers le bilan du scénario commun | Transition 250–350 ms, relance accessible immédiatement | Fondu bref ou changement instantané |

Éviter le screen shake et le hit-stop pour les actions ordinaires de ce puzzle. L'animation doit rejouer les événements du modèle de plateau ; elle ne décide jamais si une livraison est valide. « Annuler » restaure aussi compteurs et état de simulation. Les erreurs ne doivent ni punir par une longue animation, ni effacer silencieusement la préparation.

## Applications aux trois propositions originales

Les noms suivants sont des pistes internes de direction, pas des marques validées ni des règles de jeu déjà adoptées. Les trois visuels de comparaison doivent montrer **la même situation de rails, colis et stations**, la même orientation de caméra et le même objectif pour comparer l'art plutôt que la difficulté des niveaux. Après lecture des archives, ce scénario respecte une grille **6 × 6**, des pièces droites/coudes à **deux connexions** pivotant de 90°, quatre stations fixes pour les deux flux A/B et un départ volontaire. La [planche originale de comparaison](EXEMPLE_PLATEAU_6X6.json) est un exemple nouvellement vérifié, pas un niveau G3 récupéré. Le pas-à-pas, les T/Y pivotants, un troisième flux et un chronomètre contraignant ne font pas partie de cette base.

| Système | A — Atelier 17 | B — Archipel Postal | C — Nuit de Service |
|---|---|---|---|
| Identité | Instrument de routage de précision, clair et modulaire, version finale A v5 | Réseau de courrier léger, objets précieux et tactiles | Infrastructure nocturne soignée, présence humaine discrète |
| Rails | Profilés argentés à doubles arêtes, raccords orange, tuiles grises régulières | Deux bandes de papier plié fixées sur des supports de porcelaine ; raccord visible | Profilés de métal sur dalles, inserts clairs fins ; pas des lignes de néon flottantes |
| Colis | Boîtes compactes avec sceau géométrique et lettre ; séparation du carton et des modules synthétiques | Pochettes pliées, ruban et sceau gaufré, volume conservé en mouvement | Cartouches de courrier avec face lumineuse limitée, lettre et bande de motif |
| Stations | Modules cobalt, plaques frontales A/B, entrée latérale ouest de réception distincte | Quais-coquilles et cloches de porcelaine, signal postal ; pas tours de temple | Casiers utilitaires à verre dépoli, portes et indicateurs de réception |
| Environnement | Aluminium et polymère gris clair, joints fins, lumière diffuse ; aucun fond bois ni atelier cosy | Îlots en céramique/papier, ciel sobre ; aucun obstacle masquant les raccords | Béton graphite et métal patiné, petites fenêtres ambre ; zones actives plus claires |
| HUD | Plaques claires, libellés bleu encre, compteurs cobalt, chiffres tabulaires et repères indexés | Étiquettes papier simples, onglets souples ; boutons séparés du décor aérien | Cartouches lisibles, commandes matérielles mates ; aucune surenchère de panneaux « futuristes » |
| Motion propre | Rotation de la pièce sur crans, cerclage indexé, léger tassement des colis | Papier qui plie, couvercle qui se referme, rotation nette des pièces | Rotation de la voie, verrou de réception qui coulisse, voyant qui confirme |
| Risque majeur | Rail argenté et sélection blanche sur gris clair : contraste d'état à renforcer et mesurer dans le moteur | Proximité d'images d'îles pastel ; ambiguïté d'un rail qui « flotte » | Contraste insuffisant et halos qui rendent les raccords flous |

Ces différences doivent modifier silhouettes, joints, réception et mouvement, et pas seulement recolorer un même décor.

## Typographies proposées et provenance vérifiée

| Direction | Familles proposées | Preuve de licence à la collecte | Règle d'usage |
|---|---|---|---|
| A | IBM Plex Sans Condensed pour titres courts, Plex Mono pour compteurs | [Licence officielle IBM Plex, OFL 1.1](https://raw.githubusercontent.com/IBM/plex/master/LICENSE.txt) | Condensé limité aux titres ; texte d'aide dans une graisse ouverte, chiffres alignés |
| B | Nunito Sans, graisses régulière et semi-grasse | [Licence du projet distribuée par Google Fonts, OFL 1.1](https://raw.githubusercontent.com/google/fonts/main/ofl/nunitosans/OFL.txt) | Les formes douces n'imposent pas de petits caractères ni une graisse trop légère |
| C | Space Grotesk pour titres, Inter pour actions/aide | [Space Grotesk, OFL 1.1](https://raw.githubusercontent.com/floriankarsten/space-grotesk/master/OFL.txt) ; [Inter, OFL 1.1](https://raw.githubusercontent.com/rsms/inter/master/LICENSE.txt) | Garder des libellés courts ; texte d'action stable, sans déformation lumineuse |

Aucun fichier de police n'est ajouté par cette étude. À la future copie : enregistrer source, révision, empreinte, licence et notices avec chaque famille ; conserver les noms réservés éventuels, dont Plex. Un nom de famille écrit dans un prompt de concept ne garantit pas que la police réelle apparaît dans l'image. Les textes finaux devront être composés par les contrôles natifs du moteur.

## Faisabilité dans Godot 4.7.2

Évaluation de conception, **pas benchmark exécuté**. Pour garder le coût maîtrisé, partager entre les trois pistes un modèle de plateau indépendant de la vue, des rails modulaires, des colis et stations instanciés, puis un HUD natif. Les possibilités `Sprite2D` et caméra orthographique sont documentées dans [Sprite2D](https://docs.godotengine.org/en/4.7/classes/class_sprite2d.html) et [Camera3D](https://docs.godotengine.org/en/4.7/classes/class_camera3d.html). Le HUD doit suivre la politique de [résolutions multiples](https://docs.godotengine.org/en/4.7/tutorials/rendering/multiple_resolutions.html).

| Piste | Voie recommandée pour la tranche | Faisabilité estimée / risque à lever |
|---|---|---|
| A | Sprites 2D de pièces pré-rendues sous une caméra fixe ; textures de matière et ombres cohérentes ; leviers animés séparément | Bonne pour une petite équipe. Prototyper un aiguillage à l'échelle du téléphone avant de produire toutes les orientations. Ne pas remplacer les matériaux attendus par de simples rectangles ou gradients |
| B | Sprites isométriques pré-rendus pour la première tranche ; variante 3D orthographique uniquement si les volumes mobiles l'exigent | Faisable mais exigeante en cohérence de perspective, d'occlusion et de points d'ancrage. Les objets de dessus ne doivent cacher ni rails ni sorties ; tester l'ordre de dessin avant la famille d'assets |
| C | 2D texturée, lumières locales dessinées dans de petits sprites ; animation séparée des voyants | Bonne si le contraste fonctionne sans bloom. Le renderer Compatibility actuel ne doit pas dépendre d'un effet de post-traitement non vérifié. Contrôler l'overdraw des transparences et les halos sur le vrai export Android |

Les [Tween natifs](https://docs.godotengine.org/en/4.7/classes/class_tween.html) suffisent aux transitions simples envisagées ; aucune dépendance d'animation supplémentaire n'est justifiée à ce stade. La finesse des matériaux, le nombre d'atlases, la mémoire, les FPS et la consommation devront être mesurés sur appareil ciblé après choix d'une direction.

## Critères communs de comparaison et prochaine recette

Échelle **0–4** : 0 absent/illisible ; 1 défaut majeur ; 2 utilisable avec corrections ; 3 cohérent et clair ; 4 abouti dans le périmètre testé. Une valeur non vérifiable vaut **non testé**, pas 4. Une note élevée d'audit ne constitue pas une validation terrain.

| Critère | Procédure prévue | Blocage |
|---|---|---|
| Lecture du problème | Montrer l'écran 3 secondes, demander où part un colis, où il doit arriver et quel objet change sa route | Ambiguïté sur le sens d'un rail ou sur la fonction des stations |
| État actif | Comparer au moins aiguillage normal, sélectionné et invalide ; colis en route/livré | États distingués uniquement par la couleur ou par une petite lueur |
| Ergonomie | Évaluer le plateau à 360 × 640 unités UI, puis petit/grand téléphone ; zones tactiles proposées ≥ 48 unités logiques, à confirmer sur matériel | Deux aiguillages activables confondus ou doigt qui masque l'unique retour d'état |
| Hiérarchie | Lire objectif, progression et action principale sans chercher ; réduire le visuel en niveaux de gris pour contrôle complémentaire | Décor ou effets plus saillants que les connexions utiles |
| Cohérence | Superposer un échantillon rail/colis/station/HUD ; vérifier perspective, lumière et détails | Famille d'assets visiblement assemblée de sources incompatibles |
| Originalité | Comparaison critique avec les références R1–R5 ; citer cinq choix propres à notre système | Une proposition n'est qu'une recoloration ou le même cadrage reconnaissable d'un concurrent |
| Fidélité moteur | Après sélection, capturer le vrai rendu Godot et l'export Android de la tranche | Une illustration est présentée comme une fonction implémentée |
| Accessibilité | Lettres/sceaux et motifs en plus des teintes ; objectifs et actions en texte ; mesurer les contrastes du HUD natif | Colis/destination ou succès/échec dépendent exclusivement de la couleur |

Avant d'étendre la production, la tranche doit contenir un niveau résoluble et testé, une orientation d'aiguillage, une livraison, une erreur réparable, annuler/redémarrer, pause/reprise et un mode de mouvement réduit. Le plateau de référence sert d'abord à vérifier connexion et ordre des livraisons ; la décoration ne doit pas modifier ses règles. Aucun de ces critères n'est déclaré passé par les seules propositions conceptuelles.
