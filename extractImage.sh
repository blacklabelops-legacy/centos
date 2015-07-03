#!/bin/bash

input_file=$1
output_file=$2

guestfish -a ${input_file} --ro <<_EOF_
run
mount /dev/sda /
tar-out / - | gzip --best >>  ${output_file}.tar.gz
_EOF_
