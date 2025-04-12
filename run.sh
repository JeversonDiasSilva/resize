#!/bin/bash

# Códigos de cor ANSI
GREEN='\033[1;32m' # Negrito + Verde
RESET='\033[0m'

TARGET="/etc/init.d/S02resize"
TEMP="/tmp/resize_tmp.sh"

# Remove o antigo, se existir
if [ -f "$TARGET" ]; then
    rm "$TARGET"
    #echo -e "${GREEN}ARQUIVO ANTIGO REMOVIDO.${RESET}"
fi

# Mensagem de atualização com pontinhos animados
echo -ne "${GREEN}ATUALIZANDO O SISTEMA DE RESIZE, AGUARDE${RESET}"

curl -s -o "$TEMP" https://raw.githubusercontent.com/JeversonDiasSilva/resize/main/resize > /dev/null 2>&1 &
clear

for i in {1..5}; do
    echo -n "."
    sleep 1
done
echo ""

wait

# Se baixou com sucesso, move pro destino final e dá permissão
if [ -f "$TEMP" ]; then
    mv "$TEMP" "$TARGET"
    chmod +x "$TARGET"
    echo -e "${GREEN}ARQUIVO ATUALIZADO COM SUCESSO.${RESET}"
else
    echo -e "${GREEN}FALHA AO BAIXAR O ARQUIVO. VERIFIQUE SUA CONEXÃO.${RESET}"
    echo "SALVANDO A MUDANÇA NO ISTEMA"
    batocera-save-overlay > /dev/null 2>&1 &
fi

mount -o remount,rw /media/BATOCERA
sed -i 's/^#autoresize=true/autoresize=true/' /media/BATOCERA/batocera-boot.conf
grep autoresize /media/BATOCERA/batocera-boot.conf
echo -e "${GREEN}BY @JCGAMESCLASSICOS${RESET}"
echo "reiniciando o  o sistema em 10 segundos..."
sleep 10
reboot

