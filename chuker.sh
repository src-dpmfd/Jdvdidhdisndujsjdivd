#!/bin/bash

# Cores
vermelho="\e[31m"
verde="\e[32m"
amarelo="\e[33m"
azul="\e[34m"
roxo="\e[38;2;128;0;128m"
reset="\e[0m"

# Caminho do script principal
SCRIPT_PATH="/root/chuker/checkuser.py"
CACHE_FILE="/root/chuker/port.txt"
REPO_DIR="/root/chuker"

# Função para instalar
install_checkuser() {
    echo -e "${amarelo}Iniciando a instalação...${reset}"
    rm -rf ${REPO_DIR}
    rm -f /usr/local/bin/chuker
    pkill -9 -f "${SCRIPT_PATH}"

    # Adicionado o comando para criar o diretório antes de baixar o arquivo
    mkdir -p ${REPO_DIR}

    apt update && apt upgrade -y && apt install python3 git wget curl -y
    
    # Corrigido o comando wget
    wget -O ${SCRIPT_PATH} "https://raw.githubusercontent.com/src-dpmfd/Jdvdidhdisndujsjdivd/main/checkuser.py"

    if [ -f "${SCRIPT_PATH}" ]; then
        echo -e "${verde}Instalação concluída com sucesso!${reset}"
    else
        echo -e "${vermelho}Falha ao baixar o script. Verifique sua conexão e o link do arquivo.${reset}"
    fi
    sleep 3
}

# Função para desinstalar
uninstall_checkuser() {
    echo -e "${amarelo}Iniciando a desinstalação do CheckUser...${reset}"
    pkill -9 -f "${SCRIPT_PATH}"
    rm -rf ${REPO_DIR}
    echo -e "${verde}Desinstalação concluída com sucesso!${reset}"
    sleep 3
}

# Função para verificar o processo
verificar_processo() {
    if pgrep -f "${SCRIPT_PATH}" > /dev/null; then
        return 0 # Processo está rodando
    else
        return 1 # Processo não está rodando
    fi
}

# Função para obter IP público
get_public_ip() {
    curl -s https://ipinfo.io/ip
}

# Menu de gerenciamento
management_menu() {
    while true; do
        clear
        local porta=$(cat ${CACHE_FILE} 2>/dev/null)
        if verificar_processo; then
            status="${verde}ativo${reset} - porta em uso: ${porta}"
        else
            status="${vermelho}parado${reset} - porta que será usada: ${porta}"
        fi

        echo -e "${azul}CheckUser  By: @alfalemos${reset}"
        echo "----------------------------------------"
        echo -e "Status: ${status}"
        echo ""
        echo "Selecione uma opção:"
        echo " 1 - Iniciar checkuser"
        echo " 2 - Parar checkuser"
        echo " 3 - Verificar links"
        echo " 4 - Sobre"
        echo " 0 - Voltar ao menu principal"
        echo "----------------------------------------"

        read -p "Digite a opção: " option

        case $option in
            1)
                echo "Observação: Para funcionar com security, use a porta 5454!"
                read -p "Digite a porta que deseja usar: " porta_input
                echo ${porta_input} > ${CACHE_FILE}
                clear
                echo "Porta escolhida: ${porta_input}"
                nohup python3 ${SCRIPT_PATH} --port ${porta_input} > /dev/null 2>&1 &
                echo -e "${verde}Checkuser iniciado em segundo plano.${reset}"
                read -p $'\nPressione a tecla enter para voltar ao menu\n\n'
                ;;
            2)
                if verificar_processo; then
                    pkill -9 -f "${SCRIPT_PATH}"
                    rm -f ${CACHE_FILE}
                    echo -e "${verde}Checkuser parado com sucesso.${reset}"
                else
                    echo -e "${amarelo}O Checkuser não está ativo.${reset}"
                fi
                read -p "Pressione a tecla enter para voltar ao menu"
                ;;
            3)
                clear
                if verificar_processo; then
                    local ip=$(get_public_ip)
                    local porta=$(cat ${CACHE_FILE})
                    echo "Abaixo os apps, e os links para cada um: "
                    echo ""
                    echo -e "${verde} DtunnelMod  - http://${ip}:${porta}/dtmod${reset}"
                    echo -e "${verde} GltunnelMod - http://${ip}:${porta}/gl${reset}"
                    echo -e "${verde} AnyVpnMod   - http://${ip}:${porta}/anymod${reset}"
                    echo -e "${verde} Conecta4g   - http://${ip}:${porta}/checkUser${reset}"
                    echo -e "${verde} AtxTunnel   - http://${ip}:${porta}/atx${reset}"
                    echo ""
                    echo "Para usar com security (use apenas com conexões que não usam cloudflare):"
                    echo ""
                    echo -e "${roxo} DtunnelMod  - http://proxy.ulekservices.shop/api.php?url=http://${ip}:${porta}/dtmod${reset}"
                    echo -e "${roxo} GltunnelMod - http://proxy.ulekservices.shop/api.php?url=http://${ip}:${porta}/gl${reset}"
                    echo -e "${roxo} AnyVpnMod   - http://proxy.ulekservices.shop/api.php?url=http://${ip}:${porta}/anymod${reset}"
                    echo -e "${roxo} Conecta4g   - http://proxy.ulekservices.shop/api.php?url=http://${ip}:${porta}/checkUser${reset}"
                    echo -e "${roxo} AtxTunnel   - http://proxy.ulekservices.shop/api.php?url=http://${ip}:${porta}/atx${reset}"
                    echo ""
                else
                    echo -e "${vermelho}\nInicie o serviço primeiro\n${reset}"
                fi
                read -p "Pressione a tecla enter para voltar ao menu"
                ;;
            4)
                clear
                echo -e "${azul}Sobre o CheckUser${reset}"
                echo "----------------------------------------"
                echo "Olá, esse é um multi-checkuser"
                echo ""
                echo " - DtunnelMod"
                echo " - GlTunnelMod"
                echo " - AnyVpnMod"
                echo " - Conecta4g"
                echo ""
                read -p "Pressione a tecla enter para voltar ao menu"
                ;;
            0)
                break
                ;;
            *)
                clear
                echo -e "${vermelho}Opção inválida, tente novamente!${reset}"
                read -p "Pressione a tecla enter para voltar ao menu"
                ;;
        esac
    done
}


# Menu principal
while true; do
    clear
    echo -e "${azul}CheckUser  By: @alfalemos${reset}"
    echo "----------------------------------------"
    echo " 1 - Instalar CheckUser"
    echo " 2 - Desinstalar CheckUser"
    echo " 3 - Acessar Menu de Gerenciamento"
    echo " 0 - Sair"
    echo "----------------------------------------"
    read -p "Digite a opção: " main_option

    case $main_option in
        1)
            install_checkuser
            ;;
        2)
            uninstall_checkuser
            ;;
        3)
            if [ -f "${SCRIPT_PATH}" ]; then
                management_menu
            else
                echo -e "${vermelho}CheckUser não está instalado. Por favor, instale primeiro.${reset}"
                sleep 3
            fi
            ;;
        0)
            clear
            conexao
            ;;
        *)
            echo -e "${vermelho}Opção inválida!${reset}"
            sleep 1
            ;;
    esac
done