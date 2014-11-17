#!/bin/bash

#Redes
RED_A="192.168.25.0" #/24
RED_B="10.111.25.0" #/25
RED_C="10.61.6.128" #/27
RED_D="10.61.5.0" #/24
RED_E="10.61.7.128" #/26
RED_F="10.61.7.192" #/28
RED_G="10.111.25.128" #/25
RED_H="10.61.6.192" #/28
RED_I="10.61.6.160" #/27
RED_J="10.61.6.208" #/28
RED_K="10.61.6.224" #/30
RED_L="10.61.6.228" #/30
RED_M="10.61.7.224" #/27
RED_R1R8="10.7.5.64" #/30
RED_R1R9="10.7.5.68" #/30
RED_R1R15="10.7.5.72" #/30
RED_R8R9="10.7.5.76" #/30
RED_R8R15="10.7.5.80" #/30
RED_R9R15="10.7.5.84" #/30
RED_RBRC="157.63.5.0" #/30
RED_RARC="157.63.5.4" #/30
RED_R7RB="157.63.5.8" #/30
RED_R13RA="157.63.5.12" #/30

#Mascaras
MASK_24="255.255.255.0"
MASK_25="255.255.255.128"
MASK_26="255.255.255.192"
MASK_27="255.255.255.224"
MASK_28="255.255.255.240"
MASK_29="255.255.255.248"
MASK_30="255.255.255.252"

# IP hostA
IP_A="10.61.6.197"
BROADCAST_A="10.61.6.207"
MASCARA_A=$MASK_28

# IP hostB
IP_B="10.61.5.4"
BROADCAST_B="10.61.5.255"
MASCARA_B=$MASK_24

# IP hostC
IP_C="192.168.25.6"
BROADCAST_C="192.168.25.255"
MASCARA_C=$MASK_24

# IP WebServer
IP_WEBSERVER="192.168.25.7"
BROADCAST_WEBSERVER="192.168.25.255"
MASCARA_WEBSERVER=$MASK_24

# IPs TelServer
IP_TELSERVER_C="10.61.6.133"
BROADCAST_TELSERVER_C="10.61.6.159"
MASCARA_TELSERVER_C=$MASK_27
IP_TELSERVER_D="10.61.5.5"
BROADCAST_TELSERVER_D="10.61.5.255"
MASCARA_TELSERVER_D=$MASK_24

# IP FTPServer
IP_FTPSERVER="10.111.25.3"
BROADCAST_FTPSERVER="10.111.25.127"
MASCARA_FTPSERVER=$MASK_25


#Funcion de verificacion e instalacion de un paquete
function verificarEInstalarPaquete {
	paquete=$1
	echo "Verificando instalacion de $paquete."
	INSTALADO=`dpkg -s $paquete | grep -i "Status: install ok installed" | wc -l`
	if [ $INSTALADO -ne "1" ]; then
		echo " * El paquete $paquete no se encuentra instalado."
		echo "Instalando $paquete ..."
		apt-get install -y --force-yes $paquete
	else
		echo "$paquete se encuentra correctamente instalado."
	fi
}

#Verifica que apache2 se encuentre instalado
function verificarApache2 {
	verificarEInstalarPaquete apache2
	if [ -f /etc/init.d/apache2 ]; then
		return 1
	else
		echo "Error: Apache2 no se encuentra instalado."
		return 0
	fi
}

#Verifica que ftp se encuentre instalado
function verificarFTP {
	verificarEInstalarPaquete vsftpd
	if [ -f /etc/init.d/vsftpd ]; then
	    	return 1
	else
		echo "Error: FTPServer no se encuentra instalado."
		return 0
	fi
}

#Verifica que telnet se encuentre instalado
function verificarFTP {
	verificarEInstalarPaquete openbsd-inetd
	if [ -f /etc/init.d/openbsd-inetd ]; then
	    	return 1
    	else
		echo "Error: TelServer no se encuentra instalado."
		return 0
    	fi
}

