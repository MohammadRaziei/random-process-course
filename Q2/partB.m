clc; close all; clear
mkdir results
addpath ../common/

rng(1)

sigma2_x = 1;

for sigma2_v = [.1 .01]
    for N = [100 1000 10000]

        x_n = sqrt(sigma2_x) * randn(N, 1);

        v_n = sqrt(sigma2_v) * randn(N, 1);



        a = [.5;.8;-.6];

        y_n = zeros(N, 1);
        for i = 1:N-1
            y_n(i+1) = a(1) * y_n(i) + a(2) * x_n(i+1) + a(3) * x_n(i);
        end
        y_n = y_n + v_n;

        U = [y_n(1:N-1), x_n(2:N) x_n(1:N-1)];
        y = y_n(2:N);

        pU = pinv(U);
        a_est = pU * y;
        disp(a_est)

        e = norm((eye(length(y)) - U*pU)*y)^2 / N;
        e2 = norm((eye(length(y)) - U*pU)*y)^2;

        disp(e)


        csvwrite(sprintf("results/a-est-%i-N%i-v%.2f.csv", length(a_est), N, sigma2_v), a_est);
        csvwrite(sprintf("results/a-est-%i-N%i-v%.2f-err.csv", length(a_est), N, sigma2_v), [norm(a_est-a); e; e2; (a_est - a)]);


        U = [y_n(1:N-3), y_n(2:N-2), x_n(3:N-1), x_n(2:N-2), x_n(1:N-3)];
        y = y_n(3:N-1);

        pU = pinv(U);
        a_est = pU * y;
        disp(a_est)

        e = norm((eye(length(y)) - U*pU)*y)^2 / N;
        e2 = norm((eye(length(y)) - U*pU)*y)^2;

        disp(e)



        disp(a_est)

        csvwrite(sprintf("results/a-est-%i-N%i-v%.2f.csv", length(a_est), N, sigma2_v), a_est);
        csvwrite(sprintf("results/a-est-%i-N%i-v%.2f-err.csv", length(a_est), N, sigma2_v), [norm(a_est-[0;a;0]); e; e2; (a_est - [0;a;0])]);
    end
end

