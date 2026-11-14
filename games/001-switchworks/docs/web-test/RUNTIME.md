# Adaptations de runtime pour l'export Web

14 novembre 2026. Branche de test `test/archipel-postal-web-iphone`, base `108e2b04`. Ce document décrit des adaptations **conditionnelles `OS.has_feature("web")`** dans `scripts/archipel/archipel_screen.gd`, pas une nouvelle version des règles ou de la famille d'assets. Aucun serveur ni contenu externe n'est publié par ces modifications.

## Changements ciblés

| Sujet | Traitement Web | Limite à vérifier sur l'iPhone |
|---|---|---|
| Onglet masqué, Home ou changement de fenêtre | `visibilitychange`, `pagehide` et `blur` demandent la pause existante et la sauvegarde de préparation. Les callbacks sont conservés dans des références `JavaScriptObject`, puis retirés à la sortie. | Les événements livrés par Safari et une destruction brutale de page dépendent du système ; la manipulation physique reste à réaliser. |
| Retour dans la page | `pageshow`, `focus` et retour de visibilité invalident le viewport 3D mis en cache et refont le layout. La simulation **reste en pause** jusqu'à Reprendre. | Une page réellement détruite repart en planification après rechargement ; aucun état de victoire, trajet ou historique d'annulation n'est réinventé. |
| Stockage | Même fichier `user://archipel_slice_v1.json`, même schéma, écriture temporaire puis renommage. Godot gère sa synchronisation IndexedDB ; aucune API privée `FS.syncfs` ni stockage parallèle n'est ajouté. | Le système de fichiers Web est propre à l'origine du site. Un autre hostname, la navigation privée, un stockage refusé ou une éviction peuvent faire perdre les données. |
| Stockage annoncé indisponible | Consigne simple : « Partie gardée dans cet onglet. Le navigateur ne la conserve pas. » Deux lignes, sans ajout d'un panneau ou d'un compte. | `OS.is_userfs_persistent()` n'est pas une preuve absolue de durabilité ; ne pas transformer cette métadonnée en succès de sauvegarde. |
| Safe area | Une sonde DOM invisible lit les insets CSS du navigateur et les convertit en unités du viewport Godot. Elle ne dessine aucun gameplay. | Le shell standard ne demande pas `viewport-fit=cover` : les insets peuvent être nuls parce que Safari réserve déjà la zone. Vérifier les bords et la barre d'accueil sur appareil. |
| Paysage et DPR | En paysage court, la règle Web se base sur `window.innerWidth/innerHeight` en pixels CSS, afin d'éviter d'appliquer une règle desktop aux pixels du framebuffer Retina. Le portrait garde la référence héritée. | Le changement de barre d'adresse et d'orientation doit être exercé dans Safari, pas déduit d'un viewport simulé. |
| Sons optionnels | Les petits WAV produits à l'exécution utilisent explicitement le chemin `STREAM` en Web ; les sons restent désactivés initialement. Aucun effet ou SDK audio ajouté. | Autoplay soumis au geste utilisateur ; latence et écoute Safari non validées par la compilation ou un test muet. |
| Glyphes de l'objectif et de Pause | Le premier vrai rendu WASM/Chrome montrait des carrés de glyphe manquant pour `→` et `Ⅱ`. Le Web utilise « Livrez A à A et B à B » et `II`, avec le même bouton/tooltip ; aucun asset externe ajouté. Les glyphes natifs restent inchangés. | Le nouveau build doit être réexporté et inspecté ; les tests de chaînes natifs seuls n'établissent pas la présence d'un glyphe dans le navigateur. |

La [documentation Web Godot 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_web.html) distingue persistance, suspension et audio Web. Le [code officiel `OS_Web` 4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/web/os_web.cpp) marque le besoin de synchronisation lors de la fermeture d'un fichier écrit sous `/userfs`, puis déclenche la synchronisation dans la boucle principale. Le renommage suit la fermeture avant cette boucle ; le schéma existant est conservé. Cela ne garantit pas une écriture achevée juste avant une fermeture brutale.

Les [callbacks `JavaScriptBridge`](https://docs.godotengine.org/en/4.7/classes/class_javascriptbridge.html) et le [type de lecture audio](https://docs.godotengine.org/en/4.7/classes/class_audioserver.html) ont été vérifiés contre les API de cette version. Les événements sont liés uniquement au navigateur qui exécute le jeu ; aucun journal, sauvegarde ou identifiant n'est transmis à un service par le controller.

## Perte de contexte WebGL

Le [backend Web officiel 4.7.2](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/web/js/libs/library_godot_display.js) affiche une demande de rechargement quand le contexte WebGL est perdu. Cette adaptation ne masque pas ce problème et ne prétend pas reconstruire les ressources GPU automatiquement. La simple reprise de visibilité peut redessiner un viewport encore valide ; une vraie perte de contexte reste un cas distinct. Recharger et contrôler la préparation récupérée si le navigateur avait pu la conserver.

## Diagnostics et contrôles exécutés

Le controller émet `SLICE_WEB` avec raison, phase, persistance déclarée, caractère sécurisé du contexte, compteurs et empreinte SHA256 du tableau JSON des ports. Les dimensions CSS et le DPR permettent d'interpréter les coordonnées. Ces lectures n'écrivent ni schéma de sauvegarde ni état de jeu ; elles servent notamment à comparer une préparation avant/après rechargement sans API privée d'Emscripten. Aucun URL complet, token d'accès ou identifiant d'appareil n'est journalisé. Les logs habituels `SLICE_READY`, `SLICE_LAYOUT`, `SLICE_GUIDANCE`, résultat et réception sont conservés.

Exécution réelle du binaire local Godot `4.7.2.stable.official.ed1daf0bf` Standard :

- Compilation globale : **13 scripts contrôlés, 0 cassé**, code 0. Une sonde d'API temporaire ignorée avait d'abord été comptée séparément ; elle est exclue par `.gdignore` des contrôles de sources.
- Suites natives de référence : **36/0 bootstrap**, **137/0 modèle**, **471/0 interface**, **1 758/0 états**, codes 0 et aucun `ERROR:`/`SCRIPT ERROR` détecté dans ce passage positif.
- Sonde réellement exécutée : `JavaScriptObject` et singleton `JavaScriptBridge` disponibles dans l'éditeur, constante `AudioServer.PLAYBACK_TYPE_STREAM=1`.

Logs locaux : `artifacts/web-test/runtime-compile-final.log` et `runtime-native-tests.log`. Les tests natifs prouvent que les branches non-Web restent fonctionnelles dans leur périmètre ; **ils n'exécutent pas les callbacks navigateur**. Les essais réels du build exporté et leurs captures sont à lire dans la recette générale de la branche.

## Statuts à ne pas confondre

À ce stade de cette sous-tâche : compilation et non-régression native effectuées ; sauvegarde/rechargement navigateur, visibilité réelle, toucher et orientation Safari à vérifier par le responsable de recette. Les iPhone 15 Pro/Pro Max et iOS 27.2 sont des informations déclarées par le propriétaire, pas des appareils inspectés par cet agent. Aucun test humain, performance iPhone, conformité d'accessibilité ou équivalence de rendu Android n'est déduit de ces résultats. La validation Android native prévue reste distincte.