#Configura el hostA
function configurarHostA {
	#Configuracion de interfaces
	ifconfig $interfaz $IP_A broadcast $BROADCAST_A netmask $MASCARA_A

	#Configuracion del enrutamiento estatico
	route add -net $RED_A netmask $MASK_24 gw "10.61.6.193" dev $interfaz
	route add -net $RED_B netmask $MASK_25 gw "10.61.6.195" dev $interfaz
	route add -net $RED_C netmask $MASK_27 gw "10.61.6.194" dev $interfaz
	route add -net $RED_D netmask $MASK_24 gw "10.61.6.194" dev $interfaz
	route add -net $RED_E netmask $MASK_26 gw "10.61.6.193" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "10.61.6.193" dev $interfaz
	route add -net $RED_G netmask $MASK_25 gw "10.61.6.195" dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw "10.61.6.194" dev $interfaz
	route add -net $RED_J netmask $MASK_28 gw "10.61.6.194" dev $interfaz
	route add -net $RED_K netmask $MASK_30 gw "10.61.6.194" dev $interfaz
	route add -net $RED_L netmask $MASK_30 gw "10.61.6.195" dev $interfaz
	route add -net $RED_M netmask $MASK_27 gw "10.61.6.195" dev $interfaz
	route add -net $RED_R1R8 netmask $MASK_30 gw "10.61.6.193" dev $interfaz
	route add -net $RED_R1R9 netmask $MASK_30 gw "10.61.6.195" dev $interfaz
	route add -net $RED_R1R15 netmask $MASK_30 gw "10.61.6.194" dev $interfaz
	route add -net $RED_R8R9 netmask $MASK_30 gw "10.61.6.193" dev $interfaz
	route add -net $RED_R8R15 netmask $MASK_30 gw "10.61.6.194" dev $interfaz
	route add -net $RED_R9R15 netmask $MASK_30 gw "10.61.6.195" dev $interfaz
	route add -net $RED_RBRC netmask $MASK_30 gw "10.61.6.193" dev $interfaz
	route add -net $RED_RARC netmask $MASK_30 gw "10.61.6.196" dev $interfaz
	route add -net $RED_R7RB netmask $MASK_30 gw "10.61.6.195" dev $interfaz
	route add -net $RED_R13RA netmask $MASK_30 gw "10.61.6.196" dev $interfaz
}

#Configura el hostB
function configurarHostB {
	#Configuracion de interfaces
	ifconfig $interfaz $IP_B broadcast $BROADCAST_B netmask $MASCARA_B

	#Configuracion del enrutamiento estatico
	route add -net $RED_A netmask $MASK_24 gw "10.61.5.3" dev $interfaz
	route add -net $RED_B netmask $MASK_25 gw "10.61.5.3" dev $interfaz
	route add -net $RED_C netmask $MASK_27 gw "10.61.5.3" dev $interfaz
	route add -net $RED_E netmask $MASK_26 gw "10.61.5.3" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "10.61.5.3" dev $interfaz
	route add -net $RED_G netmask $MASK_25 gw "10.61.5.3" dev $interfaz
	route add -net $RED_H netmask $MASK_28 gw "10.61.5.3" dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw "10.61.5.2" dev $interfaz
	route add -net $RED_J netmask $MASK_28 gw "10.61.5.2" dev $interfaz
	route add -net $RED_K netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_L netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_M netmask $MASK_27 gw "10.61.5.3" dev $interfaz
	route add -net $RED_R1R8 netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_R1R9 netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_R1R15 netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_R8R9 netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_R8R15 netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_R9R15 netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_RBRC netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_RARC netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_R7RB netmask $MASK_30 gw "10.61.5.3" dev $interfaz
	route add -net $RED_R13RA netmask $MASK_30 gw "10.61.5.3" dev $interfaz
}

