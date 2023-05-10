tic
dynare sgu_2.mod;
rt = toc;


load("sgu_2/metropolis/sgu_2_mh1_blck1.mat");
results_path ="../../.replication_results/sgu_2_200_dynare/"

mkdir(results_path)
writematrix(logpo2, results_path + "logpo2.csv")
writematrix(x2, results_path + "x2.csv")
writematrix(rt, results_path + "rt.csv")
save(results_path + "chain.mat", "logpo2", "x2", "rt");
