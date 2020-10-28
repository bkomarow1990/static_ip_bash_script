#!/bin/bash
debian() {
    ver="$(cat /home/bogdan/00-installer-config.yaml | grep -E "version: *")"
    netmask_correct="[1-9]|[1-2][0-9]|3[0-1]"
    ip_correct="(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-4][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5])"
    read ip_add
    if [[ $ip_add =~ $ip_correct ]] ; then
    adapter=$(ls /sys/class/net | grep en.*)
    read netmask
    read dns1
    read dns2
    if [[ $netmask =~ $netmask_correct ]] ; then
        read gateway
        if [[ $gateway =~ $ip_correct ]] ; then
            echo -e "network:" > /etc/netplan/*.yaml
            echo -e "  ethernets:" >> /etc/netplan/*.yaml
            echo -e "    $adapter">> /etc/netplan/*.yaml
            echo -e "      addresses: [$ip_add/$netmask]" >> /etc/netplan/*.yaml
            echo -e "      gateway4: $gateway" >> /etc/netplan/*.yaml
            echo -e "      nameservers:" >> /etc/netplan/*.yaml
            echo -e "       adresses: [$dns1, $dns2]" >> /etc/netplan/*.yaml
            echo -e "      dhcp4: false" >> /etc/netplan/*.yaml
            echo -e "  version: 2" >> /etc/netplan/*.yaml
            fi
        fi
    fi
    #sudo sed '2,4d' /etc/netplan/00-installer-config.yaml
    #interface="$ip"
}
is_check="$(cat /etc/os-release | grep ID_LIKE)"
  if [[ $is_check == "ID_LIKE=debian" ]] ; then
    debian;
  fi
  if [[ $is_check == "ID_LIKE=redhat" ]] ; then
    echo "redhat"
  fi