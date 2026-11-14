# Shell Web officiel adapté au mobile

`godot_shell.html` est issu de `godot.html` dans le modèle officiel **Godot 4.7.2 stable**, `web_nothreads_release.zip` déjà installé. Le corps, le canvas, les contrôles de chargement et l'appel `engine.startGame()` sont conservés. Ce shell ne remplace aucune scène Godot par une maquette HTML.

Modifications : langue du document `fr`, métadonnée viewport avec `viewport-fit=cover` et suppression de `user-scalable=no`. Aucun padding de body/canvas n'est ajouté : les marges sûres sont du ressort de l'adaptation Web GDScript, pour éviter un double retrait. Pas de PWA, store, script tiers ou publication.

Le copyright et la permission MIT du moteur sont intégralement conservés dans un commentaire HTML. Le texte source identique est dans `assets/licenses/GODOT_LICENSE.txt`. Les empreintes du modèle, du HTML original et du dérivé sont consignées dans [SOURCE.json](SOURCE.json). Les trois presets natifs restent inchangés ; seul le preset Web désigne le shell dérivé.
