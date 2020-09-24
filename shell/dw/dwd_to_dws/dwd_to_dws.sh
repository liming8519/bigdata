#!/usr/bin/env bash

day=$2
if [ -z "$day" ]; then
  day=$(date -d '-1 day' +%F)
fi

hive=/opt/module/hive/bin/hive
echo "$hive"

sql=""
case $1 in
"dws_uv_detail_daycount")
  sql=$(/home/atguigu/bin/dwd_to_dws_uv_detail_daycount.sh $day)
  ;;
esac

echo "$sql"

hive -e "
SET hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
$sql
"

