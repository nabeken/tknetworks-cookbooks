#!/usr/locl/bin/bash
exec >/dev/null
zfsname=$1
level=$2
[ -z "${zfsname}" -o -z "${level}" ] && exit 1
_zfsname=$(echo ${zfsname} | sed -e 's/\//_/g')
fifo=/tmp/"${_zfsname}"

rm $fifo

case $level in
  Full)
    ;;
  Incremental)
    zfs destroy "${zfsname}"@snapshot_incremental
    ;;
  *)
    echo "Level ${level} is not implemented" >&2
    ;;
esac
