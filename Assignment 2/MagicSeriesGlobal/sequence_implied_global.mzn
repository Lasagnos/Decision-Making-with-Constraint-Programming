int: n;
array[1..n] of var 0..n-1: x;
include "global_cardinality.mzn";

% global constraint
constraint global_cardinality(x, [i | i in 0..n-1], x);

% the first implied constraint
constraint sum(x) = n;  % THEORETICAL NOTE: This constraint is now redundant due to the use of gcc
% the second implied constraint
constraint sum([ x[i+1]*i | i in 0..n-1]) = n;


solve satisfy;

output [ "x = \(x);\n" ] ;