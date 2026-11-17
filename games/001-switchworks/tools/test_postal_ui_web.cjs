// Actual Godot WASM, isolated Chrome profile. Never a Safari/physical-device claim.
const fs=require('fs'),path=require('path'),crypto=require('crypto'),assert=require('assert');
const root=path.resolve(__dirname,'../../..');
const {chromium}=require(path.join(root,'tools/.local/web-browser/node_modules/playwright'));
const url=process.env.POSTAL_UI_URL || 'http://127.0.0.1:8777/';
const profile=process.env.POSTAL_UI_PROFILE || 'pro';
const sizes={pro:{width:393,height:852},compact:{width:360,height:640},landscape:{width:844,height:390}};
const out=path.join(root,'games/001-switchworks/artifacts/ui-ux-refonte-2026-11-16','web-'+profile+'-'+Date.now());
fs.mkdirSync(out,{recursive:true});
(async()=>{
 const options={headless:true,executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',viewport:sizes[profile],deviceScaleFactor:3,isMobile:true,hasTouch:true,locale:'fr-FR'};
 const context=await chromium.launchPersistentContext(path.join(out,'isolated-profile'),options);
 const page=context.pages()[0] || await context.newPage();
 let reopenedContext=null;
 let logs=[],errors=[];
 page.on('console',m=>{logs.push(m.text());if(m.type()==='error')errors.push(m.text());});
 page.on('pageerror',e=>errors.push(e.message));
 const receipt={context:'Windows Chrome actual WASM, mobile/touch emulation; not Safari or physical iPhone',url,profile,checks:[],loads:[],errors};
 const cdp=await context.newCDPSession(page), requests={};
 receipt.http_responses=[];
 await cdp.send('Network.enable');
 cdp.on('Network.requestWillBeSent',e=>{requests[e.requestId]=new URL(e.request.url).pathname;});
 cdp.on('Network.responseReceivedExtraInfo',e=>{const file=requests[e.requestId];if(file && /index\.(js|wasm|pck)$/.test(file))receipt.http_responses.push({file,status:e.statusCode});});
 const check=(name,ok,detail)=>{receipt.checks.push({name,passed:!!ok,detail});assert(ok,name);};
 const wait=async(token,cursor=0)=>{const end=Date.now()+90000;while(Date.now()<end){if(logs.slice(cursor).some(l=>l.includes(token)))return;await page.waitForTimeout(100);}throw Error('Missing '+token);};
 const latest=prefix=>{const l=[...logs].reverse().find(x=>x.includes(prefix));if(!l)throw Error('No '+prefix);return JSON.parse(l.slice(l.indexOf(prefix)+prefix.length));};
 const tap=async(group,key)=>{const state=latest('SLICE_LAYOUT '),box=await page.locator('#canvas').boundingBox(),point=state[group][String(key)];await page.touchscreen.tap(box.x+point[0]/state.window[0]*box.width,box.y+point[1]/state.window[1]*box.height);await page.waitForTimeout(280);};
 const shot=async(name)=>page.screenshot({path:path.join(out,name+'.png')});
 const resources=async()=>page.evaluate(()=>performance.getEntriesByType('resource').filter(r=>/index\.(wasm|pck|js)/.test(r.name)).map(r=>({name:new URL(r.name).pathname,transferSize:r.transferSize,encodedBodySize:r.encodedBodySize,duration:r.duration})));
 try{
  let cursor=logs.length,start=Date.now();
  const pckResponse=page.waitForResponse(r=>r.url().includes('/index.pck'));
  await page.goto(url,{waitUntil:'domcontentloaded'});
  await wait('SLICE_FIRST_FRAME',cursor);await page.waitForTimeout(400);
  receipt.loads.push({kind:'cold fresh isolated browser profile',elapsed_until_first_frame_ms:Date.now()-start,resources:await resources()});
  const packed=await (await pckResponse).body();
  check('exact current pack served',crypto.createHash('sha256').update(packed).digest('hex')===crypto.createHash('sha256').update(fs.readFileSync(path.join(root,'games/001-switchworks/build/web-postal-ui/index.pck'))).digest('hex'));
  check('real engine canvas',await page.locator('#canvas').count()===1);
  check('no WASM threads',await page.evaluate(()=>typeof GODOT_THREADS_ENABLED!=='undefined' && GODOT_THREADS_ENABLED===false));
  await shot('01-preparation');
  await tap('cells',8);await wait('SLICE_ROTATE index=8 rotations=1',cursor);await page.waitForTimeout(300);await shot('02-rotation');
  cursor=logs.length;
  await page.evaluate(()=>window.dispatchEvent(new Event('pagehide')));
  await wait('SLICE_WEB ',cursor);
  const before=latest('SLICE_WEB ');
  cursor=logs.length;start=Date.now();
  await page.reload({waitUntil:'domcontentloaded'});await wait('SLICE_FIRST_FRAME',cursor);await page.waitForTimeout(400);
  receipt.loads.push({kind:'warm same-origin reload',elapsed_until_first_frame_ms:Date.now()-start,resources:await resources()});
  const restored=latest('SLICE_WEB ');
  check('reload preserves exact rotation',restored.rotations===1 && restored.ports_hash===before.ports_hash && latest('SLICE_LAYOUT ').phase==='planning',{before,restored});
  await shot('restored');
  await tap('buttons','pause');await tap('buttons','restart');
  check('restart initial preparation',latest('SLICE_LAYOUT ').phase==='planning');
  await tap('buttons','hint');
  cursor=logs.length;await tap('buttons','dispatch');await wait('SLICE_RESULT success=false',cursor);await shot('error');
  await tap('buttons','pause');await tap('buttons','restart');
  const level=JSON.parse(fs.readFileSync(path.join(root,'games/001-switchworks/data/archipel_double_flux.json'),'utf8'));
  for(const move of level.solution_commands)for(let i=0;i<move.quarter_turns;i++)await tap('cells',move.index);
  check('ready derives from real model',latest('SLICE_GUIDANCE ').state==='planning_ready');await shot('04-ready');
  cursor=logs.length;await tap('buttons','dispatch');await shot('05-transport');
  await wait('SLICE_RESULT success=true',cursor);await wait('POSTAL_UI_RECEIPTS_FINISHED',cursor);await page.waitForTimeout(150);await shot('06-won');
  check('two local receptions',logs.slice(cursor).some(x=>x.includes('SLICE_RECEIVED address=A')) && logs.slice(cursor).some(x=>x.includes('SLICE_RECEIVED address=B')));
  await tap('buttons','pause');await shot('07-paused-won');
  check('pause state observed',latest('SLICE_LAYOUT ').phase==='paused');
  await tap('buttons','resume');await tap('buttons','dispatch');
  check('same primary control replays',latest('SLICE_LAYOUT ').phase==='planning');
  cursor=logs.length;await page.evaluate(()=>window.dispatchEvent(new Event('blur')));await wait('SLICE_PAUSE',cursor);
  await page.evaluate(()=>window.dispatchEvent(new Event('focus')));await shot('synthetic-return-paused');
  check('browser callback remains paused',latest('SLICE_LAYOUT ').phase==='paused',{limitation:'synthetic blur/focus, not physical iOS Home'});
  await tap('buttons','resume');
  await tap('cells',8);
  cursor=logs.length;await page.evaluate(()=>window.dispatchEvent(new Event('pagehide')));await wait('SLICE_WEB ',cursor);
  const closed=latest('SLICE_WEB ');
  const syncStart=Date.now();let durable=null;
  while(Date.now()-syncStart<15000){
   durable=await page.evaluate(async()=>{
    for(const item of await indexedDB.databases()){
     const db=await new Promise((ok,no)=>{const q=indexedDB.open(item.name);q.onsuccess=()=>ok(q.result);q.onerror=()=>no(q.error);});
     for(const name of db.objectStoreNames){
      const values=await new Promise((ok,no)=>{const tx=db.transaction(name,'readonly'),store=tx.objectStore(name),rows=[];const q=store.openCursor();q.onsuccess=()=>{const c=q.result;if(!c){ok(rows);return;}if(String(c.key).endsWith('littoral_composition_v1.json')){try{rows.push(JSON.parse(new TextDecoder().decode(c.value.contents)));}catch{}}c.continue();};q.onerror=()=>no(q.error);});
      if(values.length){db.close();return values[0];}
     }db.close();
    }return null;
   });
   if(durable?.rotations===closed.rotations)break;
   await page.waitForTimeout(100);
  }
  receipt.indexeddb_observation={elapsed_ms:Date.now()-syncStart,rotation:durable?.rotations,scope:'read-only public IndexedDB API; never forces FS sync or writes a save'};
  check('last preparation observed durably before close',durable?.rotations===closed.rotations,receipt.indexeddb_observation);
  await context.close();
  const reopened=await chromium.launchPersistentContext(path.join(out,'isolated-profile'),options);
  reopenedContext=reopened;
  const p2=reopened.pages()[0] || await reopened.newPage(), second=[];
  p2.on('console',m=>second.push(m.text()));p2.on('pageerror',e=>errors.push(e.message));
  await p2.goto(url,{waitUntil:'domcontentloaded'});
  const end=Date.now()+90000;while(Date.now()<end && !second.some(x=>x.includes('SLICE_FIRST_FRAME')))await p2.waitForTimeout(100);
  const line=[...second].reverse().find(x=>x.includes('SLICE_WEB '));
  const persisted=line?JSON.parse(line.slice(line.indexOf('SLICE_WEB ')+10)):{};
  check('browser process restart restores exact preparation',persisted.rotations===closed.rotations && persisted.ports_hash===closed.ports_hash,{persisted,closed});
  await p2.screenshot({path:path.join(out,'browser-restarted.png')});
  logs.push(...second);await reopened.close();
  check('runtime has no fatal browser errors',errors.length===0,errors);
  receipt.status='passed';
 }catch(e){receipt.status='failed';receipt.error=String(e);throw e;}
 finally{fs.writeFileSync(path.join(out,'console.log'),logs.join('\n')+'\n');fs.writeFileSync(path.join(out,'receipt.json'),JSON.stringify(receipt,null,2)+'\n');if(reopenedContext)await reopenedContext.close();await context.close();process.stdout.write(out+' '+receipt.status+'\n');}
})().catch(e=>{process.stderr.write(String(e)+'\n');process.exitCode=1;});
