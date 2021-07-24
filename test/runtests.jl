using HMCExamples
# The main purpose is for tracing the compiler, not for exection speed or results.  Keep the number of samples small
HMCExamples.main_rbc_1_kalman(["--num_samples", "100"])