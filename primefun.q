//generates all numbers not divisible by 2 or 3 between start and end
//i.e. 1,5 mod 6
//excludes bottom; includes top
primeCands:{[s;e] /arguments start point; end point
	/produce list, first and last elements may be outside range
	l:raze (-1 1) +/: 6*a+til 1+((1+e) div 6)-a:1+floor (s-1) div 6;
	if[s >= first l;l:1_l]; 	/fix first element
	if[e < last l;l:-1_l];		/fix last element
	:l;
 };

//produce sequential square roots from input down to below 5
//intended so that primes up to each number in series can be...
//checked for by primes up to and including the lower next value
//example: squares[50000] -> 50000 224 15 4
//squares[100000] -> 100000 -> 317 18 5 3
squares:reverse {ceiling sqrt x}\[{x>4};];

//returns elements of input relatively prime to prime list
//NB if one of the input ns is also in prime list, it will be treated as not prime
//assumes (max primes)>=sqrt n for all input n
//for ease of use later if prime list empty, return all
//exmaple: primeCheckList[2 3 5 7 11 13;15+til 20]
//->17 19 23 29 31
primeCheckList:{[primes;ns] 	/inputs primes, numbers to be filtered
	$[()~primes;		/if primes empty return all ns
		:ns;
		/else filter over primes, discarding non-primes
		:{x where 0<>x mod y}/[ns;primes]
	];
 };

//overall function to generate primes up to and inc input
//uses squares[] function to group into efficient checkable groups
//use primeCands so don't need to explicity check for 2 or 3
//manually add on 2 and 3 at the end
genPrimes:{[n]
	cg:reverse primeCands':[n;1_squares n];
	:2,3,{[ps;ns] ps,primeCheckList[ps;ns]}/[();cg];
 };

//use genPrimes to get nth prime number
//x log x approximate value of nth prime
//but slight underesitmate so increase by factor of 1.2 for safety
//'nth prime' indexed from 1 so 1st prime=2, 2nd prime=3
nthPrimeGen:{genPrimes["j"$10+1.2*x*log x][x-1]}

//use optimised sieve of Eratosthenes to get primes
//in sieve index i corresponds to number 1+2*i
sievePrimes:{[n]
	sieve:((1+n) div 2)#1b;	/create sieve 
	sieve:{[n;s;p]
		/for prime possibilities made by primeCands up to sqrt(x)
		/set sieve at indices corresponding to multiples to false
		/only need to go from prime^2
		@[s;(((p*p)-1) div 2) + p*til 1+ ((n div p)-p) div 2;:;0b]
	}[n]/[sieve;3,primeCands[4;floor sqrt n]];
	:2,1_1+2*where sieve; 	/convert indices to numbers, remove 1, add 2
 };

//similar sieve to above nthPrimeGen; but using sievePrimes as core
nthPrimeSieve:{sievePrimes["j"$100+1.2*x*log x][x-1]}
