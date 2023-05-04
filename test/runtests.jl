using HMCExamples

HMCExamples.parse_commandline_rbc_1_kalman(ARGS)
HMCExamples.parse_commandline_rbc_1_joint(ARGS)
HMCExamples.parse_commandline_rbc_2_joint(ARGS)
HMCExamples.parse_commandline_rbc_sv_2_joint(ARGS)

HMCExamples.parse_commandline_sgu_1_kalman(ARGS)
HMCExamples.parse_commandline_sgu_1_joint(ARGS)
HMCExamples.parse_commandline_sgu_2_joint(ARGS)


# The main purpose is for tracing the compiler, not for execution speed or results.  Keep the number of samples small
HMCExamples.main_rbc_1_kalman(["--num_samples", "10", "--max_depth", "2", "--results_path", "./.results/rbc_1_kalman_test", "--overwrite_results", "true"])
HMCExamples.main_rbc_1_joint(["--num_samples", "10", "--max_depth", "2", "--results_path", "./.results/rbc_1_joint_test", "--overwrite_results", "true"])
HMCExamples.main_rbc_2_joint(["--num_samples", "10", "--max_depth", "2", "--results_path", "./.results/rbc_2_joint_test", "--overwrite_results", "true"])
HMCExamples.main_rbc_sv_2_joint(["--num_samples", "10", "--max_depth", "2", "--results_path", "./.results/rbc_sv_2_joint_test", "--overwrite_results", "true"])

HMCExamples.main_sgu_1_kalman(["--num_samples", "10", "--max_depth", "2", "--results_path", "./.results/sgu_1_kalman_test", "--overwrite_results", "true"])
HMCExamples.main_sgu_1_joint(["--num_samples", "10", "--max_depth", "2", "--results_path", "./.results/sgu_1_joint_test", "--overwrite_results", "true"])
HMCExamples.main_sgu_2_joint(["--num_samples", "10", "--max_depth", "2", "--results_path", "./.results/sgu_2_joint_test", "--overwrite_results", "true"])