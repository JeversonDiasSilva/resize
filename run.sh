#!/bin/bash

# Códigos de cor ANSI
GREEN='\033[1;32m' # Negrito + Verde
RESET='\033[0m'

TARGET="/etc/init.d/S02resize"
TEMP="/tmp/resize_tmp.sh"

# Remove o antigo, se existir
if [ -f "$TARGET" ]; then
    rm "$TARGET"
fi

# Baixa o novo script
curl -s -o "$TEMP" https://raw.githubusercontent.com/JeversonDiasSilva/resize/main/resize
clear

# Animação simples de carregamento
for i in {1..5}; do
    echo -n "."
    sleep 1
done
echo ""

# Se o download foi bem-sucedido
if [ -f "$TEMP" ]; then
    mv "$TEMP" "$TARGET"
    chmod +x "$TARGET"
    echo -e "${GREEN}ARQUIVO ATUALIZADO COM SUCESSO.${RESET}"

    # Salva a sobreposição após as mudanças
    batocera-save-overlay

else
    echo -e "${GREEN}FALHA AO BAIXAR O ARQUIVO. VERIFIQUE SUA CONEXÃO.${RESET}"
fi

# Garante que o sistema esteja montado como leitura e escrita
mount -o remount,rw /media/BATOCERA

# Ativa o autoresize
sed -i 's/^#autoresize=true/autoresize=true/' /media/BATOCERA/batocera-boot.conf

# Mensagem final
echo -e "${GREEN}BY @JCGAMESCLASSICOS${RESET}"
grep autoresize /media/BATOCERA/batocera-boot.conf

echo "Reiniciando o sistema em 10 segundos..."
sleep 10
reboot
