addpath("dynare-5.1/matlab");
tic
dynare rbc_1_table.mod;
rt = toc;
load("rbc_1_table/metropolis/rbc_1_mh1_blck1.mat");
save("dynare_chains_timed/chain_1st_order.mat", "logpo2", "x2", "rt");
