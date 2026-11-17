class_name WorkshopBoardView
extends LittoralBoardView
## Visual replacement only: inherited ports, ray picking, route timing and receipts.

signal receipts_finished
const W = preload("res://experiments/postal_workshop/workshop_models.gd")
var _ready_indicators: Array[Node3D] = []
var _receipt_signal_sent: bool = false


static func asset(id: String) -> Node3D:
	return (load("res://assets/postal-workshop/models/" + id + ".glb") as PackedScene).instantiate() as Node3D


func _ready() -> void:
	super._ready()
	_camera.size = WorkshopTheme.TOKENS.board_world_width
	_camera.position = Vector3(0, 10, 5)
	_camera.look_at(Vector3(0, 0.06, 0))
	for node: Node in _world.get_children():
		if node is WorldEnvironment:
			(node as WorldEnvironment).environment.background_color = WorkshopTheme.TOKENS.background
			(node as WorldEnvironment).environment.ambient_light_energy = 0.26
		elif node is DirectionalLight3D:
			var light := node as DirectionalLight3D
			light.light_energy = 0.56 if light.shadow_enabled else 0.08
			light.shadow_opacity = 0.22
	tooltip_text = ""


func configure(level: PostalLevel, ports: PackedInt32Array) -> void:
	_level = level
	_ports = ports.duplicate()
	_world.add_child(asset("socle"))
	_build_tile_batches()
	for index in 36:
		var tile := Node3D.new()
		tile.name = "TilePosition%d" % index
		tile.position = cell_position(index)
		_world.add_child(tile)
		_pieces.append(tile)
		if not level.fixed_indices.has(index) and ports[index] != 0: _rebuild_rail(index)
	for label: String in ["A", "B"]:
		for source: bool in [true, false]:
			var index: int = level.source_indices[label] if source else level.destination_indices[label]
			var station: Node3D = asset(("guichet_" if source else "boite_") + label.to_lower())
			station.position = cell_position(index)
			W.color_tracks(station, label)
			_world.add_child(station)
			if not source: _receptions[label] = station
			var indicator := Node3D.new()
			indicator.name = "ConnectionConfirmed" + label
			indicator.position = cell_position(index)
			var x: float = 0.44 if source else -0.44
			for z: float in [-0.19, 0.19]:
				W.part(indicator, "ConnectedBracket", Vector3(0.10, 0.015, 0.022), Vector3(x, 0.208, z), W.material("Connection", WorkshopTheme.TOKENS.success, 0.6), 0.003)
			_world.add_child(indicator)
			indicator.hide()
			_ready_indicators.append(indicator)
		var parcel: Node3D = asset("colis_" + label.to_lower())
		_world.add_child(parcel)
		_parcels[label] = parcel
	reset_parcels()
	set_selected(_selected_index)
	_request_frame()


func _build_tile_batches() -> void:
	var source: Node3D = asset("tuile")
	for node: Node in source.find_children("*", "MeshInstance3D", true, false):
		var mesh := node as MeshInstance3D
		var multimesh := MultiMesh.new()
		multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh.use_colors = true
		multimesh.mesh = mesh.mesh
		multimesh.instance_count = 36
		for index in 36:
			multimesh.set_instance_transform(index, Transform3D(Basis.IDENTITY, cell_position(index)) * mesh.transform)
			var tint: float = 0.985 + float((index * 17 + 7) % 11) * 0.002
			multimesh.set_instance_color(index, Color(tint, tint, tint, 1))
		var instance := MultiMeshInstance3D.new()
		instance.name = "CeramicInstances"
		instance.multimesh = multimesh
		# Flat adjacent slabs don't need to cast onto themselves. Keeping reception
		# enabled preserves station shadows while removing compact shadow-map acne.
		instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		instance.material_override = mesh.material_override
		_world.add_child(instance)
		_tile_batches.append(instance)
	source.free()


func _rebuild_rail(index: int) -> void:
	if _rails.has(index):
		_world.remove_child(_rails[index])
		_rails[index].queue_free()
	var mask: int = _ports[index]
	var straight: bool = mask == 5 or mask == 10
	var rail: Node3D = asset("voie_droite" if straight else "voie_coude")
	rail.rotation.y = (PI * 0.5 if mask == 10 else 0.0) if straight else float({3: 0.0, 6: -PI * 0.5, 12: -PI, 9: -PI * 1.5}.get(mask, 0.0))
	rail.position = cell_position(index)
	rail.set_meta("ports", mask)
	W.color_tracks(rail, "A" if index < 18 else "B")
	_world.add_child(rail)
	_rails[index] = rail
	_request_frame()


func set_route_ready(ready: bool) -> void:
	for indicator: Node3D in _ready_indicators: indicator.visible = ready
	_request_frame()


func reset_parcels() -> void:
	_receipt_signal_sent = false
	super.reset_parcels()


func _complete_receipt(label: String) -> void:
	super._complete_receipt(label)
	var complete: bool = _animation.has("A") and _animation.has("B")
	for address: String in ["A", "B"]:
		var state: Dictionary = get_reception_state(address)
		complete = complete and bool(state["received"]) and bool(state["seal_visible"]) and not bool(state["parcel_visible"])
	if complete and not _receipt_signal_sent:
		_receipt_signal_sent = true
		receipts_finished.emit()
