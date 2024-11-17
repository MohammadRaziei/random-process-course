clc; close all; clear;

% Create a directory for results
mkdir('results');
addpath('../common/');

% Set random seed for reproducibility
rng(1);

% Constants
n_molecules = 1000;        % Number of molecules
s_m = 500;                 % Molecule speed (arbitrary units)
T = 1e-9;                  % Time step between movements
t = 1e-4;                  % Total time for each molecule's movement
n_movements = floor(t / T); % Number of movements per molecule

% Generate random angles for each molecule's movement
phi = rand(n_molecules, n_movements) * 2 * pi;  % Azimuthal angle
theta = rand(n_molecules, n_movements) * pi;    % Polar angle

% Convert spherical coordinates to Cartesian coordinates
[dx, dy, dz] = sph2cart(phi, pi/2 - theta, s_m * T);

% Initialize positions
x = [zeros(n_molecules, 1), cumsum(dx, 2)];
y = [zeros(n_molecules, 1), cumsum(dy, 2)];
z = [zeros(n_molecules, 1), cumsum(dz, 2)];

% Calculate the average positions (x, y, z)
steps = 0:n_movements;
mean_x = mean(x, 1);
mean_y = mean(y, 1);
mean_z = mean(z, 1);

saver = [];
saver =  [saver; ["mean_x", mean_x(end)]; ["mean_y", mean_y(end)]; ["mean_z", mean_z(end)]];
%% Plot average positions over time
figure('units', 'normalized', 'outerposition', [0 .25 1 .5]); 
axis off;
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax); 
hold on;
plot(steps, mean_x, 'DisplayName', 'Mean X');
plot(steps, mean_y, 'DisplayName', 'Mean Y');
plot(steps, mean_z, 'DisplayName', 'Mean Z');
legend;
exportgraphics(gcf, 'results/mean_positions.pdf', 'Append', false);


%% 3D plot of the average position
figure;
ax = gca;
ax.View = [-25, 25];
ax.DataAspectRatio = [1 1 1];
plot3(mean_x, mean_y, mean_z);

exportgraphics(gcf, 'results/3d_average_trajectory.pdf', 'Append', false);

%% Plot individual trajectories of the first few molecules
figure; 
hold on;
ax = gca;
ax.View = [-25, 25];
ax.DataAspectRatio = [1 1 1];

for i = 1:min(n_molecules, 10)
    plot3(x(i, :), y(i, :), z(i, :));
end
exportgraphics(gcf, 'results/individual_trajectories.pdf', 'Append', false);

%% Calculate and plot the mean squared displacement
mean_d = mean(sqrt(x.^2 + y.^2 + z.^2), 1);

figure('units', 'normalized', 'outerposition', [0 .25 1 .5]); 
axis off;
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax); 
hold on;
plot(steps, mean_d);
exportgraphics(gcf, 'results/mean_displacement.pdf', 'Append', false);

saver =  [saver; ["mean_d", mean_d(end)]];

%% Calculate and plot the root mean squared displacement 
rms = sqrt(mean(x.^2 + y.^2 + z.^2, 1));

figure('units', 'normalized', 'outerposition', [0 .25 1 .5]); 
axis off;
[subplot_axis, ~] = tight_subplot(1, 1, [0.2, 0.05], .2);
ax = subplot_axis(1);
axes(ax); 
hold on;
plot(steps, rms);
exportgraphics(gcf, 'results/root_mean_squared.pdf', 'Append', false);
saver =  [saver; ["rms", rms(end)]];



%%

d = sqrt(mean_x(end)^2 + mean_y(end)^2 + mean_z(end)^2);
t_4m_d = 4 / d * t;
disp(t_4m_d)

saver =  [saver; ["d", d]];


d = mean_d(end);
t_4m_md = 4 / d * t;
disp(t_4m_md)


d = rms(end);
t_4m_rms = 4 / d * t;
disp(t_4m_rms)



saver =  [saver; ["t_4m_d", t_4m_d]];
saver =  [saver; ["t_4m_md", t_4m_md]];
saver =  [saver; ["t_4m_rms", t_4m_rms]];

writematrix(saver, "results/saver.csv")

%%