#Configura el hostC
function configurarHostC {
	#Configuracion de interfaces
	ifconfig $interfaz $IP_C broadcast $BROADCAST_C netmask $MASCARA_C

	#Configuracion del enrutamiento estatico
	route add -net $RED_B netmask $MASK_25 gw "192.168.25.3" dev $interfaz
	route add -net $RED_C netmask $MASK_27 gw "192.168.25.3" dev $interfaz
	route add -net $RED_D netmask $MASK_24 gw "192.168.25.3" dev $interfaz
	route add -net $RED_E netmask $MASK_26 gw "192.168.25.6" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "192.168.25.6" dev $interfaz
	route add -net $RED_G netmask $MASK_25 gw "192.168.25.3" dev $interfaz
	route add -net $RED_H netmask $MASK_28 gw "192.168.25.3" dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw "192.168.25.3" dev $interfaz
	route add -net $RED_J netmask $MASK_28 gw "192.168.25.3" dev $interfaz
	route add -net $RED_K netmask $MASK_30 gw "192.168.25.3" dev $interfaz
	route add -net $RED_L netmask $MASK_30 gw "192.168.25.3" dev $interfaz
	route add -net $RED_M netmask $MASK_27 gw "192.168.25.6" dev $interfaz
	route add -net $RED_R1R8 netmask $MASK_30 gw "192.168.25.2" dev $interfaz
	route add -net $RED_R1R9 netmask $MASK_30 gw "192.168.25.2" dev $interfaz
	route add -net $RED_R1R15 netmask $MASK_30 gw "192.168.25.2" dev $interfaz
	route add -net $RED_R8R9 netmask $MASK_30 gw "192.168.25.3" dev $interfaz
	route add -net $RED_R8R15 netmask $MASK_30 gw "192.168.25.3" dev $interfaz
	route add -net $RED_R9R15 netmask $MASK_30 gw "192.168.25.3" dev $interfaz
	route add -net $RED_RBRC netmask $MASK_30 gw "192.168.25.6" dev $interfaz
	route add -net $RED_RARC netmask $MASK_30 gw "192.168.25.3" dev $interfaz
	route add -net $RED_R7RB netmask $MASK_30 gw "192.168.25.6" dev $interfaz
	route add -net $RED_R13RA netmask $MASK_30 gw "192.168.25.3" dev $interfaz
}

#Configura el WebServer
function configurarWebServer {
	#Configuracion de interfaces
	ifconfig $interfaz $IP_WEBSERVER broadcast $BROADCAST_WEBSERVER netmask $MASCARA_WEBSERVER 

	#Configuracion del enrutamiento estatico
	route add -net $RED_B netmask $MASK_25 gw "192.168.25.3" dev $interfaz
	route add -net $RED_C netmask $MASK_27 gw "192.168.25.3" dev $interfaz
	route add -net $RED_D netmask $MASK_24 gw "192.168.25.3" dev $interfaz
	route add -net $RED_E netmask $MASK_26 gw "192.168.25.6" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "192.168.25.6" dev $interfaz
	route add -net $RED_G netmask $MASK_25 gw "192.168.25.3" dev $interfaz
	route add -net $RED_H netmask $MASK_28 gw "192.168.25.3" dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw "192.168.25.3" dev $interfaz
	route add -net $RED_J netmask $MASK_28 gw "192.168.25.3" dev $interfaz
	route add -net $RED_K netmask $MASK_30 gw "192.168.25.3" dev $interfaz
	route add -net $RED_L netmask $MASK_30 gw "192.168.25.3" dev $interfaz
	route add -net $RED_M netmask $MASK_27 gw "192.168.25.6" dev $interfaz
	route add -net $RED_R1R8 netmask $MASK_30 gw "10.61.6.193" dev $interfaz
	route add -net $RED_R1R9 netmask $MASK_30 gw "10.61.6.195" dev $interfaz
	route add -net $RED_R1R15 netmask $MASK_30 gw "10.61.6.194" dev $interfaz
	route add -net $RED_R8R9 netmask $MASK_30 gw "10.61.6.193" dev $interfaz
	route add -net $RED_R8R15 netmask $MASK_30 gw "10.61.6.194" dev $interfaz
	route add -net $RED_R9R15 netmask $MASK_30 gw "10.61.6.195" dev $interfaz
	route add -net $RED_RBRC netmask $MASK_30 gw "10.61.6.193" dev $interfaz
	route add -net $RED_RARC netmask $MASK_30 gw "10.61.6.196" dev $interfaz
	route add -net $RED_R7RB netmask $MASK_30 gw "10.61.6.195" dev $interfaz
	route add -net $RED_R13RA netmask $MASK_30 gw "10.61.6.196" dev $interfaz

	verificarApache2
	if [ $? -eq 1 ]; then
		echo "Configurando WebServer ..."
		cp -r ./servers/web/index.html /var/www/
		cp -r ./servers/web/apache2.conf /etc/apache2/	

		#Inicia WebServer
		/etc/init.d/apache2 restart
		echo "WebServer configurado correctamente."
	else
		echo "No se pudo configurar el WebServer correctamente."
	fi
}

