dicts: (d;d:(enlist (1 -1 1 1 -1 1 -1 1 -1))!enlist 0)
score:{$[(o:3 -3 in sum each x (0 3 6+/:0 1 2),(0 1 2+/:0 3 6),(0 4 8;2 4 6))[0]; /ai wins
		10 + sum x=0;
	o[1]; /ai loses
		neg 10+sum x=0;
	0 = max x = 0; /draw
		0;

		$[x in key dicts[aifirst]; /else score
			dicts[aifirst] x; /if already in dict return value
			
			[$[((aifirst=0) & 0=sum x) or ((aifirst=1) & 1=sum x); /if opponent's move is next
				out:min .z.s each @[x;;:;-1] each where x=0;
			((aifirst=0) & (-1)=sum x) or ((aifirst=1) & 0=sum x); /if ai's move is next
				out:max .z.s each @[x;;:;1] each where x=0;
				
				'oh no /shouldn't happen
			];
		dicts::.[dicts;(aifirst;x);:;out];out /update dictionary with score
			]
		]
	]}
/aifirst=1,computer first;aifirst=0,player first
printboard:{{"|" sv enlist each x} each 3 cut (-1 1 0!"OX ")x} /show status
aimove:{printboard state:: first 1?b where sc = max sc: score each b:@[x;;:;1] each where x = 0} /make move
move:{$[state[x-1]=0; /if square empty
	[state::@[state;x-1;:;-1]; /update state
	show printboard state;
	1"\n";
	$[3=donecheck[]; /if a draw after player move
		[1"\nDRAW\n\n";];
	2=donecheck[]; /if player has won
		[1"\nWELL DONE - YOU WIN!\n\n";];
		
		[show aimove[state]; /else ai makes move
		$[1=donecheck[]; /if ai has won
			[1"\nBAD LUCK - YOU LOSE\n\n";];
		3=donecheck[]; /if ai has drawn game
			[1"\nDRAW\n\n";]
		]
		]
	]
	];
	
	1"That square is already filled; for board indices type 'help[]'\n"; /if square already full
	]}
newgame:{state::0 0 0 0 0 0 0 0 0;
	aifirst::x;
	$[1=aifirst;
		printboard state::@[state;1?9;:;1];

		printboard[state]
	]}
donecheck:{done:(not 0 in state),3 -3 in sum each state (0 3 6+/:0 1 2),(0 1 2+/:0 3 6),(0 4 8;2 4 6);
	$[done[1];
		1;
	done[2];
		2;
	done[0];
		3;
		
		0
	]} 
/ 1 if AI wins; 2 if user wins; 3 if draw; else 0
n:newgame
m:move
system"S ",string "i"$.z.t
help:{1"To start game or reset, type 'n[ewgame] x': x=0 if you want to move first, x=1 if you want the AI to move first\nTo make a move, type 'm[ove] n' for your position n\n\nPOSITIONS:\n"; show 5 cut "1|2|34|5|67|8|9";1"\n";}
1"\n-------------Welcome to TastyXO-----------------\n\n";
help[]
