//excludes bottom; includes top
primeCands:{[s;e]
	l:raze (-1 1) +/: 6*a+til 1+((1+e) div 6)-a:1+floor (s-1) div 6;
	if[s >= first l;l:1_l];
	if[e < last l;l:-1_l];
	:l;
 };

squares:reverse {ceiling sqrt x}\[{x>4};]
primeCheckList:{[primes;ns] $[()~primes;ns;{x where 0<>x mod y}/[ns;primes]]}
genPrimes:{2,3,{x,primeCheckList[x;y]}/[();reverse primeCands':[x;1_squares x]]}
nthPrimeGen:{genPrimes["j"$100+1.2*x*log x][x-1]}

sievePrimes:{
	sieve:((1+x) div 2)#1b;
	sieve:{
		@[y;(((z*z)-1) div 2) + z*til 1+ ((x div z)-z) div 2;:;0b]
	}[x]/[sieve;3,primeCands[4;floor sqrt x]];
	:2,1_1+2*where sieve;
 };
nthPrimeSieve:{sievePrimes["j"$100+1.2*x*log x][x-1]}
