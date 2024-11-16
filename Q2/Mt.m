function [times, M] = Mt(poisson_points, lambda, T)
times = (0:(1/60):T)';
M = zeros(length(times), 1);
for i = 1:length(poisson_points)
    start = poisson_points(i);
    stop = start + exprnd(1/lambda);
    [~, ts] = min(abs(start - times));
    [~, te] = min(abs(stop - times));
    M(ts:te) = M(ts:te) + 1;
end
