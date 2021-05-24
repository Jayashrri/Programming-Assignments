wine_data = readtable("wine_quality_red.csv", "VariableNamingRule", "preserve");
coefficients = rand(1, 11);
expected_output = wine_data.quality;
inputs = transpose(wine_data{:, [1 2 3 4 5 6 7 8 9 10 11]});

training_inputs = inputs(:,[1:1500]);
test_inputs = inputs(:,[1501:1599]);

training_outputs = expected_output([1:1500],:);
test_outputs = expected_output([1501:1599],:);

data_count = length(training_outputs);

initial_error = sum((transpose(coefficients*training_inputs) - training_outputs).^2)/data_count;
error = @(coefficients) sum((transpose(coefficients*training_inputs) - training_outputs).^2)/data_count;

generations = 300;
options = optimoptions(@ga, 'CrossoverFcn', 'crossoverarithmetic', 'MaxGenerations', generations, 'MaxStallGenerations', 100);

problem.fitnessfcn = error;
problem.nvars = 11;
problem.solver = 'ga';
problem.lb = 0;
problem.ub = 10;
problem.options = options;

[x, best_value, exit_flag, ga_output] = ga(problem);
fprintf('Number of generations: %d\n', ga_output.generations);
fprintf('Initial function value: %g\n', initial_error);
fprintf('Best training error value: %g\n', best_value);
fprintf('Coefficient values: ');
fprintf('%g ', x);

data_count = length(test_outputs);
test_error = sum((transpose(x*test_inputs) - test_outputs).^2)/data_count;
fprintf('\n\n');
fprintf('Testing error value: %g', test_error);