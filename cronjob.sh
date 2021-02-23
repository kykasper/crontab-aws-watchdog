#!/bin/bash -
# You must set 'LOGFILE'
readonly PROCNAME=${0##*/}
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" 
}
SERVICE_NAME="hello_world.service"
AWS_SNS_TOPIC_ARN="arn:aws:sns:ap-northeast-1:953626632882:AlarmNotification1"
service_active_state=$(systemctl show $SERVICE_NAME | grep "ActiveState=")
service_status=$(systemctl status $SERVICE_NAME)
log $service_status
log $service_active_state
message="{'service_status':'$service_status','service_active_state':'$service_active_state'}"
log $message
aws sns publish --topic-arn $AWS_SNS_TOPIC_ARN --message "$message" --message-structure "json"
