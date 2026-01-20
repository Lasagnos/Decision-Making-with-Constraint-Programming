int: n;
array[1..n] of var 0..n-1: x;
include "global_cardinality.mzn";

% global constraint
constraint global_cardinality(x, [i | i in 0..n-1], x);
%constraint forall(i in 0..n-1)(count_eq(x, i, x[i+1]));

% no implied constraints in the base version


solve satisfy;

output [ "x = \(x);\n" ] ;

