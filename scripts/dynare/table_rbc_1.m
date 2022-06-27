addpath("dynare-5.1/matlab");
tic
dynare rbc_1.mod;
rt = toc;
load("rbc_1/metropolis/rbc_1_mh1_blck1.mat");
save("dynare_chains_timed/chain_1st_order.mat", "logpo2", "x2", "rt");
