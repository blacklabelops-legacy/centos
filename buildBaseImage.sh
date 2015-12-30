#!/bin/bash -x

set -o errexit    # abort script at first error

input_file=$1
output_file=$2

sudo python /opt/ami-creator.py -c ${1} -n ${2}
