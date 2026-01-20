% Row model

include "alldifferent.mzn";

int: n; % Number of queens    #var 1..n is the domain
array [1..n] of var 1..n: rows; % Variables for queens on the rows

% Column attack constraints using the alldifferent constraint.
% Append ::domain to the end.
constraint alldifferent(rows)::domain_propagation;  %the :: and after part calls the best propagation algorithm

% Diagonal attack constraints
constraint forall(i,j in 1..n where i<j) (abs(rows[i]-rows[j])!=abs(i-j));  %the 'where i<j' is for symmetry breaking, and halves the cases. Since j>i always, in the second part of the disequation we can remove abs and write j-1. The 'forall' acts as a quantification of the constraint following it, don't call it a constraint.

% Search for all solutions, using N = 8, 9, 10, and 12.
solve satisfy;
