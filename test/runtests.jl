using HMCExamples

# The main purpose is for tracing the compiler, not for execution speed or results.  Keep the number of samples small
HMCExamples.main_rbc_1_kalman(["--num_samples", "30", "--max_depth", "2", "--results_path", "./.results/rbc_1_kalman_test", "--overwrite_results", "true", "--init_params_file", "data/rbc_1_kalman_burnin_dynare.csv"])
#HMCExamples.main_rbc_1_kalman(["--num_samples", "100", "--max_depth", "2", "--print_level", "2", "--results_path", "./.results/rbc_1_kalman_test_2", "--overwrite_results", "true"])
#HMCExamples.main_rbc_1_kalman(["--num_samples", "60", "--max_depth", "2", "--results_path", "./.results/rbc_1_kalman_test_chains", "--overwrite_results", "true", "--num_chains", "4"])
HMCExamples.main_rbc_1_joint(["--num_samples", "30", "--max_depth", "2", "--results_path", "./.results/rbc_1_joint_test", "--overwrite_results", "true", "--init_params_file", "data/rbc_1_joint_burnin_ergodic.csv"])
#HMCExamples.main_rbc_1_joint(["--num_samples", "30", "--max_depth", "2", "--results_path", "./.results/rbc_1_joint_test_discard", "--overwrite_results", "true", "--discard_initial", "10","--init_params_file", ""])
#HMCExamples.main_rbc_1_joint(["--num_samples", "30", "--max_depth", "2", "--results_path", "./.results/rbc_1_joint_test_use_burnin", "--overwrite_results", "true", "--init_params_file", "data/rbc_1_joint_burnin.csv"])

#HMCExamples.main_rbc_2_joint(["--num_samples", "30", "--max_depth", "2", "--results_path", "./.results/rbc_2_joint_test", "--overwrite_results", "true", "--init_params_file", "data/rbc_2_joint_burnin_ergodic.csv"])
HMCExamples.parse_commandline_rbc_2_joint(ARGS)

# #Need to call with the -O1 compilation is working with PackageCompiler at this point
HMCExamples.parse_commandline_FVGQ_1_kalman(ARGS)
HMCExamples.parse_commandline_FVGQ_1_joint(ARGS)
HMCExamples.parse_commandline_FVGQ_2_joint(ARGS)
# HMCExamples.main_FVGQ_1_kalman(["--num_samples", "20", "--max_depth", "2", "--print_level", "1", "--results_path", "./results/main_FVGQ_1_kalman", "--overwrite_results", "true"])
# HMCExamples.main_FVGQ_1_joint(["--num_samples", "20", "--max_depth", "2", "--print_level", "1", "--results_path", "./results/main_FVGQ_1_joint", "--overwrite_results", "true"])
# HMCExamples.main_FVGQ_2_joint(["--num_samples", "20", "--max_depth", "2", "--results_path", "./results/main_FVGQ_2_joint", "--overwrite_results", "true"])

HMCExamples.parse_commandline_sgu_1_kalman(ARGS)
HMCExamples.parse_commandline_sgu_1_joint(ARGS)
HMCExamples.parse_commandline_sgu_2_joint(ARGS)
HMCExamples.main_sgu_1_kalman(["--num_samples", "30", "--max_depth", "2", "--results_path", "./.results/sgu_1_kalman_test", "--overwrite_results", "true"])
HMCExamples.main_sgu_1_joint(["--num_samples", "30", "--max_depth", "2", "--results_path", "./.results/sgu_1_joint_test", "--overwrite_results", "true"])
# HMCExamples.main_sgu_2_joint(["--num_samples", "30", "--max_depth", "2", "--results_path", "./.results/sgu_2_joint_test", "--overwrite_results", "true", "--init_params_file", "data/sgu_2_joint_burnin.csv"])