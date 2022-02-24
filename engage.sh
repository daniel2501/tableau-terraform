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

# Set env vars for secrets
export TF_VAR_os_user_password=$(pass tfts/os_password)
export TF_VAR_ts_admin_password=$(pass tfts/ts_admin_password)
export AWS_ACCESS_KEY_ID=$(pass aws/access-key-id)
export AWS_SECRET_ACCESS_KEY=$(pass aws/secret-access-key)
export AWS_DEFAULT_REGION=us-east-1

echo -e "Running:\nterraform ${@}"
terraform "$@"

unset TF_VAR_os_user_password
unset TF_VAR_ts_admin_password
