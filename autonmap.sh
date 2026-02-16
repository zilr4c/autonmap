#!/bin/bash

autonmap () {

RED='\033[1;31m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'

if [ $# -ne 1 ]; then
	echo -e "${RED}[-] Debes proporcionar una dirección IP como argumento."
	echo -e "${RED}[!] Ejemplo: autonmap <IP>"
	return 1
fi 

ip="$1"

# Escaneo con min-rate
echo -e "${GREEN}\n[+] Escaneo rápido con min-rate en IP: ${PURPLE}$ip"
sudo nmap -sS --min-rate 5000 -p- --open "$ip" -Pn -n -oN scan_minrate_$ip > /dev/null
puertos_minrate=$(grep -E '^[0-9]+/tcp' scan_minrate_$ip | cut -d '/' -f1 | tr '\n' ',' | sed 's/,$//')
count_minrate=$(echo "$puertos_minrate" | tr ',' '\n' | grep -c '[0-9]')
echo -e "${GREEN}[+] Puertos encontrados (min-rate): ${PURPLE}$puertos_minrate (${count_minrate})"

# Reconocimiento de servicios sobre puertos detectados (min-rate)
echo -e "${GREEN}\n[+] Reconocimiento SVC en puertos detectados (min-rate)..."
sudo nmap -p"$puertos_minrate" -sVC "$ip" -Pn -n -oN targeted_minrate_$ip > /dev/null
echo -e "${GREEN}[+] Resultado guardado en ${PURPLE}targeted_minrate_$ip"

# Escaneo sin min-rate
echo -e "${GREEN}\n[+] Escaneo completo sin min-rate..."
sudo nmap -sS -p- --open "$ip" -Pn -n -oN scan_normal_$ip > /dev/null
puertos_normal=$(grep -E '^[0-9]+/tcp' scan_normal_$ip | cut -d '/' -f1 | tr '\n' ',' | sed 's/,$//')
count_normal=$(echo "$puertos_normal" | tr ',' '\n' | grep -c '[0-9]')
echo -e "${GREEN}[+] Puertos encontrados (sin min-rate): ${PURPLE}$puertos_normal (${count_normal})"

  

# Detección de puertos adicionales no vistos antes
nuevos=$(comm -13 <(echo "$puertos_minrate" | tr ',' '\n' | sort) <(echo "$puertos_normal" | tr ',' '\n' | sort) | tr '\n' ',' | sed 's/,$//')

if [ -n "$nuevos" ]; then
	echo -e "${GREEN}[+] Se detectaron puertos nuevos: ${PURPLE}$nuevos"
	echo -e "${GREEN}[+] Realizando reconocimiento SVC sobre puertos adicionales..."
	sudo nmap -p"$nuevos" -sVC "$ip" -Pn -n -oN targeted_new_$ip > /dev/null
	echo -e "${GREEN}[+] Resultado guardado en ${PURPLE}targeted_new_$ip"
else
	echo -e "${GREEN}[+] No se detectaron puertos adicionales no cubiertos."
fi

# Limpieza
rm -f scan_minrate_$ip scan_normal_$ip
}

autonmap "$@"