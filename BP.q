//NB: functions and formulae below assume a sigmoid function applied to each node
//with constant bias and exactly one hidden layer of nodes
//error function is sum square difference between desired output and actual output

//sigmoid function
sigma:{1%1+exp neg x}

//create random weights with giiven structure between -1 and 1
//argument:layer structure as list eg makeWeights[3 5 3]
//output: nested list
makeWeights:{{(y+1) cut (-1) + (x*y+1)?2f}':[x[0];1_x]}

//make specified number of random weights
//arguments: layer structure list; number of weights
makeWeightsMult:{{y,enlist makeWeights[x]}[x]/[y-1;enlist makeWeights[x]]}

//arguments: input values; weights
//input must have same length as first layer of weights
//output: length 3 list - (input; hidden nodes; output)
nodes:{((enlist "f"$x), {raze sigma y mmu "f"$1,x}\[x;y])}

//arguments: input values; weights
//same as final output element of nodes function
out:{{raze sigma y mmu "f"$1,x}/[x;y]}

//calculates the gradient of error function wrt each weight between hidden layer and output nodes
//arguments:penultimate layer of nodes; final layer of nodes;desired output
grad1:{(1f,x)*/:2*y*(1-y)*(y-z)}

//calculates gradient of error function wrt each weight between input and hidden nodes
//arguments:input node values; hidden node values; output node values; desired output; final layer of weights (between hidden and output)
//output list structure same as that of first element of weights
grad0:{[i;h;o;obar;w] (1f,i)*/:h*(1-h)*1_ sum 2*(o-obar)*w}

//calculates gradient of error wrt each weight
//arguments: input node values; desired output; weights
backPGrad:{[input;obar;w] n:nodes["f"$input;w];(grad0[n[0];n[1];n[2];obar;w[1]];grad1[n[1];n[2];obar])}

//sums gradient of error wrt weights over all input values
//inputs and desired outputs must be same length
//arguments: weights; inputs; desired outputs
backPOverallGrad:{[w;ins;outs] {[w;x;y;z] x+backPGrad[y;z;w]}[w]/[0;ins;outs]}

//get average error function (average per output node) over input
//NB: low 'score' is good
//arguments: weights; inputs; desired outputs
getScore:{[w;ins;outs] avg avg ((out[;w] each ins) - outs) xexp 2}

//overall function for this script
//alpha parameter scales change of weights in proportion to error function gradient
//at each iteration print score - should be going down
//typical alpha paramter values: 10-0.01
//arguments: inputs; desired outputs; starting weights; alpha step parameter; number of iterations
//output: new weights
backP:{[ins;outs;w;alpha;its]
	{[alpha;ins;outs;w]
		show getScore[w;ins;outs];
		w-(alpha%count ins )*backPOverallGrad[w;ins;outs]
	}[alpha;ins;outs]/[its;w]
 };

//same as backP, but only scores at the end: not scoring at each iteration speeds up process
backPQuiet:{[ins;outs;w;alpha;its]
	output:{[alpha;ins;outs;w]
		w-(alpha%count ins )*backPOverallGrad[w;ins;outs]
	}[alpha;ins;outs]/[its;w];
	show getScore[output;ins;outs];
	output
 };

//same as backP, but never explicitly scores, so no command line output
backPSilent:{[ins;outs;w;alpha;its]
	{[alpha;ins;outs;w]
		w-(alpha%count ins )*backPOverallGrad[w;ins;outs]
	}[alpha;ins;outs]/[its;w]
 };

//backP which scores after each iteration - if score function increases, alpha parameter decreases to 0.8* its value - otherwise alpha slowly increases
//arguments: inputs; desired outputs; starting weights; alpha parameter intial value [(err on side of too low ~<0.1); number of iterations
backPAlphaChange:{[ins;outs;w;alphaInitial;its] 
	{[ins;outs;x]
		show sc:getScore[x[0];ins;outs];
		$[sc<x[2];
			a:1.005*x[1];
			[show "REDUCING ALPHA";a:0.8*x[1]]
		];
		(x[0]-(a%count ins )*backPOverallGrad[x[0];ins;outs];a;sc)
	}[ins;outs]/[its;(w;alphaInitial;getScore[w;ins;outs])][0]
 };

//same as above, but with only a final score output to console
backPAlphaChangeQuiet:{[ins;outs;w;alphaInitial;its]
	output:{[ins;outs;x]
		sc:getScore[x[0];ins;outs];
		$[sc<x[2];
			a:1.005*x[1];
			a:0.8*x[1]
		];
		(x[0]-(a%count ins )*backPOverallGrad[x[0];ins;outs];a;sc)
	}[ins;outs]/[its;(w;alphaInitial;getScore[w;ins;outs])][0];
	show getScore[output;ins;outs];
	output
 };

//make multiple random weights and return the one which has best error function after specified amount of back-propagation - good for picking initial weights
//arguments: inputs; desired outputs; alpha parameter; list of structure of weights; number of iterations for testing; number of randomly generated weights
randWeights:{[ins;outs;alpha;ws;its;gen] first weights where scores = min scores:getScore[;ins;outs] each weights:backPSilent[ins;outs;;alpha;its] each makeWeightsMult[ws;gen]}
