% nqueens_MyLex

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

% Personalized lex_lesseq constraint
predicate my_lex_lesseq(array[int] of var int:x, array[int] of var int:y)=
  forall(i in 1..length(x))( forall(j in 1..i-1)(x[j] = y[j])  ->  x[i] <= y[i] )
;                %         .                    ,           ,                 .
% x[1] <= y[1] /\ <-- superfluous, writing 1..length(x) seems to handle it well

% Lexicographic symmetry breaking constraint
constraint
my_lex_lesseq(array1d(qb), [ qb[j,i] | i,j in 1..n ]) /\

my_lex_lesseq(array1d(qb), [ qb[i,j] | i,j in reverse(1..n) ]) /\
my_lex_lesseq(array1d(qb), [ qb[j,i] | i,j in reverse(1..n) ]) /\

my_lex_lesseq(array1d(qb), [ qb[i,j] | i in reverse(1..n), j in 1..n ]) /\
my_lex_lesseq(array1d(qb), [ qb[j,i] | i in reverse(1..n), j in 1..n ]) /\

my_lex_lesseq(array1d(qb), [ qb[i,j] | i in 1..n, j in reverse(1..n) ]) /\
my_lex_lesseq(array1d(qb), [ qb[j,i] | i in 1..n, j in reverse(1..n) ])
;

% Search for all solutions, using N = 13, 14 and 15 (if possible).
solve :: int_search(q, input_order, indomain_min) satisfy;