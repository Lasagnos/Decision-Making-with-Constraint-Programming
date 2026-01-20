include "globals.mzn";

int: n_tasks;   % Number of tasks
set of int: TASKS = 1..n_tasks;
array[TASKS] of int: duration; % Task durations

int: n_res;   % Number of resources
set of int: RESOURCES = 1..n_res;
array[RESOURCES] of int: L; % Resource capacities
array[RESOURCES,TASKS] of int: req; %Resource requirements of tasks

int: p;       % Number of precedence relations
set of int: PREC = 1..p;
array[PREC,1..2] of TASKS: pre; % Precedence relations

%variables
int: MaxTime = sum(duration);  % domain upper bound
array[TASKS] of var 0..MaxTime: starts;  % Start times

%constraints
% Precedence constraints on consecutive tasks of each job
constraint forall(k in PREC) ( starts[pre[k, 1]] + duration[pre[k, 1]] <= starts[pre[k, 2]] );
% Disjunctive constraints for each machine on the job tasks requiring the machine
constraint forall(r in RESOURCES) ( cumulative(starts, duration, req[r, TASKS], L[r]) );

%objective function
solve minimize max([starts[i] + duration[i] | i in TASKS]);  % Default search
%solve::int_search(starts, smallest, indomain_min) minimize max([starts[i] + duration[i] | i in TASKS]);  %EST search

output("\(max([starts[i] + duration[i] | i in TASKS]))")