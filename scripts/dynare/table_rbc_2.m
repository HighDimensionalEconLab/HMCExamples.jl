addpath("dynare-5.1/matlab");
tic
dynare rbc_2_table.mod;
rt = toc;
load("rbc_2_table/metropolis/rbc_2_mh1_blck1.mat");
save("dynare_chains_timed/chain_2nd_order.mat", "logpo2", "x2", "rt");
