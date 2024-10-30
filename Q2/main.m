clc; close all; clear
mkdir results
addpath ../common/

rng(1)

N = 1000;
x_n = randn(N, 1);
a = [.5;.8;-.6];

a_x = [a(2), a(3)]; % ضرایب مربوط به x[n] و x[n-1]
a_y = [1, -a(1)]; % ضرایب مربوط به y[n-1]

y_n = filter(a_x, a_y, x_n);

% y_n = zeros(N, 1);
% for i = 1:N-1
%     y_n(i+1) = a(1) * y_n(i) + a(2) * x_n(i+1) + a(3) * x_n(i);
% end

U = [y_n(1:N-1), x_n(2:N) x_n(1:N-1)];
y = y_n(2:N);

a_est = pinv(U) * y;
disp(a_est)

csvwrite(sprintf("results/a-est-%i.csv", length(a_est)), a_est);
csvwrite(sprintf("results/a-est-%i-err.csv", length(a_est)), [norm(a_est-a); a_est - a]);



U = [y_n(1:N-3), y_n(2:N-2), x_n(3:N-1), x_n(2:N-2), x_n(1:N-3)];
y = y_n(3:N-1);

a_est = pinv(U) * y;
disp(a_est)

csvwrite(sprintf("results/a-est-%i.csv", length(a_est)), a_est);
csvwrite(sprintf("results/a-est-%i-err.csv", length(a_est)), [norm(a_est-[0;a;0]); (a_est - [0;a;0])]);
%%



for M = [5, 10, 15]

    U = zeros(N-M, M+1);
    for i = 1:N-M
        U(i, :) = x_n(i+M:-1:i);
    end
    y = y_n(M+1:N);


    % نمایش ماتریس U
    a_est = pinv(U)*y;


    a_est = pinv(U) * y;
    disp(a_est)

    csvwrite(sprintf("results/a-est-ma-%i.csv", M), a_est);
end
%%