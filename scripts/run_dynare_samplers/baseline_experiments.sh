#!/bin/bash
cd scripts/run_dynare_samplers
matlab -nosplash -nodesktop -r "run('rbc_1.m');exit;"
matlab -nosplash -nodesktop -r "run('rbc_2.m');exit;"
matlab -nosplash -nodesktop -r "run('sgu_1.m');exit;"
matlab -nosplash -nodesktop -r "run('sgu_2.m');exit;"