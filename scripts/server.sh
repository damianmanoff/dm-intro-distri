#!/bin/bash

PHISICAL_IP=$1


#Hosts
A_IP=10.61.6.197
A_MASK=255.255.255.240
A_TAP=tap2
#---------
B_IP=10.61.5.4
B_MASK=255.255.255.128
B_TAP=tap3
#---------
C_IP=192.168.25.8
C_MASK=255.255.255.0
C_TAP=tap4
#---------
#Servers
WS_IP=192.168.25.7
WS_MASK=255.255.255.0
WS_TAP=tap5

TL_IP=10.61.6.133
TL_MASK=255.255.255.224
TL_TAP=tap6

FTP_IP=10.111.25.3
FTP_MASK=255.255.255.128
FTP_TAP=tap7

	

openvpn --remote $PHISICAL_IP --port 7512 --dev $A_TAP --ifconfig 10.134.5.140 255.255.255.240 $A_IP
openvpn --remote $PHISICAL_IP --port 7513 --dev $B_TAP --ifconfig 10.134.5.140 255.255.255.240 $B_IP
openvpn --remote $PHISICAL_IP --port 7514 --dev $C_TAP --ifconfig 10.134.5.140 255.255.255.240 $C_IP
openvpn --remote $PHISICAL_IP --port 7515 --dev $WS_TAP --ifconfig 10.134.5.140 255.255.255.240 $WS_IP
openvpn --remote $PHISICAL_IP --port 7516 --dev $TL_TAP --ifconfig 10.134.5.140 255.255.255.240 $TL_IP
openvpn --remote $PHISICAL_IP --port 7517 --dev $FTP_TAP --ifconfig 10.134.5.140 255.255.255.240 $FTP_IP

