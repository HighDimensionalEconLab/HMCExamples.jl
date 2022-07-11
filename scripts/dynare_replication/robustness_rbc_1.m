% Robustness check for dynare

addpath("dynare-5.1/matlab");

n_alpha = 5;
n_beta = 5;
n_rho = 5;
alpha_list = linspace(0.25, 0.45, n_alpha);
beta_list = linspace(0.1, 0.4, n_beta);
rho_list = linspace(0.3, 0.95, n_rho);

% change the mod file to make it first-order or second-order
% not using the highest extreme points
for i = 1:4
    for j = 1:4
        for k = 2:5
            filename = string(i) + "_" + string(j) + "_" + string(k);
            disp(filename);
            if ~exist("dynare_chains_1/chains_" + filename + ".mat", 'file')
                xparam1 = [alpha_list(i); beta_list(j); rho_list(k)];
                save("rbc_mode.mat", "xparam1");
                tic
                dynare rbc_1_robustness.mod;
                rt = toc;
                load("rbc_1_robustness/metropolis/rbc_1_robustness_mh1_blck1.mat");
                save("dynare_chains_1/chains_" + filename + ".mat", "logpo2", "x2", "rt");
            end
        end
    end
end
