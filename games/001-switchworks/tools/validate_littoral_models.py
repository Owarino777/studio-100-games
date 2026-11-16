#!/usr/bin/env python3
"""Inspect actual GLB bytes, geometry and embedded resources; no extra dependency."""
from __future__ import annotations
import hashlib
import json
import math
from pathlib import Path
import struct

GAME = Path(__file__).resolve().parents[1]
WIDTHS = {"SCALAR": 1, "VEC2": 2, "VEC3": 3, "VEC4": 4}
COMPONENTS = {5126: ("f", 4), 5125: ("I", 4), 5123: ("H", 2), 5121: ("B", 1)}


def read_glb(path: Path):
    data = path.read_bytes()
    assert data[:4] == b"glTF" and struct.unpack_from("<II", data, 4) == (2, len(data))
    length, kind = struct.unpack_from("<II", data, 12)
    assert kind == 0x4E4F534A
    document = json.loads(data[20:20 + length])
    offset = 20 + length
    binary_length, binary_kind = struct.unpack_from("<II", data, offset)
    assert binary_kind == 0x004E4942
    return document, data[offset + 8:offset + 8 + binary_length]


def accessor(document: dict, binary: bytes, index: int):
    item = document["accessors"][index]
    view = document["bufferViews"][item["bufferView"]]
    code, width = COMPONENTS[item["componentType"]]
    count = WIDTHS[item["type"]]
    start = view.get("byteOffset", 0) + item.get("byteOffset", 0)
    stride = view.get("byteStride", width * count)
    assert start + max(0, item["count"] - 1) * stride + width * count <= len(binary)
    return [struct.unpack_from("<" + code * count, binary, start + i * stride) for i in range(item["count"])]


def inspect(path: Path) -> dict:
    document, binary = read_glb(path)
    assert document["asset"]["version"] == "2.0"
    assert not any("uri" in row for row in document.get("buffers", []) + document.get("images", [])), "External dependency"
    vertices = []
    rail_vertices = []
    triangles = 0
    degenerate = 0
    reversed_faces = 0
    for mesh in document.get("meshes", []):
        for primitive in mesh["primitives"]:
            assert primitive.get("mode", 4) == 4
            positions = accessor(document, binary, primitive["attributes"]["POSITION"])
            normals = accessor(document, binary, primitive["attributes"]["NORMAL"])
            assert len(positions) == len(normals)
            assert all(math.isfinite(v) for row in positions + normals for v in row)
            assert all(sum(v * v for v in row) > 0.5 for row in normals)
            indices = [row[0] for row in accessor(document, binary, primitive["indices"])] if "indices" in primitive else list(range(len(positions)))
            assert len(indices) % 3 == 0 and all(0 <= i < len(positions) for i in indices)
            triangles += len(indices) // 3
            vertices += positions
            material_name = document.get("materials", [])[primitive.get("material", 0)].get("name", "")
            if material_name == "PaintedMetal": rail_vertices += positions
            for n in range(0, len(indices), 3):
                ids = indices[n:n + 3]
                a, b, c = [positions[i] for i in ids]
                u = [b[i] - a[i] for i in range(3)]
                v = [c[i] - a[i] for i in range(3)]
                cross = [u[1]*v[2]-u[2]*v[1], u[2]*v[0]-u[0]*v[2], u[0]*v[1]-u[1]*v[0]]
                area2 = math.sqrt(sum(x*x for x in cross))
                if area2 < 1e-10:
                    degenerate += 1
                else:
                    normal = [sum(normals[i][axis] for i in ids) for axis in range(3)]
                    if sum(cross[i]*normal[i] for i in range(3)) < -area2 * 0.10: reversed_faces += 1
            assert 0 <= primitive.get("material", 0) < len(document.get("materials", []))
    for material in document.get("materials", []):
        pbr = material.get("pbrMetallicRoughness", {})
        assert 0 <= pbr.get("roughnessFactor", 1) <= 1
        assert 0 <= pbr.get("metallicFactor", 1) <= 1
    assert vertices
    ports = [{"name": x["name"], "translation": x.get("translation", [0, 0, 0])} for x in document["nodes"] if x.get("name") in ["Port1", "Port2", "Port4", "Port8"]]
    expected = {"voie_droite": [1, 4], "voie_coude": [1, 2], "guichet_a": [2], "guichet_b": [2], "boite_a": [8], "boite_b": [8]}.get(path.stem)
    visible_ports = []
    if expected is not None:
        for mask, axis, sign in [(1, 2, -1), (2, 0, 1), (4, 2, 1), (8, 0, -1)]:
            edge = [v for v in rail_vertices if v[axis] * sign > 0.495 and 0.14 < v[1] < 0.21]
            if edge:
                visible_ports.append(mask)
                other = 2 if axis == 0 else 0
                assert abs(sum(v[other] for v in edge) / len(edge)) < 0.02, "Rail border not centred"
        assert sorted(visible_ports) == sorted(expected), "Visible rail border disagrees with real ports"
    return {"id": path.stem, "bytes": path.stat().st_size, "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            "mesh_triangles": triangles, "degenerate_triangles": degenerate, "faces_against_normals": reversed_faces,
            "local_mesh_bounds_before_node_transforms": [[min(v[i] for v in vertices) for i in range(3)], [max(v[i] for v in vertices) for i in range(3)]],
            "ports": ports, "rail_geometry_border_ports": visible_ports, "embedded_dependencies": True,
            "limitations": "GLB structure and geometry inspection, not full Khronos certification; open rail end caps and separated solids intentional; animation checked in Godot"}


def main() -> None:
    rows = [inspect(p) for p in sorted((GAME / "assets/littoral-study/models").glob("*.glb"))]
    assert len(rows) == 9
    out = GAME / "artifacts/art-study-2026-11-16/model-validation.json"
    out.write_text(json.dumps({"models": rows}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    for row in rows: print(row["id"], "triangles", row["mesh_triangles"], "degenerate", row["degenerate_triangles"], "faces_against_normals", row["faces_against_normals"])
    assert not any(x["degenerate_triangles"] or x["faces_against_normals"] for x in rows), "Geometry issues need correction"
    print("9 GLB models: checks passed")


if __name__ == "__main__": main()
