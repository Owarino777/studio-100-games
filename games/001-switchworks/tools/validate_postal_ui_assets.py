#!/usr/bin/env python3
"""Independent GLB geometry, SVG structure and design-token contrast inspection."""
from pathlib import Path
import hashlib
import json
import re
import xml.etree.ElementTree as ET
import validate_littoral_models as geometry

GAME = Path(__file__).resolve().parents[1]


def luminance(value: str) -> float:
    values = [int(value[i:i+2], 16)/255 for i in [0,2,4]]
    linear = [v/12.92 if v <= .04045 else ((v+.055)/1.055)**2.4 for v in values]
    return sum(a*b for a,b in zip(linear,[.2126,.7152,.0722]))


def main() -> None:
    models = [geometry.inspect(p) for p in sorted((GAME/'assets/postal-workshop/models').glob('*.glb'))]
    assert len(models) == 10
    assert not any(m['degenerate_triangles'] or m['faces_against_normals'] for m in models)
    icons=[]
    for p in sorted((GAME/'ui/workshop/icons').glob('*.svg')):
        document=ET.parse(p).getroot()
        assert document.attrib['viewBox']=='0 0 24 24'
        assert document.attrib['width']==document.attrib['height']=='16'
        assert document.find('{http://www.w3.org/2000/svg}path') is not None
        icons.append({'path':p.relative_to(GAME).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
    pairs=[('ink/surface','183b47','f5f3ea'),('ink/background','183b47','e8ebe6'),('surface/primary','f5f3ea','234f5d'),('muted/background','52636a','e8ebe6'),('label A','f5f3ea','306c87'),('label B','f5f3ea','a9563f')]
    contrasts=[]
    for name,a,b in pairs:
        x,y=sorted([luminance(a),luminance(b)])
        ratio=(y+.05)/(x+.05)
        contrasts.append({'pair':name,'ratio':round(ratio,3),'scope':'semantic sRGB tokens,not actual 3D pixels or WCAG certification'})
        assert ratio>=4.5,(name,ratio)
    out=GAME/'artifacts/ui-ux-refonte-2026-11-16/asset-validation.json'
    out.write_text(json.dumps({'models':models,'svg_icons':icons,'contrasts':contrasts},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print('Assets:10 GLB,',len(icons),'SVG; no inspected geometry issue. Contrasts:',contrasts)


if __name__=='__main__': main()
