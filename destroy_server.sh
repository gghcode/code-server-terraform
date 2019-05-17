#!/bin/sh
baseDir=$(dirname "$0")
sh -c "cd ${baseDir}/infrastructures/aws && terraform destroy -auto-approve"
