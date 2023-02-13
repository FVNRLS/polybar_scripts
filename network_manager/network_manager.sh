#!/bin/bash

WIRELESS_INTERFACE=$(ip link | awk -F: '/wlp/ {print $2;getline}' | sed 's/ //')
WIRELESS_STATE=$(ip link show "$WIRELESS_INTERFACE" | grep "state UP" > /dev/null 2>&1; echo $?)
ETHERNET_INTERFACE=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | grep "en" | head -1 | sed 's/ //')

if [[ -z $ETHERNET_INTERFACE ]]; then
  ETHERNET_EXISTS=1
else
  ETHERNET_EXISTS=$(ip link show "$ETHERNET_INTERFACE" > /dev/null 2>&1; echo $?)
fi

if [[ $WIRELESS_STATE -ne 0 && $ETHERNET_EXISTS -ne 0 ]]; then
  ICON="  "
elif [[ $WIRELESS_STATE -eq 0 || $ETHERNET_EXISTS -eq 0 ]]; then
  if [[ -z $ETHERNET_INTERFACE ]]; then
    ICON="  "
  else
    ETHERNET_STATE=$(ip link show "$ETHERNET_INTERFACE" | grep "state UP" > /dev/null 2>&1; echo $?)

    if [[ $ETHERNET_STATE -eq 0 ]]; then
      ICON="  "
    elif [[ $WIRELESS_STATE -eq 0 ]]; then
      ICON="  "
    fi
  fi
fi

echo "${ICON}"
