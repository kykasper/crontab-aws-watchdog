#!/bin/bash -

readonly PROCNAME=${0##*/}
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" 
}

source ./config.sh
# You must set 'config.sh' like below.
# #!/bin/bash -

# readonly SERVICE_NAME="hello_world.service"
# readonly AWS_SNS_TOPIC_ARN="arn:aws:sns:ap-northeast-1:123456789:HeartbeatNotification"

function main() {
  log "Start batch program."
  service_active_state=$(systemctl show $SERVICE_NAME | grep "ActiveState=")
  service_status=$(systemctl status $SERVICE_NAME)
  log $service_status
  log $service_active_state

  message=$(echo -e $service_active_state\\n)$service_status

  log $(aws sns publish --topic-arn $AWS_SNS_TOPIC_ARN --message "$message" | jq -c)

  log "End batch program."
}

main