# VS-001 — Une tranche Archipel Postal expérimentale

- Date : 14 novembre 2026
- Statut : mise en œuvre expérimentale autorisée par le propriétaire ; art et marché restent TEST / HOLD

Le propriétaire retient provisoirement B et autorise **un niveau représentatif**, ce qui précise le brief antérieur de trois micro-niveaux proposés. La tranche met donc en œuvre le district de double flux, sans ajouter le croisement/délai du district 03 ni prétendre porter les 18 niveaux HTML.

Le modèle `PostalLevel`/`PostalBoard` est indépendant de la vue. La vue utilise de petites géométries 3D sous caméra orthographique et un HUD `Control` natif. Ce choix permet des rails réellement rotatifs, des matériaux éclairés de façon cohérente et des ports physiques, sans découper le poster conceptuel en faux objets. Le renderer Compatibility et Godot 4.7.2 Standard sont conservés.

Les couleurs soutiennent les lettres et formes A/cercle–B/triangle. Les entrées de réception sont sur le côté ouest raccordé au rail. Les actifs sont construits par une fabrique réutilisable ; les albedos générés ne portent ni texte de HUD ni logique de trajet.

Contrat de préparation : les rotations et indices sont annulables, les expéditions réellement demandées restent comptées ; Recommencer remet le niveau à zéro et garde les préférences. La simulation est déterministe, bloquante pour l'édition et ne dépend pas des animations. Le bilan de victoire expose Rejouer et ne laisse pas de contrôles actifs masqués dessous.

Le cache du viewport 3D est rafraîchi pour les modifications, rotations, déplacements et reprises ; le plateau immobile ne demande pas un nouveau rendu 3D à chaque image. Les mesures utilisent l'intervalle mural entre callbacks après chauffe, et non un delta lissé comme preuve de cadence.

La persistance ne concerne que la préparation, les compteurs et préférences. Une session gardée en mémoire reprend après Home ; un nouveau processus revient en planification. Aucun contrat de migration HTML, backend ou classement n'est ajouté.

La mire et son démarrage sont conservés. Le preset Android indépendant utilise `archipel_slice` pour sélectionner la nouvelle scène et un package debug distinct. Les tests/captures de la famille d'art sont exclus de cet APK ; les données de niveau et notices de licence y sont incluses.

L'acceptation de cette tranche repose sur [la recette](../vertical-slice/REPORT.md) et ses limites. Elle n'autorise ni publication, ni jeu complet, ni qualification commerciale.
