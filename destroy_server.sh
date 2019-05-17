#!/usr/bin/env bash
BASE_PATH=$(dirname "$0")

bash_c='bash -c'

$bash_c "cd $BASE_PATH/infrastructures/aws && \
    terraform destroy -auto-approve"
