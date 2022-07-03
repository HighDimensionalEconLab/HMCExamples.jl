using DelimitedFiles

kalman = readdlm("data/rbc_1_kalman_burnin_dynare.csv", ',')
joint_1 = readdlm("data/rbc_1_joint_burnin_ergodic.csv", ',')
joint_2 = readdlm("data/rbc_2_joint_burnin_ergodic.csv", ',')
for alpha in [0.25 0.3 0.35 0.4 0.45]
    for beta_draw in [0.1 0.175 0.25 0.325 0.4]
        for rho in [0.3 0.4625 0.625 0.7875 0.95]
            kalman[1] = alpha
            kalman[2] = beta_draw
            kalman[3] = rho
            writedlm(string(".data/rbc_1_kalman_burnin_dynare_", replace(string(alpha), "."=>"_"), replace(string(beta_draw), "."=>"_"), replace(string(rho), "."=>"_"), ".csv"), kalman, ',')
            joint_1[1] = alpha
            joint_1[2] = beta_draw
            joint_1[3] = rho
            writedlm(string(".data/rbc_1_joint_burnin_ergodic_", replace(string(alpha), "."=>"_"), replace(string(beta_draw), "."=>"_"), replace(string(rho), "."=>"_"), ".csv"), joint_1, ',')
            joint_2[1] = alpha
            joint_2[2] = beta_draw
            joint_2[3] = rho
            writedlm(string(".data/rbc_2_joint_burnin_ergodic_", replace(string(alpha), "."=>"_"), replace(string(beta_draw), "."=>"_"), replace(string(rho), "."=>"_"), ".csv"), joint_2, ',')
            println(alpha, " ", beta_draw, " ", rho)
        end
    end
end
