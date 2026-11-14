# Préproduction SWITCHWORKS — Réception du jalon

14 novembre 2026. Périmètre : versionnement local, reprise des archives, validation produit préparée et trois directions artistiques. **Aucun jeu complet, aucune nouvelle page HTML, aucune publication ou dépense externe engagée.** La tranche native est préparée, pas implémentée avant sélection et arbitrage de son périmètre.

## Livrables à lire

1. [Synthèse de référence paginée](SYNTHESE_REFERENCE_SWITCHWORKS_2026-11-14.md) : contexte, décisions, hypothèses, contradictions et preuves manquantes, sur les 9 PDF/73 pages et les documents associés.
2. [Préqualification actualisée](market-research/SWITCHWORKS_PREQUALIFICATION_2026-11-14.md), [registre d'hypothèses et tests](market-research/SWITCHWORKS_HYPOTHESES_ET_TESTS_2026-11-14.md), [programme des 100 jeux](market-research/PROGRAMME_100_JEUX_CADRAGE_2026-11-14.md) : statut TEST/HOLD commercial, concurrence et terrain à réaliser.
3. [Trois directions détaillées](art/switchworks/DIRECTIONS_ARTISTIQUES.md) et [planche finale](art/switchworks/concepts/comparaison-finale.png) : A Atelier 17 v5, B Archipel Postal v3, C Nuit de Service v2.
4. [Audit expert des concepts](art/switchworks/QA_CONCEPTS_2026-11-14.md), [références commerciales](art/switchworks/REFERENCES_ET_CONVENTIONS.md), [manifeste](art/switchworks/asset-manifest.json), [prompts et révisions](art/switchworks/PROMPTS_CONCEPTS.md) : provenance, contraintes, réserves et versions supersédées conservées.
5. [Brief natif après choix](art/switchworks/BRIEF_TRANCHE_VERTICALE.md) et [ADR 0002](decisions/0002-contexte-historique-et-preproduction.md) : contrat de règles, assets séparés, critères d'acceptation et décisions encore ouvertes.
6. [Publication privée préparée](publication/PREPARATION_GITHUB_PRIVEE.md) : première fondation commitée, destination et contrôles avant toute action distante.

## Vérifications réellement exécutées

| Contrôle | Résultat |
|---|---|
| Fondation avant premier commit | 296 fichiers examinés, scan de secrets fichiers/blobs, notices et exclusions contrôlés ; commit `9687b0e71c91b7be39bc7d86fc12171d9cffd543` |
| Historique initial | Un commit racine, `git fsck --full --strict` code 0, dépôt propre juste après commit |
| Archives fournies ensuite | 16 fichiers conservés ; les 14 entrées du manifeste fourni correspondent aux SHA256, aucune modification de source |
| Lecture des PDF | 9/9 PDF, 73/73 pages extraites et rendues ; sources citées par document/page |
| Matrice historique | Poids total 100 ; cinq scores recalculés conformes ; grille de participants vierge, aucune mesure terrain fabriquée |
| Concepts | Dix rendus de génération/révision et deux planches conservés ; sélection de comparaison A v5/B v3/C v2 ; lecture visuelle et hashes recoupés indépendamment |
| Raster | `asset_report.py --expect-size … --json` réussi sur 12/12 PNG ; fichiers opaques, dimensions enregistrées ; aucune validation d'assets runtime déduite |
| Données de la planche | `python docs/art/switchworks/validate_reference_board.py` : 7/7 contrôles ; pas un moteur complet ou un portage historique |
| Non-régression du socle | `tools/Studio.ps1 -Action Test` exécuté : 36 réussites, 0 échec, code 0 |
| Préservation du code | Diff contre `9687b0e` vide pour `games/`, `tools/`, `platform/`, `shared/`, `.agents/` et `skills-lock.json` |
| Textes/liens | UTF-8 et liens locaux des nouveaux documents actifs contrôlés ; liens historiques cassés par renommage signalés sans réécriture des archives |

Les outils de lecture PDF et raster ont été ajoutés uniquement sous `tools/.local/`, ignoré par Git. Aucune dépendance de jeu n'a été ajoutée. Les contrôles raster attestent le format et les dimensions, pas la mécanique dessinée : celle-ci a fait l'objet d'une inspection séparée et reste distincte du modèle JSON.

## Ce qui reste à décider ou mesurer

**Produit :** SWITCHWORKS reste une présélection TEST. Le score du benchmark, les anciens tests techniques et le bootstrap ne prouvent ni plaisir, ni intention d'achat, ni rétention ou rentabilité. Le protocole historique de deux concepts reste distinct du comparatif A/B/C de styles.

**Art :** choisir A, B ou C. Conseil expert : examiner B pour la continuité céramique de G3 ; A comme précision claire et C comme service nocturne. Ce conseil n'est pas une préférence mesurée. Corriger avant fabrication native : sélection claire sur gris pour A ; code de forme du colis B pour B ; ports de réception et silhouette des colis pour C. Les vrais contrastes, fontes embarquées, cibles tactiles, animations et performances restent non testés sur ces concepts.

**Natif :** les sources exécutables historiques ne sont pas fournies dans les PDF ; aucun des 18 niveaux ni des 79 tests rapportés n'est annoncé porté. Le brief propose des micro-niveaux nouveaux et un contrat à valider ; les compteurs/PAR/sauvegarde et le signal partagé doivent être précisés avant codage. La mire et ses 36 contrôles restent disponibles.

**GitHub :** `origin` est configuré localement pour `Owarino777/studio-100-games`. Aucun dépôt distant n'est créé et aucun push n'est fait. La visibilité privée et les droits devront être lus et confirmés avant la publication autorisée ; une URL locale ne prouve pas cette confidentialité.

Les comptes, campagnes payantes, recrutement de participants, intégrations publicitaires/achats et tests iOS/appareils physiques restent hors de ce jalon. Les critères et les limites sont conservés dans les documents liés ci-dessus.
