% Define the area in the tank (in square meters)
v1 = 100; % 100 m^2

% Define optimization variables
x1 = optimvar('x1', 'LowerBound', 5000, 'Type', 'integer');
x2 = optimvar('x2', 'LowerBound', 5000, 'Type', 'integer');
s1 = optimvar('s1', 'LowerBound', 0, 'Type', 'integer');

% Define the optimization problem
prob = optimproblem;

% Define the objective: minimize the number of shrimps
prob.Objective = s1;

% Absorption rates for cherry tomatoes and lettuces
a1 = 0.06004; % Nitrate absorption rate for cherry tomatoes (g per day)
a2 = 0.13636; % Nitrate absorption rate for lettuces (g per day)

% Define nitrate production rate sensitivity (varying within a reasonable range)
nitrate_production_rates = 0.08408:0.001:0.10408; % Adjust the range as needed

% Initialize arrays to store results
sensitivity_results_x1 = zeros(length(nitrate_production_rates), 1); % For cherry tomatoes
sensitivity_results_x2 = zeros(length(nitrate_production_rates), 1); % For lettuces
sensitivity_results_s1 = zeros(length(nitrate_production_rates), 1); % For shrimps

% Perform sensitivity analysis
for i = 1:length(nitrate_production_rates)
    % Update the problem with new nitrate production rate
    prob.Constraints.c1 = a1 * x1 + a2 * x2 == s1 * nitrate_production_rates(i);
    prob.Constraints.c2 = (s1 * nitrate_production_rates(i)) / (1.1 * v1 * 1000) <= 0.15;
    prob.Constraints.c3 = (s1 * nitrate_production_rates(i)) / (1.1 * v1 * 1000) >= 0.00244;

    % Solve the problem using options to handle solver specifics
    options = optimoptions('intlinprog', 'Display', 'final');
    [sol, fval, exitflag, output] = solve(prob, 'Options', options);
    
    % Store the results if the solver succeeded
    if exitflag == 1
        sensitivity_results_x1(i) = sol.x1;
        sensitivity_results_x2(i) = sol.x2;
        sensitivity_results_s1(i) = sol.s1;
    else
        % Set to NaN if solver failed
        sensitivity_results_x1(i) = NaN;
        sensitivity_results_x2(i) = NaN;
        sensitivity_results_s1(i) = NaN;
    end
end

% Display sensitivity analysis results
for i = 1:length(nitrate_production_rates)
    fprintf('Nitrate Production per Shrimp: %.5f, Optimal Cherry Tomatoes: %.2f, Optimal Lettuces: %.2f, Optimal Shrimps: %.2f\n', ...
            nitrate_production_rates(i), sensitivity_results_x1(i), sensitivity_results_x2(i), sensitivity_results_s1(i));
end
