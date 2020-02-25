//NB: functions and formulae below assume a sigmoid function applied to each node
//with constant bias
//error function is sum square difference between desired output and actual output

//sigmoid function
sigma:{1%1+exp neg x}

//create random weights with giiven structure between -1 and 1
//argument:layer structure as list eg makeweights[3 5 3]
//output: nested list
makeweights:{{(y+1) cut (-1) + (x*y+1)?2f}':[x[0];1_x]}

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
grad0:{[i;h;o;obar;w] (1f,i)*/:h*(1-h)*1_ sum 2*(o-obar)*w}

//calculates gradient of error wrt each weight
//arguments: input node values; desired output; weights
onehlgrad:{[input;obar;w] n:nodes["f"$input;w];(grad0[n[0];n[1];n[2];obar;w[1]];grad1[n[1];n[2];obar])}

//sums gradient of error wrt weights over all input values
//inputs and desired outputs must be same length
//arguments: weights; inputs; desired outputs
onehloverallgrad:{[w;ins;outs] {[w;x;y;z] x+onehlgrad[y;z;w]}[w]/[0;ins;outs]}

//get average error function (average per output node) over input
//NB: low 'score' is good
//arguments: weights; inputs; desired outputs
getscore:{[w;ins;outs] avg avg ((out[;w] each ins) - outs) xexp 2}

//overall function for this script
//alpha parameter scales change of weights in proportion to error function gradient
//at each iteration print score - should be going down
//typical alpha paramter values: 10-0.01
//arguments: inputs; desired outputs; starting weights; alpha step parameter; number of iterations
onehl:{[ins;outs;w;alpha;its]{[alpha;ins;outs;w] show getscore[w;ins;outs]; w-(alpha%count ins )*onehloverallgrad[w;ins;outs]}[alpha;ins;outs]/[its;w]}

//same as onehl, but only scores at the end: not scoring at each iteration speeds up process
onehlquiet:{[ins;outs;w;alpha;its]output:{[alpha;ins;outs;w] w-(alpha%count ins )*onehloverallgrad[w;ins;outs]}[alpha;ins;outs]/[its;w];show getscore[output;ins;outs];output}
