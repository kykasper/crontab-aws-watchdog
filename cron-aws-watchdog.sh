#!/bin/bash -

readonly PROCNAME=${0##*/}
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" 
}

source ./config.sh
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
STATE_FILE="./state.sh"

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

  if [[ ! -e $STATE_FILE ]]; then
    touch $STATE_FILE
  fi
  before_service_state=$(cat $STATE_FILE)
  echo $service_active_state > $STATE_FILE

  subject=$service_active_state

  if [[ $service_active_state = $before_service_state ]]; then
    subject="ServiceActiveStateDontChange"
  fi
  log $subject
  message=$service_status

  log $(aws sns publish --topic-arn $AWS_SNS_TOPIC_ARN --message "$message" --subject "$subject" | jq -c)

  log "End batch program."
}

main
