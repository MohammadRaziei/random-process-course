clc; close all; clear
mkdir results
addpath ../common/

rng(1)

% Parameters
lambda1 = 10;  % Poisson process rate (calls per minute)
T = 60;        % Time interval (minutes)


% Generate the call start times using the Poisson process function
call_start_times = poisson_points_process(lambda1, T);

figure('units','normalized','outerposition',[0 .25 1 .3]); axis off
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax)
plot(call_start_times, 0, "b.")
ax.YAxis.Visible = 'off'; % remove y-axis
ax.Box = 'off';
xlabel("Minutes")

exportgraphics(gcf, sprintf('results/poisson-points-process-%d.pdf', T), 'Append', false);



%%

figure('units','normalized','outerposition',[0 .25 1 .5]); axis off
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax)
stairs([0;call_start_times], 0:length(call_start_times), "b")
ax.Box = "off";
xlabel("Minutes")
ylabel("$n(0, t; \lambda_1)$", "Interpreter","latex");

exportgraphics(gcf, sprintf('results/poisson-process-%d.pdf', T), 'Append', false);

%%
lambda2 = 0.5;

[t, M] = Mt(call_start_times, lambda2, T);

figure('units','normalized','outerposition',[0 .25 1 .5]); axis off
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax)

stairs(t, M);
ax.Box = 'off';

xlabel("Minutes")
ylabel("M(t)")


exportgraphics(gcf, sprintf('results/mt-%d.pdf', T), 'Append', false);
%%
rng(1);

lambda1 = 10;
lambda2 = 0.5;


num_iter = 500;
Ms = 0;
for i = 1:num_iter
    [~, M] = Mt(poisson_points_process(lambda1, T), lambda2, T);
    Ms = Ms + M;
end
Ms = Ms / num_iter;



% Exponential fit function
fitFunc = @(b, x) b(1) * (1 - exp(-x * b(2)));  
% Initial guess for parameters
initialGuess = [max(Ms), 1]; 
% Fit the model using fminsearch
params = fminsearch(@(b) sum((Ms - fitFunc(b, t)).^2), initialGuess);




figure('units','normalized','outerposition',[0 .25 1 .5]); axis off
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax); hold on

plot(t, Ms, 'b');

plot(t, fitFunc(params, t), 'r:');

xlabel("t (Minutes)")
ylabel("M(t)")

legend({'$\mathbf{E}\big\{M(t)\big\}$', ...
    sprintf('$%.5g(1 - e^{-%.5g t})$', params(1), params(2))}, ...
    'Interpreter', 'latex', 'Location','southeast');

csvwrite(sprintf('results/e-mt-lambda1-%.2f-lambda2-%.2f-fit.csv', lambda1, lambda2), params);

exportgraphics(gcf, sprintf('results/e-mt-lambda1-%.2f-lambda2-%.2f-fit.pdf', lambda1, lambda2), 'Append', false);


%%
rng(1);

lambda1 = 10;
lambda2 = 0.5;


num_iter = 500;
Ms = 0;
for i = 1:num_iter
    [t, M] = Mt(poisson_points_process(lambda1, T), lambda2, T);
    Ms = Ms + M;
end
Ms = Ms / num_iter;



% Exponential fit function
fitFunc = @(b, x) b(1) * (1 - exp(-x * b(2)));  
params = [lambda1 / lambda2, lambda2];

initialGuess = [max(Ms), 1]; 
% Fit the model using fminsearch
params_fit = fminsearch(@(b) sum((Ms - fitFunc(b, t)).^2), initialGuess);




figure('units','normalized','outerposition',[0 .25 1 .5]); axis off
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax); hold on

plot(t, Ms, 'b');

plot(t, fitFunc(params, t), 'k:');

xlabel("t (Minutes)")
ylabel("M(t)")
title(sprintf("$\\lambda_1: %.5g \\qquad \\lambda_2: %.5g$", lambda1, lambda2), "Interpreter", "latex")

legend({'$\mathbf{E}\big\{M(t)\big\}$', ...
    sprintf('$\\frac{\\lambda_1}{\\lambda_2} (1 - e^{-\\lambda_2 t}) = %.5g(1 - e^{-%.5g t})$', params(1), params(2))}, ...
    'Interpreter', 'latex', 'Location','southeast');

csvwrite(sprintf('results/e-mt-lambda1-%.2f-lambda2-%.2f.csv', lambda1, lambda2), [params_fit; params]);

exportgraphics(gcf, sprintf('results/e-mt-lambda1-%.2f-lambda2-%.2f.pdf', lambda1, lambda2), 'Append', false);

%%

rng(2)

TT = 3*T;
lambda1 = 10;
lambda2 = 0.5;

Tt = (0:.1:TT)';
MTt = zeros(length(Tt), 1);
for i = 1:length(Tt)
[t, M] = Mt(poisson_points_process(lambda1, Tt(i)), lambda2, Tt(i));
MTt(i) = mean(M);
end

% Exponential fit function
fitFunc = @(b, x) b(1) * (1 - exp(-x * b(2)));  
% Initial guess for parameters
initialGuess = [max(MTt), 1]; 
% Fit the model using fminsearch
params_fit = fminsearch(@(b) sum((MTt - fitFunc(b, Tt)).^2), initialGuess);


params = [lambda1 / lambda2, lambda2 / 2];


figure('units','normalized','outerposition',[0 .25 1 .5]); axis off
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax); hold on

plot(Tt, MTt)
plot(Tt, fitFunc(params_fit, Tt), 'r:');
plot(t, fitFunc(params, t), 'k:');

xlabel("T (Minutes)")
ylabel("M(t)")

title(sprintf("$\\lambda_1: %.5g \\qquad \\lambda_2: %.5g$", lambda1, lambda2), "Interpreter", "latex")


legend({'$<M(t)>$', ...
    sprintf('$%.5g(1 - e^{-%.5g t})$', params_fit(1), params_fit(2)), ...
    sprintf('$\\frac{\\lambda_1}{\\lambda_2} (1 - e^{-\\frac{\\lambda_2}{2}t}) = %.5g(1 - e^{-%.5g t})$', params(1), params(2))}, ...
    'Interpreter', 'latex', 'Location','southeast');


csvwrite(sprintf('results/e-mt-lambda1-%.2f-lambda2-%.2f-time.csv', lambda1, lambda2), [params_fit; params])


exportgraphics(gcf, sprintf('results/e-mt-lambda1-%.2f-lambda2-%.2f-time.pdf', lambda1, lambda2), 'Append', false);


