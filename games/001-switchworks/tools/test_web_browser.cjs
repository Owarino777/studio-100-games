// Real WASM/browser smoke test. Mobile emulation is not an iPhone/Safari result.
const path = require('path');
const fs = require('fs');
const assert = require('assert');
const crypto = require('crypto');
const root = path.resolve(__dirname, '../../..');
const {chromium} = require(path.join(root, 'tools/.local/web-browser/node_modules/playwright'));
const url = process.env.STUDIO_WEB_URL || 'http://127.0.0.1:8765/';
const profileName=process.env.STUDIO_WEB_PROFILE || 'pro';
const passwordFile=process.env.STUDIO_WEB_PASSWORD_FILE;
const password=passwordFile?fs.readFileSync(passwordFile,'utf8').trim():null;
const viewports={pro:{width:393,height:852},max:{width:430,height:932},landscape:{width:852,height:393}};
assert(viewports[profileName],'Unknown test viewport');
const out = path.join(root, 'games/001-switchworks/artifacts/web-test/browser-' + new Date().toISOString().replace(/[:.]/g, '-'));
fs.mkdirSync(out, {recursive: true});

(async () => {
  const options={headless:true,executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',viewport:viewports[profileName],deviceScaleFactor:3,isMobile:true,hasTouch:true,locale:'fr-FR'};
  if(password) options.httpCredentials={username:'studio',password};
  const profile=path.join(out,'isolated-browser-profile');
  let context=await chromium.launchPersistentContext(profile,options);
  let page=context.pages()[0] || await context.newPage();
  let logs = [], errors = [];
  const receipt = {scope:'Windows Chrome actual WASM execution, touch/mobile emulation; not physical iPhone or Safari',profile:profileName,url,checks:[],status:'running'};
  const observe=target=>{
    target.on('console',message=>{logs.push(message.text());if(message.type()==='error')errors.push(message.text());});
    target.on('pageerror',error=>errors.push(error.message));
    target.on('dialog',async dialog=>{errors.push('Browser dialog: '+dialog.message());await dialog.dismiss();});
  };
  observe(page);
  const check = (name, condition, detail) => {
    receipt.checks.push({name,passed:Boolean(condition),detail});
    if(!condition) throw new Error(name);
  };
  const waitLog = async (token, cursor=0, timeout=60000) => {
    const end=Date.now()+timeout;
    while(Date.now()<end) {if(logs.slice(cursor).some(line=>line.includes(token))) return; await page.waitForTimeout(100);}
    throw new Error('Missing console marker: '+token);
  };
  const jsonLog = prefix => {
    const text=[...logs].reverse().find(line=>line.includes(prefix));
    if(!text) throw new Error('No marker: '+prefix);
    return JSON.parse(text.slice(text.indexOf(prefix)+prefix.length));
  };
  const tap = async (group,key) => {
    const state=jsonLog('SLICE_LAYOUT '), rect=await page.locator('#canvas').boundingBox();
    const point=state[group][String(key)];
    await page.touchscreen.tap(rect.x+point[0]/state.window[0]*rect.width,rect.y+point[1]/state.window[1]*rect.height);
    await page.waitForTimeout(260);
  };
  try {
    const headers=password?{Authorization:'Basic '+Buffer.from('studio:'+password).toString('base64')}:{};
    const response=await fetch(new URL('index.pck',url),{headers});
    check('pack request accepted',response.ok,{status:response.status});
    const served=Buffer.from(await response.arrayBuffer());
    receipt.served_pck_sha256=crypto.createHash('sha256').update(served).digest('hex');
    const local=fs.readFileSync(path.join(root,'games/001-switchworks/build/web-safari/index.pck'));
    check('served PCK equals current export',receipt.served_pck_sha256===crypto.createHash('sha256').update(local).digest('hex'));
    const start=Date.now(); await page.goto(url,{waitUntil:'load'}); await waitLog('SLICE_READY'); await waitLog('SLICE_FIRST_FRAME');
    receipt.initial_load_ms=Date.now()-start;
    check('actual Godot canvas loaded',await page.locator('#canvas').isVisible());
    check('single threaded export',await page.evaluate(()=>typeof GODOT_THREADS_ENABLED!=='undefined' && GODOT_THREADS_ENABLED===false));
    check('no cross origin isolation required',await page.evaluate(()=>crossOriginIsolated===false));
    receipt.environment=await page.evaluate(()=>({userAgent:navigator.userAgent,secureContext:isSecureContext,css:[innerWidth,innerHeight],dpr:devicePixelRatio,canvas:[document.querySelector('canvas').width,document.querySelector('canvas').height]}));
    await page.screenshot({path:path.join(out,'planning.png')});
    let cursor=logs.length; await tap('cells',8); await waitLog('SLICE_ROTATE index=8 rotations=1',cursor);
    check('one touch gives exactly one rotation',logs.slice(cursor).filter(line=>line.includes('SLICE_ROTATE')).length===1);
    await page.waitForTimeout(1300); // Let the engine's asynchronous persistent filesystem synchronize.
    const count=logs.length; await page.reload({waitUntil:'load'}); await waitLog('SLICE_LOCAL_STATE_RESTORED',count); await waitLog('SLICE_WEB ',count);
    const restored=jsonLog('SLICE_WEB ');
    check('reload restores real saved preparation',restored.rotations===1,restored);
    await page.screenshot({path:path.join(out,'restored.png')});
    // Restart through the real existing menu, without clearing browser storage.
    await tap('buttons','pause'); await tap('buttons','restart');
    cursor=logs.length; await tap('buttons','dispatch'); await waitLog('SLICE_RESULT success=false',cursor);
    await page.screenshot({path:path.join(out,'failed.png')});
    for(const index of [8,16,19,21,25,27]) await tap('cells',index);
    cursor=logs.length; await tap('buttons','dispatch'); await waitLog('SLICE_RESULT success=true',cursor);
    await page.waitForTimeout(650);
    check('both local reception animations completed',logs.slice(cursor).some(x=>x.includes('SLICE_RECEIVED address=A')) && logs.slice(cursor).some(x=>x.includes('SLICE_RECEIVED address=B')));
    await page.screenshot({path:path.join(out,'won.png')});
    // Headless tab focus is not an iOS Home event; record that limit explicitly.
    const before=logs.length, other=await context.newPage(); await other.goto('about:blank'); await other.bringToFront(); await page.waitForTimeout(500); await page.bringToFront();
    receipt.headless_visibility=await page.evaluate(()=>({hidden:document.hidden,state:document.visibilityState,focus:document.hasFocus()}));
    if(!logs.slice(before).some(line=>line.includes('SLICE_PAUSE'))){
      receipt.suspension_test='Synthetic browser blur/focus events; physical Safari Home remains untested';
      await page.evaluate(()=>window.dispatchEvent(new Event('blur')));
      await page.evaluate(()=>window.dispatchEvent(new Event('focus')));
    }else receipt.suspension_test='Observed desktop tab event; not physical Safari Home';
    await waitLog('SLICE_PAUSE',before);
    check('page return stays paused',jsonLog('SLICE_WEB ').phase==='paused');
    await page.screenshot({path:path.join(out,'returned-paused.png')});
    await other.close(); await tap('buttons','resume');
    const restartCursor=logs.length;
    await context.close();
    context=await chromium.launchPersistentContext(profile,options);
    page=context.pages()[0] || await context.newPage();observe(page);
    await page.goto(url,{waitUntil:'load'});await waitLog('SLICE_LOCAL_STATE_RESTORED',restartCursor);await waitLog('SLICE_WEB ',restartCursor);
    const reopened=jsonLog('SLICE_WEB ');
    check('full desktop browser restart keeps preparation',reopened.rotations===6 && reopened.attempts===2,reopened);
    await page.screenshot({path:path.join(out,'browser-restarted.png')});
    receipt.status='passed';
    check('no script or fatal browser error',!errors.some(e=>/SCRIPT ERROR|RuntimeError|abort\(|Failed to load.*wasm|WebGL.*INVALID/i.test(e)),errors);
  } catch(error) {
    receipt.status='failed';receipt.error=error.stack;
    try{await page.screenshot({path:path.join(out,'failure.png')});}catch{}
  } finally {
    receipt.console_errors=errors;
    fs.writeFileSync(path.join(out,'console.log'),logs.join('\n')+'\n');
    fs.writeFileSync(path.join(out,'receipt.json'),JSON.stringify(receipt,null,2));
    await context.close();
    process.stdout.write(JSON.stringify({out,status:receipt.status,error:receipt.error,checks:receipt.checks},null,2)+'\n');
    if(receipt.status!=='passed') process.exitCode=1;
  }
})();
