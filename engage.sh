#!/usr/bin/env bash

# Parse flags
while getopts i:o: flag
do
    # Generate a new ssh key, if -k flag is used.
    [[ $flag == k ]] && ( echo "Generating new key: ${OPTARG}"; \
        [ -e "${OPTARG}" ] && rm "${OPTARG}"
        [ -e "${OPTARG}.pub" ] && rm "${OPTARG}.pub"
        ssh-keygen -b 4096 -t rsa -f $OPTARG -q -N "" )
done

# Set env vars
export TF_VAR_os_user_password=$(pass tfts/os_password)
export TF_VAR_ts_admin_password=$(pass tfts/ts_admin_password)

echo -e "Running:\nterraform $1"
terraform $1

unset TF_VAR_os_user_password
unset TF_VAR_ts_admin_password
