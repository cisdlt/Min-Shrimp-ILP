% Definition of variables
x1 = optimvar('x1', 'type', 'integer', 'LowerBound', 0, 'UpperBound', Inf); 
% Represents the number of cherry tomatoes

x2 = optimvar('x2', 'type', 'integer', 'LowerBound', 0, 'UpperBound', Inf); 
% Represents the number of lettuces

s1 = optimvar('s1', 'type', 'integer', 'LowerBound', 0,  'UpperBound', Inf); 
% Represents the number of shrimp

% Absorption rates (You need to specify these values based on your study)
a1 = 0.06004; 
a2 = 0.13636; 
a3 = 0.09408;
% Area in tank m^2
v1 = 100;

% Objective function
prob = optimproblem('Objective', s1, 'ObjectiveSense', 'min');

% Constraints
prob.Constraints.c1 = (a1 * x1 + a2 * x2) - s1 * a3 == 0;
prob.Constraints.c2 = (s1) / (1.1 * v1 * 1000) <= 0.15;
prob.Constraints.c3 = (s1) / (1.1 * v1 * 1000) >= 0.00244;
prob.Constraints.c4 = x1 >= 5000;
prob.Constraints.c5 = x2 >= 5000;

% Solve the problem
[sol, fval] = solve(prob);

% Display the solution
disp(sol);
disp(fval);
