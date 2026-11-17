// Read-only behavioural comparison: original Web build vs new UI, same browser API.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'../../..');
const {chromium}=require(path.join(root,'tools/.local/web-browser/node_modules/playwright'));
const base=path.join(root,'games/001-switchworks/artifacts/ui-ux-refonte-2026-11-16','storage-compare-'+Date.now());
fs.mkdirSync(base,{recursive:true});
const options={headless:true,executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',viewport:{width:393,height:852},deviceScaleFactor:3,isMobile:true,hasTouch:true};
(async()=>{
 const results=[];
 for(const [label,url] of [['reference-af5','http://127.0.0.1:8784/'],['postal-ui','http://127.0.0.1:8779/']]){
  for(const delay of [280,2000]){
   const directory=path.join(base,label+'-'+delay);let context=await chromium.launchPersistentContext(directory,options);
   let page=context.pages()[0]||await context.newPage(),logs=[];page.on('console',m=>logs.push(m.text()));
   const ready=async()=>{const until=Date.now()+90000;while(!logs.some(x=>x.includes('SLICE_FIRST_FRAME'))&&Date.now()<until)await page.waitForTimeout(100);await page.waitForTimeout(350);};
   await page.goto(url);await ready();
   const line=[...logs].reverse().find(x=>x.includes('SLICE_LAYOUT '));const data=JSON.parse(line.slice(line.indexOf('SLICE_LAYOUT ')+13));const box=await page.locator('#canvas').boundingBox(),p=data.cells['8'];
   await page.touchscreen.tap(box.x+p[0]/data.window[0]*box.width,box.y+p[1]/data.window[1]*box.height);
   await page.waitForTimeout(delay);const rotated=logs.some(x=>x.includes('SLICE_ROTATE index=8 rotations=1'));
   await context.close();
   context=await chromium.launchPersistentContext(directory,options);page=context.pages()[0]||await context.newPage();logs=[];page.on('console',m=>logs.push(m.text()));
   await page.goto(url);await ready();
   const saved=[...logs].reverse().find(x=>x.includes('SLICE_WEB '));const state=saved?JSON.parse(saved.slice(saved.indexOf('SLICE_WEB ')+10)):{};
   results.push({label,delay_after_tap_ms:delay,rotation_observed_before_close:rotated,restored_rotations:state.rotations,restored_ports_hash:state.ports_hash,context:'Windows Chrome isolated profile; no FS sync forced; timing-dependent exploratory sample'});
   await context.close();
  }
 }
 fs.writeFileSync(path.join(base,'receipt.json'),JSON.stringify(results,null,2)+'\n');console.log(base,results);
})().catch(e=>{console.error(String(e));process.exitCode=1;});
