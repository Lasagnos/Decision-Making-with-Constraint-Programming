% Alldifferent model

include "alldifferent.mzn";

int: n; % Number of queens
set of int: QUEENS = 1..n;

array [QUEENS] of var QUEENS: rows; % Variables for queens on the rows (or columns)

% Column attack and Diagonal attack constraints using the alldifferent constraint
% Append ::domain to the end.
constraint alldifferent(rows)::domain;
constraint alldifferent([rows[i]+i | i in 1..n])::domain;
constraint alldifferent([rows[i]-i | i in 1..n])::domain;

array [QUEENS] of var QUEENS: distance; % Variables for queens on the rows (or columns)

constraint forall(queen in QUEENS)(
  distance[queen] = abs(queen - rows[queen])
);


% Search for all solutions dWd-rand
solve::int_search(rows, dom_w_deg, indomain_random) minimize sum(distance);