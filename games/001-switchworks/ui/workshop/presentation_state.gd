class_name PostalPresentationState
extends RefCounted
## One observable presentation contract. Never mutates or substitutes puzzle rules.


static func derive(screen: ArchipelScreen, receipts_complete: bool) -> Dictionary:
	var phase: String = screen._phase
	var paused: bool = screen._paused
	var ready: bool = screen._guidance_state in ["planning_ready", "restored_ready"]
	var settled: bool = screen._busy_time <= 0.0
	return {"phase": "paused" if paused else phase, "underlying": phase,
		"ready": ready and phase == "planning", "show_result": phase == "won" and receipts_complete and not paused,
		"show_stats": phase != "won", "show_secondary_actions": phase != "won",
		"undo_enabled": not paused and settled and phase in ["planning", "failed"] and screen._board.can_undo(),
		"primary_enabled": not paused and settled and phase != "running",
		"hint_enabled": not paused and settled and phase in ["planning", "failed"],
		"board_enabled": not paused and phase in ["planning", "failed"],
		"primary_copy": "Rejouer" if phase == "won" else "Expédier",
		"resume_copy": "Retour au résultat" if phase == "won" else "Reprendre",
		"pause_heading": "Tournée terminée" if phase == "won" else "Pause",
		"pause_copy": "Deux livraisons validées.\nVos réglages restent conservés." if phase == "won" else ("La livraison reprendra ici." if phase == "running" else "Votre préparation est conservée.")}


static func copy_for(text: String, key: String) -> String:
	if text.begins_with("Ce quai est fixe") or text.begins_with("Choisissez une voie"):
		return "Station fixe.\nChoisissez une voie à tourner."
	match key:
		"fresh": return "Tournez les voies, puis expédiez."
		"planning_editable": return "Ajustez les raccords.\nAnnuler restaure le dernier geste."
		"planning_ready": return "Réseau prêt. Vous pouvez expédier."
		"restored_ready": return "Préparation retrouvée. Réseau prêt."
		"restored_editable": return "Préparation retrouvée.\nVérifiez les raccords."
		"running": return "Livraison en cours.\nLes colis rejoignent leurs boîtes."
		"won": return "Deux colis reçus aux bonnes adresses."
	return text
