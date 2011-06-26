#!/usr/local/bin/bash
set -x
exec >/dev/null
zfsname=$1
[ -z "${zfsname}" ] && exit 1

# 第2引数がなければ自分自身に第2引数をつけて呼びなおす
if [ -z "$2" ]; then
  exec /usr/local/bin/bash $0 $1 sleep 2>&1 </dev/null &
else
  # 第2引数があれば10秒待つ
  sleep 10
fi
_zfsname=$(echo ${zfsname} | sed -e 's/\//_/g')
backup_dir=/bacula-restore/tmp/${_zfsname}

if [ -p "${backup_dir}"/@full ]; then
  echo "Full backup found... restoring..." >&2
  zfs list -t snapshot "${zfsname}"@full_restored >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${zfsname}@full_restored found. destroying..." >&2
    zfs destroy "${zfsname}"@full_restored
  fi
  /usr/local/bin/bash -c "cat ${backup_dir}/@full | zfs recv ${zfsname}@full_restored" 2>&1 </dev/null &
else
  if [ -p "${backup_dir}"/@diff ]; then
    echo "Differential backup found... restoring..." >&2
    zfs list -t snapshot "${zfsname}"@diff_restored >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "${zfsname}@diff_restored found. destroying..." >&2
      zfs destroy "${zfsname}"@diff_restored
    fi
    /usr/local/bin/bash -c "cat ${backup_dir}/@diff | zfs recv ${zfsname}@diff_restored" 2>&1 </dev/null &
  fi
fi
