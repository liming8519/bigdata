#!/usr/bin/env bash

day=$1
if [ -z "$day" ]; then
  day=$(date -d '-1 day' +%F)
fi

app=gmall
sql="
insert overwrite table $app.dwd_action_log partition (dt = '$day')
select get_json_object(line, '$.common.ar'),
       get_json_object(line, '$.common.ba'),
       get_json_object(line, '$.common.ch'),
       get_json_object(line, '$.common.md'),
       get_json_object(line, '$.common.mid'),
       get_json_object(line, '$.common.os'),
       get_json_object(line, '$.common.uid'),
       get_json_object(line, '$.common.vc'),
       get_json_object(line, '$.page.during_time'),
       get_json_object(line, '$.page.item'),
       get_json_object(line, '$.page.item_type'),
       get_json_object(line, '$.page.last_page_id'),
       get_json_object(line, '$.page.page_id'),
       get_json_object(line, '$.page.sourceType'),
       get_json_object(action, '$.action_id'),
       get_json_object(action, '$.item'),
       get_json_object(action, '$.item_type'),
       get_json_object(action, '$.ts')
from $app.ods_log lateral view $app.explode_json_array(get_json_object(line, '$.actions')) tmp as action
where get_json_object(line, '$.actions') is not null
  and dt = '$day';
"
echo "$sql"
