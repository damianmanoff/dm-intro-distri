#!/bin/bash

paquete=$1

echo "Verificando instalacion de $paquete"
INSTALADO=`dpkg -s $paquete | grep -i "Status: install ok installed" | wc -l`
if [ "$INSTALADO" -ne "1" ]; then
	echo " * El paquete $paquete no se encuentra instalado."
	echo "Se pasara a instalar   $paquete ..."
	apt-get install -y --force-yes $paquete
else
	echo "$paquete esta  correctamente instalado"
fi