include "globals.mzn";
include "all_different.mzn";
% nxn grid, values from 1..n
int: n;
array[1..n, 1..n] of var 1..n: grid;

% given start (0 means empty)
array[1..n, 1..n] of int: start;

% preassignment of the grid variables to values taken from the start
constraint forall(i,j in 1..n)(
    if start[i,j] > 0 then grid[i,j] = start[i,j] endif);

% problem constraints on grid
constraint forall (i in 1..n) (all_different([grid[i, j]  | j in 1..n]))::domain;
constraint forall (j in 1..n) (all_different([grid[i, j]  | i in 1..n]))::domain;


solve satisfy;

output [
  if col = 1 then "\n" else " " endif ++
  show(grid[row,col])
  | row in 1..n, col in 1..n
];