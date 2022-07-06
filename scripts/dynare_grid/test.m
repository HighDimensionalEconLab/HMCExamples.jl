% simple dynare run

addpath "./dynare-5.1/matlab";
load("rbc_mode.mat");
% change the mod file to make it first-order or second-order
i = 0.25;
j = 0.1;
k = 0.3;
filename = "test";
disp(filename);
xparam1 = [i; j; k];
save("rbc_mode.mat", "xparam1", "parameter_names");
tic
dynare rbc.mod;
rt = toc;
load(".\rbc\metropolis\rbc_mh1_blck1.mat");
save("chains_" + filename + ".mat", "logpo2", "x2", "rt");
