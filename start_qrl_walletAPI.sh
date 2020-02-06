#!/bin/bash

# Start the first process
start_qrl
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start start_qrl: $status"
  exit $status
fi

# Start the second process
qrl_walletd
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start qrl_walletd: $status"
  exit $status
fi

# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep start_qrl |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep qrl_walletd |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done

