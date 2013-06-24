#!/bin/sh -ue

# -e 例外はく
# -u 定義されていない変数を使ったらエラーをはく
# -x デバッグ便利

declare -r CMDNAME=$(basename $0)

usage_exit() {
  echo "Usage: ${CMDNAME} -h remote_host -u remote_mysql_user -p remote_mysql_pass dbname (dbname...)"
  exit 1
}

if [ -f ~/.my_env.sh ]; then
  . ~/.my_env.sh
fi

REMOTE_HOST=''
MYSQL_USER=''
MYSQL_PASS=''

while getopts :h:u:p: OPT
do
  case $OPT in
    h ) REMOTE_HOST=${OPTARG};;
    u ) MYSQL_USER=${OPTARG};;
    p ) MYSQL_PASS=${OPTARG};;
    ? ) usage_exit;;
  esac
done

shift $(($OPTIND-1))

if [ $# -eq 0 ]; then
  usage_exit
fi
if [ -z "$REMOTE_HOST" ]; then
  usage_exit
fi
if [ -z "$MYSQL_USER" ]; then
  usage_exit
fi
if [ -z "$MYSQL_PASS" ]; then
  usage_exit
fi


ssh -c arcfour -C ${REMOTE_HOST} "mysqldump --user=${MYSQL_USER} --password=${MYSQL_PASS} --databases $@ | gzip" | zcat
