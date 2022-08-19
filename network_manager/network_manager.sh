#!/bin/sh

wifi_state=$(sudo ethtool wlp1s0 | grep "Link detected" | cut -f 2 | cut -c 16-18)
ethernet_exists=$(ls /sys/class/net/ | grep enp0s20f0u3u4u2 | wc -l)

if [[ $wifi_state -eq  "no" && $ethernet_exists -eq  0 ]]
then
	icon="  "
else
	if [[ $ethernet_exists -gt 0 ]]
	then
		ethernet_state=$(sudo ethtool enp0s20f0u3u4u2 | grep "Link detected" | cut -f 2 | cut -c 16-18)
		if [[ $wifi_state -eq "no" && $ethernet_state -eq "yes" ]]
		then
			icon="  "
		elif [[ $wifi_state -eq  "yes" && $ethernet_state -eq  "yes" ]]
		then
			icon="  "
		elif [[ $wifi_state -eq  "yes" && $ethernet_exists -eq  "0" ]]
		then
			icon="  "
		fi	
	fi
fi

echo "${icon}"