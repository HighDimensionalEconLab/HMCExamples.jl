% Robustness check for dynare

n_alpha = 5;
n_beta = 5;
n_rho = 5;
alpha_list = linspace(0.25, 0.45, n_alpha);
beta_list = linspace(0.1, 0.4, n_beta);
rho_list = linspace(0.3, 0.95, n_rho);

% skipping some extreme points
for i = 1:4
    for j = 1:4
        for k = 2:5
            % Updating the 
            xparam1 = [alpha_list(i); beta_list(j); rho_list(k)];
            save("rbc_2_robustness_init_params.mat", "xparam1");

            % Run the experiment
            tic
            dynare rbc_2_robustness.mod;
            rt = toc;

            load("rbc_2_robustness/metropolis/rbc_2_robustness_mh1_blck1.mat");

            % Save the results
            results_path ="../../.replication_results/dynare_robustness/rbc_2_robusteness_"+string(i) + "_" + string(j) + "_" + string(k) + "/";
            mkdir(results_path);

            writematrix(xparam1, results_path + "xparam1.csv")
            writematrix(logpo2, results_path + "logpo2.csv")
            writematrix(x2, results_path + "x2.csv")
            writematrix(rt, results_path + "rt.csv")
            save(results_path + "chain.mat", "logpo2", "x2", "rt");
        end
    end
end
