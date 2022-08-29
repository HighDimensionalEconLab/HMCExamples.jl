addpath("dynare-5.1/matlab");
tic
dynare SU03ext.mod;
rt = toc;
load("SU03ext/metropolis/SU03ext_mh1_blck1.mat");
save("dynare_chains_timed/chain_1st_order.mat", "logpo2", "x2", "rt");
%save("dynare_chains_timed/chain_2nd_order.mat", "logpo2", "x2", "rt");
