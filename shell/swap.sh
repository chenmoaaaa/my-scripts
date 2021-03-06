#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  sudoCmd="sudo"
else
  sudoCmd=""
fi

if [[ ! $(cat /proc/swaps | wc -l) -gt 1 ]]; then
  # allocate space
  ${sudoCmd} fallocate -l 1G /swapfile

  # set permission
  ${sudoCmd} chmod 600 /swapfile

  # make swap
  ${sudoCmd} mkswap /swapfile

  # enable swap
  ${sudoCmd} swapon /swapfile

  # make swap permanent
  echo "/swapfile swap swap defaults 0 0" | ${sudoCmd} tee -a /etc/fstab  >/dev/null

  # set swap percentage
  ${sudoCmd} sysctl vm.swappiness=10
  echo "vm.swappiness=10" | ${sudoCmd} tee -a /etc/sysctl.conf >/dev/null

  free -h
else
  free -h
fi

exit 0
