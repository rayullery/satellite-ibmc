#!/usr/bin/env bash
declare -a host_name
location=''
username=''
password=''
resource_group=''

print_usage() {
  printf "Usage: ..."
}

while getopts 'h:l:u:p:r:' flag; do
  case "${flag}" in
    h) host_name[${#host_name[@]}]="${OPTARG}" ;;
    l) location="${OPTARG}" ;;
    u) username="${OPTARG}" ;;
    p) password="${OPTARG}" ;;
    r) resource_group="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done
shift $((OPTIND -1))
set -e

## Login and account select
ibmcloud login -u $username -p $password
## Target resource group
ibmcloud target -g $resource_group

## List Locations

ibmcloud sat location ls

## show hosts
printf "\r\nIBM Satellite $location hosts..."
ibmcloud sat host ls --location $location -q

## Remove hosts
for val in "${host_name[@]}"; do 
    echo "Removing $val..."
    ibmcloud sat host rm --location $location --host $host_name -f
done

