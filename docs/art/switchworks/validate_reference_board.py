from pathlib import Path
import json
root=Path(__file__).resolve().parents[3]
data=json.loads((root/'docs/art/switchworks/EXEMPLE_PLATEAU_6X6.json').read_text(encoding='utf8'))
D={'N':(0,-1),'E':(1,0),'S':(0,1),'W':(-1,0)}
OPP={'N':'S','E':'W','S':'N','W':'E'}
CW={'N':'E','E':'S','S':'W','W':'N'}
def board(values): return {(x,y):set(v) for y,row in enumerate(values) for x,v in enumerate(row) if v}
sources={key:(v[1]-1,v[0]-1)for key,v in data['sources'].items()}
goals={key:(v[1]-1,v[0]-1)for key,v in data['destinations'].items()}
fixed=set(sources.values())|set(goals.values())
def rotate(state,pos):
 if pos in fixed: raise ValueError('fixed station')
 result={p:v.copy() for p,v in state.items()}; result[pos]={CW[d]for d in result[pos]}; return result
def trace(state,label):
 pos=sources[label]; direction='E'; seen=[pos]
 while len(seen)<=36:
  dx,dy=D[direction]; nxt=(pos[0]+dx,pos[1]+dy)
  if nxt not in state or OPP[direction]not in state[nxt]:return False,seen
  if nxt in goals.values():return nxt==goals[label],seen+[nxt]
  if nxt in seen:return False,seen+[nxt]
  seen.append(nxt);direction=(state[nxt]-{OPP[direction]}).pop();pos=nxt
 return False,seen
initial=board(data['initial_grid']);solved=board(data['solved_grid'])
step1=rotate(initial,(2,1));corrected=rotate(step1,(3,3))
checks={
 'all_tiles_two_ports':all(len(v)==2 for v in solved.values()),
 'initial_both_fail':all(not trace(initial,l)[0] for l in sources),
 'one_rotation_fixes_only_A':trace(step1,'A')[0]and not trace(step1,'B')[0],
 'two_rotations_solve_both':all(trace(corrected,l)[0]for l in sources)and corrected==solved,
 'routes_disjoint':not(set(trace(solved,'A')[1])&set(trace(solved,'B')[1]))}
loop=initial
for _ in range(4):loop=rotate(loop,(2,1))
checks['four_rotations_identity']=loop==initial
try:rotate(initial,sources['A']);checks['fixed_station_rejected']=False
except ValueError:checks['fixed_station_rejected']=True
assert checks==data['checks'] and all(checks.values()),checks
for label,path in data['paths'].items():assert trace(solved,label)[1]==[(p[1]-1,p[0]-1)for p in path]
print(json.dumps({'board':data['id'],'passed':len(checks),'failed':0,'checks':checks},indent=2))
