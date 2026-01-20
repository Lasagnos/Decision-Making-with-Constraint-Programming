% Combined alldifferent & symmetry breaking model

include "alldifferent.mzn";

int: n; % Number of queens
array [1..n] of var 1..n: q; % Variables for queens on the rows (or columns)

% Integration of the Boolean model
constraint alldifferent(q)::domain;
constraint alldifferent([q[i]+i | i in 1..n])::domain;
constraint alldifferent([q[i]-i | i in 1..n])::domain;

include "lex_lesseq.mzn";

array[1..n,1..n] of var 0..1: qb;

% Channeling constraint
constraint forall(i,j in 1..n) ( qb[i,j]=1 <-> q[i]=j );

% Lexicographic symmetry breaking constraint
constraint
lex_lesseq(array1d(qb), [ qb[j,i] | i,j in 1..n ]) /\

lex_lesseq(array1d(qb), [ qb[i,j] | i,j in reverse(1..n) ]) /\
lex_lesseq(array1d(qb), [ qb[j,i] | i,j in reverse(1..n) ]) /\

lex_lesseq(array1d(qb), [ qb[i,j] | i in reverse(1..n), j in 1..n ]) /\
lex_lesseq(array1d(qb), [ qb[j,i] | i in reverse(1..n), j in 1..n ]) /\

lex_lesseq(array1d(qb), [ qb[i,j] | i in 1..n, j in reverse(1..n) ]) /\
lex_lesseq(array1d(qb), [ qb[j,i] | i in 1..n, j in reverse(1..n) ])
;

% Search for all solutions, using N = 8, 9, 10, and 12.
solve satisfy;