#Configura el FTPServer
function configurarFTPServer {
	#Configuracion de interfaces
	ifconfig $interfaz $IP_FTPSERVER broadcast $BROADCAST_FTPSERVER netmask $MASCARA_FTPSERVER

	#Configuracion del enrutamiento estatico
	route add -net $RED_A netmask $MASK_24 gw "10.111.25.2" dev $interfaz
	route add -net $RED_C netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_D netmask $MASK_24 gw "10.111.25.2" dev $interfaz
	route add -net $RED_E netmask $MASK_25 gw "10.111.25.2" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "10.111.25.2" dev $interfaz
	route add -net $RED_G netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_H netmask $MASK_26 gw "10.111.25.2" dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw "10.111.25.2" dev $interfaz
	route add -net $RED_J netmask $MASK_29 gw "10.111.25.2" dev $interfaz
	route add -net $RED_K netmask $MASK_28 gw "10.111.25.2" dev $interfaz
	route add -net $RED_L netmask $MASK_24 gw "10.111.25.2" dev $interfaz
	route add -net $RED_M netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_R1R8 netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_R1R9 netmask $MASK_30 gw "10.111.25.25" dev $interfaz
	route add -net $RED_R1R15 netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_R8R9 netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_R8R15 netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_R9R15 netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_RBRC netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_RARC netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_R7RB netmask $MASK_30 gw "10.111.25.2" dev $interfaz
	route add -net $RED_R13RA netmask $MASK_30 gw "10.111.25.2" dev $interfaz

	verificarFTP
	if [ $? -eq 1 ]; then
		echo "Configurando FTPServer ..."
		#cp ./servers/ftp/vsftpd.conf /etc/vsftpd.conf

		#Inicia FTPServer
		/etc/init.d/vsftpd start
		echo "FTPServer configurado correctamente."
	else
		echo "No se pudo configurar el FTPServer correctamente."
	fi
}

