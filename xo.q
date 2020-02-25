//help function stating commands for user
help:{1"To start game or reset, type 'n[ewgame] x': x=0 if you want to move first, x=1 if you want the AI to move first\nTo make a move, type 'm[ove] n' for your position n\n\nPOSITIONS:\n";
	show 5 cut "1|2|34|5|67|8|9";
	1"\n";
 };

//function to get the score of any given board state, dependent on who went first
//if state already in dictionary, just return that, else go recusrsively until final state reached
//if global variable aiFirst=1, then the ai moves first, if aiFirst=0 then the user does
score:{[s]					/board state
	dc:doneCheck[s];				/see if game over, if so can return score
	$[1=dc; 				/ai wins
		:10 + sum s=0;			/score prioritses early victory
	2=dc;	 				/ai loses
		:neg 10+sum s=0;		/score punishes early loss
	3=dc; 					/draw
		:0;				/zero if draw
	];
	if[s in key d[aiFirst]; 		/if score already stored just use that
		:d[aiFirst] s;
	];	
	$[((aiFirst=0) & 0=sum s) or ((aiFirst=1) & 1=sum s); 	/if opponent's move is next
		out:min .z.s each @[s;;:;-1] each where s=0;	/minimise their score
	((aiFirst=0) & (-1)=sum s) or ((aiFirst=1) & 0=sum s); 	/if ai's move is next
		out:max .z.s each @[s;;:;1] each where s=0;	/maxmise its score
	];
	d::.[d;(aiFirst;s);:;out];				/update score dictionary
	:out; 							/return value
 };

//function to nicely show state of board
printBoard:{[s] show {"|" sv enlist each x} each 3 cut (-1 1 0!"OX ")s;};

//function telling ai to make the best move based on its score function
aiMove:{printBoard state:: first 1?b where sc = max sc: score each b:@[x;;:;1] each where x = 0}

//function for player to make move
move:{						/square of player's move - long
	if[not state[x-1]=0;			/check if square is empty; if not display message
		1"That square is already filled; for board indices type 'help[]'\n";
		: ::;
	];
	printBoard state::@[state;x-1;:;-1]; 	/update state with player's move	
	1"\n";
	$[3=doneCheck[state]; 			/if a draw after player's move display message
		1"\nDRAW\n\n";
	2=doneCheck[state]; 				/if player has won display message
		1"\nWELL DONE - YOU WIN!\n\n";
		[aiMove[state]; 		/else ai makes move	
		$[1=doneCheck[state]; 		/if ai has won display message
			1"\nBAD LUCK - YOU LOSE\n\n";
		3=doneCheck[state]; 			/if ai has drawn game display message
			1"\nDRAW\n\n";
		];
		]
	];
 };

//function to make restart game - if called with aiFirst=1, ai goes first, if 0 player goes first
//since ai will draw a perfect player from any starting position, 
//if it goes first a random position is chosen for it, reducing inital computation time
newgame:{[aif]						/argument is aiFirst
	state::0 0 0 0 0 0 0 0 0;			/reset state
	aiFirst::aif;					/assign aiFirst
	$[1=aiFirst;			
		printBoard state::@[state;1?9;:;1];	/ai goes in random position 
		printBoard state			/print blank board
	];
 };

//function to check whether game is finished
//returns 1=>ai wins; 2=>user wins; 3=>draw; 0=>game not finished
doneCheck:{[s] 			/state of board
	/check if full, then all rows, columns and diagonals for a sum of 3 or -3, implying someone has won
	done:(not 0 in s),3 -3 in sum each s (0 3 6+/:0 1 2),(0 1 2+/:0 3 6),(0 4 8;2 4 6);
	$[done[1];		/ai has won
		:1;		
	done[2];		/user has won
		:2;
	done[0];		/draw
		:3;
		:0;		/else return 0
	];
 };

/define easy short function names for user
n:newgame;
m:move;

/set random seed to time value so every restart different
system"S ",string "i"$.z.t;

/initialise list of 2 dictionaries - one for each starting player
d: (d;d:(enlist (1 -1 1 1 -1 1 -1 1 -1))!enlist 0);

/welcome banner
1"\n-------------Welcome to TastyXO-----------------\n\n";

help[]
