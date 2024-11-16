function poisson_points = poisson_points_process(lambda, t)
% Author: Mohammad Raziei
% This function simulates a Poisson point process and generates the
% points (events) occurring within a given time interval 't'
% with rate 'lambda'. The time between consecutive points follows
% an exponential distribution.

% Initialize the first point and counter
previous_point = 0;  % The starting point of the process (time 0)
i = 0;  % Counter for the number of points
poisson_points = [];  % Array to store the generated Poisson points

% Generate Poisson process points
while true
    % Generate the next point using an exponential distribution
    % The time between two consecutive points follows an exponential distribution with rate lambda
    point = previous_point + exprnd(1 / lambda);

    % If the point exceeds the time limit 't', stop the process
    if point > t, break; end

    % Increment the counter and store the generated point
    i = i + 1;
    poisson_points(i, 1) = point;

    % Update the previous point to the current one
    previous_point = point;
end