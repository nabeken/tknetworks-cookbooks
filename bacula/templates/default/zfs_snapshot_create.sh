#!/usr/local/bin/bash
set -x
exec >/dev/null
zfsname=$1
level=$2
[ -z "${zfsname}" -o -z "${level}" ] && exit 1
_zfsname=$(echo ${zfsname} | sed -e 's/\//_/g')
fifo_dir=/tmp/"${_zfsname}"
rm -rf "${fifo_dir}" && mkdir "${fifo_dir}"

case $level in
  Full)
    # snapshot_baseが存在していれば削除
    zfs list -t snapshot "${zfsname}"@snapshot_base
    if [ $? -eq 0 ]; then
      zfs destroy "${zfsname}"@snapshot_base
    fi
    zfs snapshot "${zfsname}"@snapshot_base
    mkfifo "${fifo_dir}"/@full
    /usr/local/bin/bash -c "zfs send ${zfsname}@snapshot_base > ${fifo_dir}/@full" 2>&1 </dev/null &
    ;;
  Differential)
    # 前回のIncrementalが存在していれば削除 (通常存在しないはず)
    zfs list -t snapshot "${zfsname}"@snapshot_incremental
    if [ $? -eq 0 ]; then
      echo "${zfsname}@snapshot_incremental found. destroying..." >&2
      zfs destroy "${zfsname}"@snapshot_incremental
    fi
    zfs snapshot "${zfsname}"@snapshot_incremental
    mkfifo "${fifo_dir}"/@diff
    /usr/local/bin/bash -c "zfs send -i ${zfsname}@snapshot_base ${zfsname}@snapshot_incremental > ${fifo_dir}"/@diff 2>&1 </dev/null &
    ;;
  *)
    echo "Level ${level} is not implemented" >&2
    ;;
esac
