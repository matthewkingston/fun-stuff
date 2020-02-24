
sigma:{1%1+exp neg x}
/sigmoid

makeweights:{{(y+1) cut (-1) + (x*y+1)?2f}':[x[0];1_x]}
/input:layer structure as list eg (3 5 3)

nodes:{((enlist "f"$x), {raze sigma y mmu "f"$1,x}\[x;y])}
/input:input values;weights
/input nodes:nodes[0]
/hidden layer:nodes[1]
/output nodes:nodes[2]

out:{{raze sigma y mmu "f"$1,x}/[x;y]}
/input:input values;weights

grad1:{(1f,x)*/:2*y*(1-y)*(y-z)}
/input:penultimate layer of nodes;final nodes;desired output

grad0:{[i;h;o;obar;w] (1f,i)*/:h*(1-h)*1_ sum 2*(o-obar)*w}
/input:nodes[last-2];nodes[last-1];nodes[last];desired output;final layer of weights

onehlgrad:{[input;obar;w] n:nodes["f"$input;w];(grad0[n[0];n[1];n[2];obar;w[1]];grad1[n[1];n[2];obar])}
/input:input;desired output;weights

onehloverallgrad:{[w;ins;outs] {[w;x;y;z] x+onehlgrad[y;z;w]}[w]/[0;ins;outs]}
/input:weights;inputs;desired outputs

getscore:{[w;ins;outs] avg avg ((out[;w] each ins) - outs) xexp 2}
/input:weights;inputs;outputs

onehl:{[ins;outs;w;alpha;its]{[alpha;ins;outs;w] show getscore[w;ins;outs]; w-(alpha%count ins )*onehloverallgrad[w;ins;outs]}[alpha;ins;outs]/[its;w]}
/input:inputs;desired outputs;starting weights;step parameter;number of iterations

onehlquiet:{[ins;outs;w;alpha;its]output:{[alpha;ins;outs;w] w-(alpha%count ins )*onehloverallgrad[w;ins;outs]}[alpha;ins;outs]/[its;w];show getscore[output;ins;outs];output}
/same as onehl, but only calculate final score at the end
