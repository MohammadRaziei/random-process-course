clc; close all; clear
mkdir results
addpath ../common/

rng(1)

sigma2 = 1;

h = [1 -.8 .6];

Rxx_idx = 0;
Rxx = sigma2;

Rxy = conv(conj(fliplr(h)), Rxx);
Ryy = conv(h, Rxy);

figure
Rxy_idx = (1-length(h)):0;
stem(Rxy_idx, Rxy)
xlim([-length(h), 1])
ylim([-2, 3])
exportgraphics(gcf, 'results/Rxy.pdf', 'Append', false);

figure
Ryy_idx = (1-length(h)):(length(h)-1);
stem(Ryy_idx, Ryy)
xlim([-length(h), length(h)])
ylim([-2, 3])
exportgraphics(gcf, 'results/Ryy.pdf', 'Append', false);



%%



% Number of samples (length of the process)
for N = [100, 10000]

% Process parameters
mean_value = 0;      % Mean
variance_value = 1;  % Variance

% Generate white Gaussian noise process
white_noise_process = sqrt(variance_value) * randn(N, 1) + mean_value;

% Plot the generated process
figure;
plot(white_noise_process);
title('White Gaussian Noise Process (x[n])');
xlabel('Sample Number');
ylabel('Amplitude');
exportgraphics(gcf, sprintf('results/white-noise-N%i.pdf', N), 'Append', false);

% Convolution to obtain y[n]
x = white_noise_process;
y = conv(x, h, "full");
y = y(1:length(x));

figure
plot(y);
xlabel('Sample Number');
ylabel('Amplitude');
title('y[n]');
exportgraphics(gcf, sprintf('results/yn-N%i.pdf', N), 'Append', false);



% Display the distribution of the process as a histogram
figure;
histogram(white_noise_process, 50);
title('Histogram of White Gaussian Noise Process');
xlabel('Value');
ylabel('Frequency');
exportgraphics(gcf, sprintf('results/white-noise-hist-N%i.pdf', N), 'Append', false);



% Autocorrelation of x[n]
R_x = xcorr(x, 'biased');

% Autocorrelation of y[n]
R_y = xcorr(y, 'biased');

% Cross-correlation between x[n] and y[n]
R_xy = xcorr(x, y, 'biased');

% Plotting
figure('units','normalized','outerposition',[0 .25 1 .75]);
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + 2.2*ti(1);
bottom = outerpos(2) + 2.2*ti(2);
ax_width = outerpos(3) - 2.2*ti(1) - ti(3);
ax_height = outerpos(4) - 2.2*ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
axis off
[subplot_axis, pos] = tight_subplot(3, 2, [0.15, 0.05], .1); 

axes(subplot_axis(1)); axis on; hold on
plot(-N+1:N-1, R_x);
title('Autocorrelation of x[n]');
xlabel('Lag (n)');
ylabel('Amplitude');

axes(subplot_axis(2)); axis on; hold on
plot(-N+1:N-1, R_x);
title('Autocorrelation of x[n]');
xlabel('Lag (n)');
ylabel('Amplitude');
stem(Rxx_idx, Rxx)
xlim([-10,10])

axes(subplot_axis(3)); axis on; hold on
plot(-N+1:N-1, R_y);
title('Autocorrelation of y[n]');
xlabel('Lag (n)');
ylabel('Amplitude');

axes(subplot_axis(4)); axis on; hold on
plot(-N+1:N-1, R_y);
title('Autocorrelation of y[n]');
xlabel('Lag (n)');
ylabel('Amplitude');
stem(Ryy_idx, Ryy)
xlim([-10,10])

axes(subplot_axis(5)); axis on; hold on
plot(-N+1:N-1, R_xy);
title('Cross-correlation between x[n] and y[n]');
xlabel('Lag (n)');
ylabel('Amplitude');

axes(subplot_axis(6)); axis on; hold on
plot(-N+1:N-1, R_xy);
title('Cross-correlation between x[n] and y[n]');
xlabel('Lag (n)');
ylabel('Amplitude');
stem(Rxy_idx, Rxy)
xlim([-10,10])
exportgraphics(gcf, sprintf('results/xcorr-N%i.pdf', N), 'Append', false);


% Theoretical Power Spectral Density of x[n]
S_xx = variance_value * ones(N, 1);  % Constant value for white noise

[H, w] = freqz(h, 1, N, 'whole');


% Calculate the Power Spectral Density of x[n] using Welch's method
window_length = max(floor(N/16), 25);     % Window length for Welch's method
overlap = floor(window_length/2);  % 50% overlap


[PSD_x, f] = pwelch(x, window_length, overlap, N, 1, 'centered');
PSD_x = fftshift(PSD_x); f = f + .5;
fftx = fft(x); Sx = abs(fftx).^2 / N;

% Plotting the PSD
figure('units','normalized','outerposition',[0 .25 1 .75]); axis off
[subplot_axis, pos] = tight_subplot(2, 1, [0.2, 0.05], .1);

axes(subplot_axis(1)); axis on; hold on
plot(w/(2*pi), Sx, "Color", .8*ones(1,3));
plot(f, PSD_x);
plot(w/(2*pi), S_xx, "LineWidth", 1, "Color", "blue");
ylim([0, max(PSD_x)*1.5])


title('Power Spectral Density of x[n]');
xlabel('Normalized Frequency (rad/sample)');
ylabel('S_{xx}(f)');

% Theoretical Power Spectral Density of y[n]
S_yy = abs(H).^2 * variance_value;

% Calculate the Power Spectral Density of x[n] using Welch's method
[PSD_y, f] = pwelch(y, window_length, overlap, N, 1, 'centered');
PSD_y = fftshift(PSD_y); f = f + .5;
ffty = fft(y); Sy = abs(ffty).^2 / N;



axes(subplot_axis(2)); axis on; hold on
plot(w/(2*pi), Sy, "Color", .8*ones(1,3));
plot(f, PSD_y);
plot(w/(2*pi), S_yy, "LineWidth", 1, "Color", "blue");
title('Power Spectral Density of y[n]');
xlabel('Normalized Frequency (rad/sample)');
ylabel('S_{yy}(f)');
ylim([0, max(PSD_y)*1.5])

exportgraphics(gcf, sprintf('results/psd-N%i.pdf', N), 'Append', false);


end




