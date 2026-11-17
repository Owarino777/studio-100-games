#!/usr/bin/env python3
"""Quiet native sample, no video encoder/browser; only the dedicated study package."""
from pathlib import Path
from datetime import datetime, timezone
import json
import re
import time
import verify_android_slice as p


def run():
    package = 'org.studio100games.switchworks.postal.ui'
    out=p.GAME/'artifacts/ui-ux-refonte-2026-11-16'/('android-quiet-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
    out.mkdir(parents=True)
    p.PACKAGE=package;p.OUT=out;p.REPORT={'checks':[]}
    before_size=p.adb('shell','wm','size');before_density=p.adb('shell','wm','density')
    s=re.search(r'Override size:\s*(\d+x\d+)',before_size);d=re.search(r'Override density:\s*(\d+)',before_density)
    results=[]
    try:
        assert p.adb('emu','avd','name').splitlines()[0]==p.AVD
        p.adb('shell','wm','size','1080x2340');p.adb('shell','wm','density','480')
        p.REPORT['activity']=p.adb('shell','cmd','package','resolve-activity','--brief',package).splitlines()[-1]
        p.adb('shell','am','force-stop',package);p.launch()
        level=json.loads((p.GAME/'data/archipel_double_flux.json').read_text(encoding='utf-8'))
        for i in range(3):
            p.pause();p.tap('buttons','restart');p.solve(level)
            cursor=len(p.logs());p.tap('buttons','dispatch');p.wait_event('POSTAL_UI_RECEIPTS_FINISHED',cursor)
            raw=p.logs()[cursor:]
            metric=[json.loads(l.split('LITTORAL_PERF ',1)[1]) for l in raw.splitlines() if 'LITTORAL_PERF ' in l][-1]
            results.append(metric);time.sleep(.4)
        (out/'runtime.log').write_text(p.logs(),encoding='utf-8')
        (out/'memory.log').write_text(p.adb('shell','dumpsys','meminfo',package),encoding='utf-8')
    finally:
        p.adb('shell','wm','size',s.group(1) if s else 'reset');p.adb('shell','wm','density',d.group(1) if d else 'reset')
        (out/'receipt.json').write_text(json.dumps({'context':'AVD host,1080x2340,density480; no video recording; not physical phone/GPU timing','samples':results,'restore_size':p.adb('shell','wm','size'),'restore_density':p.adb('shell','wm','density')},indent=2)+'\n',encoding='utf-8')
        print(out,results,flush=True)


if __name__=='__main__':run()
