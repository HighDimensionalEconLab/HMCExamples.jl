addpath("dynare-5.1/matlab");
tic
dynare rbc_2.mod;
rt = toc;
load("rbc_2/metropolis/rbc_2_mh1_blck1.mat");
save("dynare_chains_timed/chain_2nd_order.mat", "logpo2", "x2", "rt");
