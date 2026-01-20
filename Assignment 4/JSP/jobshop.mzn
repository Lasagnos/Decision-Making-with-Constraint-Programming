include "globals.mzn";

int: M;     %number of machines = number of tasks
int: J;     %number of jobs
set of int: MACH = 1..M;
set of int: TASK = 1..M; 
set of int: JOB = 1..J;
array[JOB,TASK] of MACH: machine;    % machines for tasks
array[JOB,MACH] of int: duration;     % task durations on machines

%variables
int: MaxTime = sum(j in JOB, m in MACH) (duration[j, m]);  % domain upper bound
array[JOB,TASK] of var 0..MaxTime: starts;  % Start times
var 0..MaxTime: makespan;

%constraints
% Precedence constraints on consecutive tasks of each job
constraint forall(j in JOB, i in 1..M-1) ( starts[j,i] + duration[j,machine[j,i]] <= starts[j,i+1] );

% Disjunctive constraints for each machine on the job tasks requiring the machine
constraint forall(m in MACH) (
    disjunctive(
      [starts[j,i] | j in JOB, i in TASK where machine[j,i] == m],
      [duration[j, machine[j,i]] | j in JOB, i in TASK where machine[j,i] == m]
    )
);
% Makespan as a dummy task with the lowest precedence in the schedule
constraint forall(j in JOB) ( starts[j,M] + duration[j,machine[j,M]] <= makespan );

%objective function
solve minimize makespan;  % Default search
%solve::int_search(starts, smallest, indomain_min) minimize makespan;  %EST search

%output
output [
  "Makespan = ", show(makespan)
];
