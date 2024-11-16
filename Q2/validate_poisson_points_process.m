lambda1 = 10;
times = linspace(1, 100, 10); 

num_iter = 1000; rng(1);
mean_var = zeros(length(times), 3);
for i = 1:length(times)
    samples = arrayfun(@(~) length(poisson_points_process(lambda1, times(i))),  ...
        1:num_iter, 'UniformOutput', true);
    mean_var(i, :) = [times(i), mean(samples) / times(i), var(samples) / times(i)];
end

csvwrite('results/samples-mean-var.csv', mean_var);