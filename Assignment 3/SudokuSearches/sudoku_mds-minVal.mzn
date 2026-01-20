include "globals.mzn";
include "all_different.mzn";
% nxn grid, values from 0..values
int: n;
int: block_size = ceil(sqrt(n));
int: values;
array[1..n, 1..n] of var 0..values: grid;

% given puzzle (-1 means empty)
array[1..n, 1..n] of int: puzzle;

% preassignment of the grid variables to values taken from the puzzle
constraint forall(i,j in 1..n)(
    if puzzle[i,j] > 0 then grid[i,j] = puzzle[i,j] endif);

% problem constraints on grid
constraint forall (i in 1..n) (all_different_except_0([grid[i, j]  | j in 1..n]))::domain;

constraint forall (j in 1..n) (all_different_except_0([grid[i, j]  | i in 1..n]))::domain;

constraint forall (i, j in 1..block_size)(all_different_except_0([grid[(i-1)*block_size + i_inside, (j-1)*block_size + j_inside] | i_inside, j_inside in 1..block_size]))::domain;

constraint global_cardinality(array1d(grid), 1..values, [n | _ in 1..values])::domain;

solve::int_search(grid, first_fail, indomain_min) satisfy;

output [
if row > 1 /\ row mod block_size = 1 /\ col = 1 then
"\n" ++ concat([ concat([" -- "| f in 1..(block_size)])++" " | _ in 1..(block_size) ])
else "" endif ++
if col = 1 then "\n" else "" endif ++
if col > 1 /\ col mod block_size = 1 then " | " else " " endif ++
if fix(grid[row,col]) < 10 then " " else "" endif ++ show(grid[row,col]) ++ " "
| row in 1..n, col in 1..n
];