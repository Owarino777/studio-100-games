---
name: studio-art-direction
description: Concevoir ou améliorer la direction artistique d'un jeu (game art, UI, assets, sprites, textures, identité visuelle, style guide, VFX) avant son intégration au moteur; déclencher pour tout projet d'interface ou d'apparence de jeu.
---

# Direction artistique de jeu — procédure du studio

Ne jamais commencer par retoucher le CSS ou placer des boutons tant que la cible artistique n'est pas décrite. Utiliser, en complément si disponibles, `create-game-assets`, `game-feel`, le skill d'interface du moteur détecté et éventuellement `shader-programming`.

## 1. Comprendre le jeu et ses contraintes
- Genre, public, orientation et type d'appareil, boucle de 30 secondes, interactions essentielles, budget/performance, identité actuelle et droits des assets.
- Inventorier les écrans et assets à produire. Définir l'information essentielle visible à un joueur qui découvre le jeu en 3 secondes.
- Étudier au moins trois références réelles du genre pour leurs conventions : lisibilité, hiérarchie, feedback, qualité des matériaux et animations. Distinguer observations vérifiées et interprétation. Ne pas recopier une composition distinctive.

## 2. Faire une art bible concise
- Promesse visuelle en une phrase ; trois principes dominants ; palette avec usages et contrastes ; typographie/tailles ; proportions et grilles ; matériaux ; éclairages/ombres ; icônes ; personnages/éléments ; mouvements ; états UI ; haptique/audio ; spécificités portrait/paysage.
- Définir 5 éléments de différenciation propres au jeu, au-delà d'une simple recoloration.
- Les visuels de référence sont explicitement étiquetés *concept*, les rendus issus du moteur *captures du jeu*.

## 3. Produire des familles, pas des assets isolés
- Un premier « golden screen » ou vertical slice valide la cible. Sélectionner une direction avant de générer des centaines de ressources.
- Construire une famille homogène de tuiles/objets/UI/effets, avec transparence, ratios, points d'ancrage, échelles, variantes et états.
- Préférer un véritable pipeline d'assets à des gradients/vecteurs improvisés pour remplacer une texture ou un objet qui a besoin de profondeur.
- Prévoir déclinaisons, fallback et licences/attribution documentées ; aucun usage d'assets externes sans droit identifié.

## 4. Intégrer et vérifier dans le vrai moteur
- Importer les ressources, utiliser scènes et composants natifs. Capturer le rendu exécuté aux résolutions cibles et comparer avec l'art bible.
- Animer les événements importants (validation, erreur, combo, victoire, gain, changement de niveau) de manière intelligible. Éviter les effets gratuits.
- Réaliser au moins une passe sur lisibilité, profondeur, contraste, silhouette, identité, cohérence des assets et perf mobile.

## Gate visuel
Évaluer sur 0–4 : identité originale ; lisibilité ; cohérence ; finition ; fidélité du build ; confort mobile. Tout 0–1 bloque la livraison ; tout 2 exige des corrections consignées. Score élevé ≠ validation par des joueurs.

## Sortie exigée
Art bible versionnée, inventaire/licences des assets, captures issues du vrai build, anomalies visuelles triées et limites explicites. Ne jamais présenter le concept art comme un écran du jeu implémenté.
