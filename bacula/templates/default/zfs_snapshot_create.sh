#!/usr/local/bin/bash
set -x
exec >/dev/null
zfsname=$1
level=$2
[ -z "${zfsname}" -o -z "${level}" ] && exit 1
_zfsname=$(echo ${zfsname} | sed -e 's/\//_/g')
fifo=/tmp/"${_zfsname}"
mkfifo $fifo

case $level in
  Full)
    # snapshot_baseが存在していれば削除
    zfs list -t snapshot "${zfsname}"@snapshot_base
    if [ $? -eq 0 ]; then
      zfs destroy "${zfsname}"@snapshot_base
    fi
    zfs snapshot "${zfsname}"@snapshot_base
    /usr/local/bin/bash -c "zfs send ${zfsname}@snapshot_base > ${fifo}" 2>&1 </dev/null &
    ;;
  Incremental)
    # 前回のIncrementalが存在していれば削除 (通常存在しないはず)
    zfs list -t snapshot "${zfsname}"@snapshot_incremental
    if [ $? -eq 0 ]; then
      echo "${zfsname}@snapshot_incremental found. destroying..." >&2
      zfs destroy "${zfsname}"@snapshot_incremental
    fi
    zfs snapshot "${zfsname}"@snapshot_incremental
    /usr/local/bin/bash -c "zfs send -i ${zfsname}@snapshot_base ${zfsname}@snapshot_incremental > ${fifo}" 2>&1 </dev/null &
    ;;
  *)
    echo "Level ${level} is not implemented" >&2
    ;;
esac
