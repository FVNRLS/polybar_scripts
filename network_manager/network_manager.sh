#!/bin/bash

# Cache the results for 60 seconds
CACHE_EXPIRY=60
CACHE_FILE="/tmp/network_speed_cache"

if [[ -f $CACHE_FILE ]] && [[ $(find "$CACHE_FILE" -mmin -$CACHE_EXPIRY) ]]; then
  # Use cached results
  ICON=$(cat "$CACHE_FILE")
else
  # Obtain network interface information
  WIRELESS_INTERFACE=$(ip link | awk -F: '/wlp/ {print $2;getline}' | sed 's/ //')
  WIRELESS_STATE=$(ip link show "$WIRELESS_INTERFACE" | grep "state UP" > /dev/null 2>&1; echo $?)
  ETHERNET_INTERFACE=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | grep "en" | head -1 | sed 's/ //')
  ETHERNET_EXISTS=$(ip link show "$ETHERNET_INTERFACE" > /dev/null 2>&1; echo $?)

  # Determine the network speed
  if [[ $ETHERNET_EXISTS -eq 0 ]]; then
    SPEED=$(ethtool "$ETHERNET_INTERFACE" | awk '/Speed:/ {print $2}')
    ICON=" $SPEED"
  elif [[ $WIRELESS_STATE -eq 0 ]]; then
    SIGNAL=$(grep "$WIRELESS_INTERFACE" /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')
    ICON=" $SIGNAL%"
  else
    ICON=""
  fi

  # Cache the results
  echo "$ICON" > "$CACHE_FILE"
fi

echo "$ICON"
