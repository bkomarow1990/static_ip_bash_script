#!/bin/bash
debian() {
    #ip_correct="(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-4][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5])"
     read -r -p "ENTER IP ADDR : " ip_add
    if [[ $ip_add =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]] ; then
   adapter=$(ls /sys/class/net | grep en.*)
      read -r -p "ENTER NETMASK : " netmask
      read -r -p "ENTER DNS 1 : " dns1
      read -r -p "ENTER DNS 2 : " dns2
    else
    echo "Enter correct IP ADDR"
    if [[ $netmask < 32 && $netmask > 0 ]] ; then
        read -r -p "ENTER DEFAULT GATEWAY " gateway
    else 
    echo "Enter correct NETMASK"
        if [[ $gateway =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]] ; then
            echo -e "network:" > /etc/netplan/*.yaml
            echo -e "  ethernets:" >> /etc/netplan/*.yaml
            echo -e "    $adapter">> /etc/netplan/*.yaml
            echo -e "      addresses: [$ip_add/$netmask]" >> /etc/netplan/*.yaml
            echo -e "      gateway4: $gateway" >> /etc/netplan/*.yaml
            echo -e "      nameservers:" >> /etc/netplan/*.yaml
            echo -e "       adresses: [$dns1, $dns2]" >> /etc/netplan/*.yaml
            echo -e "      dhcp4: false" >> /etc/netplan/*.yaml
            echo -e "  version: 2" >> /etc/netplan/*.yaml
            sudo netplan apply
            else
            echo "Enter correct DEFAULT GATEWAY"
            fi
        fi
    fi
    #sudo sed '2,4d' /etc/netplan/00-installer-config.yaml
    #interface="$ip"
}
help(){
echo "Enter Correct IP!"
}
redhat(){
  read -r -p "ENTER IP ADDR " ip_add
  if [[ $ip_add =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]] ; then
  echo -e "EXAMPLE: 255.255.255.0"
  read -r -p "ENTER NETMASK ... " netmask
    
    read -r -p "ENTER DNS 1 " dns1
  else 
    echo -e "Eneter correct IP"
    exit 1
  fi
    if [[ $netmask =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]] ; then
      read -r -p "ENTER DEFAULT GATEWAY " gateway
      else
        echo "INCORRECT NETMASK"
        exit 1
    fi
      if [[ $gateway =~ ^((25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})[.]){3}(25[0-5]|2[0-4][0-9]|[01][0-9][0-9]|[0-9]{1,2})$ ]] ; then
        var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep BOOTPROTO)
      else
        echo "INCORRECT DEFAULT GATEWAY"
        exit 1
      fi
        if grep "BOOTPROTO" /etc/sysconfig/network-scripts/ifcfg-e* | grep "static" /etc/sysconfig/network-scripts/ifcfg-e* ; then
           sed -i "s/$var/BOOTPROTO=\"static\"/g" /etc/sysconfig/network-scripts/ifcfg-e*
        fi
        if grep "IPADDR" /etc/sysconfig/network-scripts/ifcfg-e* ; then
            var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep IPADDR)
            sed -i "s/$var/IPADDR=$ip_add/g" /etc/sysconfig/network-scripts/ifcfg-e*
        else 
            echo "IPADDR=$ip_add" >> /etc/sysconfig/network-scripts/ifcfg-e*
        fi
        if grep "NETMASK" /etc/sysconfig/network-scripts/ifcfg-e* ; then
            var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep NETMASK)
            sed -i "s/$var/NETMASK=$netmask/g" /etc/sysconfig/network-scripts/ifcfg-e*
            else 
            echo "NETMASK=$netmask" >> /etc/sysconfig/network-scripts/ifcfg-e*
        fi
        if grep "GETWAY" /etc/sysconfig/network-scripts/ifcfg-e* ; then
            var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep GETWAY)
            sed -i "s/$var/GETWAY=$gateway/g" /etc/sysconfig/network-scripts/ifcfg-e*
            else 
            echo "GETWAY=$gateway" >> /etc/sysconfig/network-scripts/ifcfg-e*
        fi
        if grep "DNS" /etc/sysconfig/network-scripts/ifcfg-e* ; then
            var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep DNS)
            sed -i "s/$var/DNS=$dns1/g" /etc/sysconfig/network-scripts/ifcfg-e*
            else 
            echo "DNS=$dns1" >> /etc/sysconfig/network-scripts/ifcfg-e*
        fi
        systemctl restart NetworkManager
}
is_check="$(cat /etc/os-release | grep ID_LIKE)"
  if [[ $is_check == "ID_LIKE=debian" ]] ; then
    debian;
  fi
  if [[ $is_check == "ID_LIKE=\"rhel fedora\"" ]] ; then
    redhat;
  fi