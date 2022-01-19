using HMCExamples

# The main purpose is for tracing the compiler, not for execution speed or results.  Keep the number of samples small
HMCExamples.main_rbc_1_kalman(["--num_samples", "30", "--max_depth", "2", "--results_path", "./results/main_rbc_1_kalman", "--overwrite_results", "true"])
HMCExamples.main_rbc_1_kalman(["--num_samples", "30", "--max_depth", "2", "--print_level", "2", "./results/main_rbc_1_kalman_pl", "--overwrite_results", "true"])
HMCExamples.main_rbc_1_joint(["--num_samples", "30", "--max_depth", "2", "./results/main_rbc_1_joint", "--overwrite_results", "true"])
HMCExamples.main_rbc_2_joint(["--num_samples", "30", "--max_depth", "2", "./results/main_rbc_2_joint", "--overwrite_results", "true"])
HMCExamples.main_FVGQ_1_kalman(["--num_samples", "20", "--print_level", "2", "./results/main_FVGQ_1_kalman", "--overwrite_results", "true"])
HMCExamples.main_FVGQ_1_joint(["--num_samples", "20", "--print_level", "3", "./results/main_FVGQ_1_joint", "--overwrite_results", "true"])
HMCExamples.main_FVGQ_2_joint(["--num_samples", "10", "--max_depth", "2", "./results/main_FVGQ_2_joint", "--overwrite_results", "true"])
