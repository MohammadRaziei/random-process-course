clc; close all; clear
mkdir results
addpath ../common/

N = 20000;

rng(1)
p = .5;

s_n = 2*(rand(N,1) < p)-1;
w_n = (rand(N,1)*2-1)*.7;
r_n = s_n + w_n;

run_for(1, r_n, s_n, w_n);



rng(1)
p = .6;

s_n = 2*(rand(N,1) < p)-1;
w_n = (rand(N,1)*2-1)*.7;
r_n = s_n + w_n;

run_for(2, r_n, s_n, w_n);


%%

rng(1)

pd = makedist('Triangular','A',-.7,'B',0,'C',.7);
w_n = random(pd, N, 1);
p = .5;
s_n = 2*(rand(N,1) < p)-1;
r_n = s_n + w_n;

run_for(3, r_n, s_n, w_n);




%%


rng(1)

pd = makedist('Triangular','A',-.7,'B',0,'C',.7);
w_n = random(pd, N, 1);
p = .6;
s_n = 2*(rand(N,1) < p)-1;
r_n = s_n + w_n;

run_for(4, r_n, s_n, w_n);


%%
rng(1)

pd = makedist('Normal','mu',0,'sigma',1);
w_n = random(pd, N, 1);
p = .5;
s_n = 2*(rand(N,1) < p)-1;
r_n = s_n + w_n;

run_for(5, r_n, s_n, w_n);



