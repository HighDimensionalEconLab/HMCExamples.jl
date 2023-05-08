tic
dynare rbc_1.mod;
rt = toc;


load("rbc_1/metropolis/rbc_1_mh1_blck1.mat");
results_path ="../../.replication_results/rbc_1_200_dynare/"

mkdir(results_path)
writematrix(logpo2, results_path + "logpo2.csv")
writematrix(x2, results_path + "x2.csv")
writematrix(rt, results_path + "rt.csv")
save(results_path + "chain.mat", "logpo2", "x2", "rt");
