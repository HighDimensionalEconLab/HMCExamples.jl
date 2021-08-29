using HMCExamples

# The main purpose is for tracing the compiler, not for exection speed or results.  Keep the number of samples small
HMCExamples.main_rbc_1_kalman(["--num_samples", "30", "--max_depth", "2"])
HMCExamples.main_rbc_1_kalman(["--num_samples", "30", "--max_depth", "2", "--print_level", "2"])
HMCExamples.main_rbc_1_joint(["--num_samples", "30", "--max_depth", "2"])
HMCExamples.main_rbc_2_joint(["--num_samples", "30", "--max_depth", "2"])
HMCExamples.main_FVGQ_1_kalman(["--num_samples", "50", "--print_level", "3"])
# HMCExamples.main_FVGQ_1_joint(["--num_samples", "10", "--max_depth", "2"])
# HMCExamples.main_FVGQ_2_joint(["--num_samples", "10", "--max_depth", "2"])
