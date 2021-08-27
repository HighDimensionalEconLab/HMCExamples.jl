using HMCExamples, StatsPlots
# The main purpose is for tracing the compiler, not for exection speed or results.  Keep the number of samples small
HMCExamples.main_rbc_1_kalman(["--num_samples", "10"]) # only do one of them with the figures. Otherwise too slow.
HMCExamples.main_rbc_1_joint(["--num_samples", "10", "--full_results", "false"])
HMCExamples.main_rbc_2_joint(["--num_samples", "10", "--full_results", "false"])
HMCExamples.main_FVGQ_1_kalman(["--num_samples", "10", "--full_results", "false"])
HMCExamples.main_FVGQ_1_joint(["--num_samples", "10", "--full_results", "false"])
HMCExamples.main_FVGQ_2_joint(["--num_samples", "10", "--full_results", "false"])
