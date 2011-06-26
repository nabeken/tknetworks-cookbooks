#!/usr/local/bin/bash
exec >/dev/null
zfsname=$1
[ -z "${zfsname}" ] && exit 1
_zfsname=$(echo ${zfsname} | sed -e 's/\//_/g')
rm -rf /bacula-restore/tmp/"${_zfsname}"
