#!/usr/bin/env bash

ls -lia -R /datastores
ls /datastores/matlablic
export MLM_LICENSE_FILE=/datastores/matlablic/license.lic

# run
matlab -batch scripts/dynare_grid/test.m