#Configura el TelServer
function configurarTelServer {
	#Configuracion de interfaces
	interfazC="tap0"
	interfazD="tap1"
	ifconfig $interfazC $IP_TELSERVER_C broadcast $BROADCAST_TELSERVER_C netmask $MASCARA_TELSERVER_C
	ifconfig $interfazD $IP_TELSERVER_D broadcast $BROADCAST_TELSERVER_D netmask $MASCARA_TELSERVER_D

	#Configuracion del enrutamiento estatico
	route add -net $RED_A netmask $MASK_24 gw "10.61.6.130" dev $interfaz
	route add -net $RED_B netmask $MASK_24 gw "10.61.6.130" dev $interfaz
	route add -net $RED_D netmask $MASK_24 gw "10.61.6.131" dev $interfaz
	route add -net $RED_E netmask $MASK_27 gw "10.61.6.130" dev $interfaz
	route add -net $RED_F netmask $MASK_28 gw "10.61.6.130" dev $interfaz
	route add -net $RED_G netmask $MASK_30 gw "10.61.6.130" dev $interfaz
	route add -net $RED_H netmask $MASK_26 gw "10.61.6.130" dev $interfaz
	route add -net $RED_I netmask $MASK_27 gw "10.61.6.131" dev $interfaz
	route add -net $RED_J netmask $MASK_29 gw "10.61.6.131" dev $interfaz
	route add -net $RED_K netmask $MASK_28 gw "10.61.6.130" dev $interfaz
	route add -net $RED_L netmask $MASK_24 gw "10.61.6.130" dev $interfaz
	route add -net $RED_M netmask $MASK_30 gw "10.61.6.130" dev $interfaz
	route add -net $RED_R1R8 netmask $MASK_30 gw "10.61.6.130" dev $interfaz
	route add -net $RED_R1R9 netmask $MASK_30 gw "10.61.6.130" dev $interfaz
	route add -net $RED_R1R15 netmask $MASK_30 gw "10.61.6.132" dev $interfaz
	route add -net $RED_R8R9 netmask $MASK_30 gw "10.61.6.130" dev $interfaz
	route add -net $RED_R8R15 netmask $MASK_30 gw "10.61.6.132" dev $interfaz
	route add -net $RED_R9R15 netmask $MASK_30 gw "10.61.6.132" dev $interfaz
	route add -net $RED_RBRC netmask $MASK_30 gw "10.61.6.130" dev $interfaz
	route add -net $RED_RARC netmask $MASK_30 gw "10.61.6.130" dev $interfaz
	route add -net $RED_R7RB netmask $MASK_30 gw "10.61.6.130" dev $interfaz
	route add -net $RED_R13RA netmask $MASK_30 gw "10.61.6.130" dev $interfaz

	verificarTelnet
	if [ $? -eq 1 ]; then
		echo "Configurando TelServer ..."
		# Arranca
	
		#CONFIGURACION SERVICIO TELNET
		#cp ./servers/telnet/inetd.conf /etc/inetd.conf

		#Inicia TelServer
		/etc/init.d/openbsd-inetd restart
		echo "TelServer configurado correctamente."
	else
		echo "No se pudo configurar el TelServer correctamente."
	fi
}

#Funcion que deshabilita el forwarding
function deshabilitarForwarding {
	echo "Deshabilitando el forwarding ..."
	sysctl -w net.ipv4.ip_forward=0  > /dev/null
	RESPU=$(cat /proc/sys/net/ipv4/ip_forward)
	if [ "$RESPU" -eq 0 ]; then
		echo "Forwarding deshabilitado."
	else
		echo "No se pudo deshabilitar el forwarding."
	fi
}


############### MAIN ################

if [ $# -ne 2 ]; then
	echo "Uso: init.sh <host> <interfaz>"
	exit 0
fi

interfaz=$2

if [ $1 = "hostA" ]; then
	echo "Host: A"
	echo "Configurando interfaces y tablas de ruteo ..."
	configurarHostA
	echo "Tablas de ruteo e interfaces configuradas correctamente."
	deshabilitarForwarding
	exit 0
fi

if [ $1 = "hostB" ]; then
	echo "Host: B"
	echo "Configurando interfaces y tablas de ruteo ..."
	configurarHostB
	echo "Tablas de ruteo e interfaces configuradas correctamente."
	deshabilitarForwarding
	exit 0
fi

if [ $1 = "hostC" ]; then
	echo "Host: C"
	echo "Configurando interfaces y tablas de ruteo ..."
	configurarHostC
   	echo "Tablas de ruteo e interfaces configuradas correctamente."
	deshabilitarForwarding
	exit 0
fi

if [ $1 = "webserver" ]; then
	echo "WebServer"
	echo "Configurando interfaces y tablas de ruteo ..."
	configurarWebServer
   	echo "Tablas de ruteo e interfaces configuradas correctamente."
	deshabilitarForwarding
	exit 0
fi

if [ $1 = "ftpserver" ] ; then
	echo "FTPServer"
	echo "Configurando interfaces y tablas de ruteo ..."
	configurarFTPServer
   	echo "Tablas de ruteo e interfaces configuradas correctamente."
	deshabilitarForwarding
	exit 0
fi

if [ $1 = "telserver" ]; then
	echo "TelServer"
	echo "Configurando interfaces y tablas de ruteo ..."
	configurarTelServer
   	echo "Tablas de ruteo e interfaces configuradas correctamente."
	deshabilitarForwarding
	exit 0
fi


echo "No se pudo encontrar el host $1."
exit 1
