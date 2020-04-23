#!/bin/bash
#
# ------------------------------------------------------------------------------
#
# Elementary OS After Install Script
#
# AUTOR:	Mariel de Jesus™ <marieldejesus12@gmail.com>
# MANTENEDORES:	
#
# VERSÃO: 1
#
# ------------------------------------------------------------------------------
#
# DESCRIÇÃO:
#
# Este script faz várias instalações e configurações quem não vem por padrão no
#    Elementary OS.
#
# ------------------------------------------------------------------------------
#
# LICENÇA:
# Este programa é Software Livre, você pode redistribui-lo e/ou modificá-lo sob
# os termos da Licença Pública Geral GNU publicada pela Free Software Foundation
# qualquer versão 2 da Licença, ou (de acordo com sua opinião) qualquer versão
# mais recente. 
#
# Este programa é distribuído na esperança de que seja útil, mas SEM NENHUMA
# GARANTIA; Sem mesmo implicar garantias de COMERCIABILIDADE ou ADAPTAÇÃO A UM
# PROPÓSITO PARTICULAR. Veja a Licença Pública Geral GNU (GPL) para mais
# detalhes (http://www.gnu.org/copyleft/gpl.html).
#
# ------------------------------------------------------------------------------
#
# NOVIDADES:
#
#
# ------------------------------------------------------------------------------
#
# CHANGELOG:
#
# Versão 1 - Lançamento do programa
#
# ------------------------------------------------------------------------------
#
# DEPENDÊNCIAS:
#
# zenity, software-properties-common, dconf-tools
#
# ------------------------------------------------------------------------------

#Chama o script como root
if [[ "$(id -u)" != "0" ]]; then
    pantheon-terminal -e "sudo $0"
    exit
else
    #Gera tela de escolha das configurações a serem feitas
    ESCOLHA=$(zenity  --title="Elementary OS After Install" --width=600 --height=500 --list \
        --text "Bem vindo ao Elementary OS After Install, selecione as configurações que deseja realizar:" \
        --checklist \
        --multiple \
        --column "Pick" \
        --column "escolha" \
        --column "Opção" \
        --hide-header \
        --separator=" " \
        --Print-column=2 \
        --hide-column=2 \
        FALSE bleachbit "Instalar o Bleachbit" \
        FALSE chromium "Instalar o Chromium Browser" \
        FALSE conky "Instalar o Conky e o Conky Manager" \
        FALSE dconf "Instalar o Dconf-tools" \
        FALSE tweaks "Instalar o Elementary Tweaks" \
        FALSE geany "Instalar o Geany Editor" \
        FALSE chrome "Instalar o Google Chrome" \
        FALSE javajre "Instalar o Java JRE" \
        FALSE javajdk "Instalar o Java JDK" \
        FALSE firefox "Instalar o Mozilla Firefox" \
        FALSE libreoffice "Instalar o Libreoffice" \
        FALSE nemo "Instalar o Nemo Gerenciador de Arquivos" \
        FALSE plank-themer "Instalar o Plank-Themer" \
        FALSE showdesktop "Instalar o comando ShowDesktop" \
        FALSE softprop "Instalar o Software-Proprieties-GTK" \
        FALSE telegram "Instalar o Telegram for Linux Desktop" \
        FALSE transmission "Instalar o Transmission" \
        FALSE vlc "Instalar o VLC Media Player" \
        FALSE wine "Instalar o Wine 1.8" \
        FALSE sair "Sair do instalador");

    #Sair do instalador
    if [[ $(echo $ESCOLHA | grep sair) ]] || [[ "$ESCOLHA" = "" ]]; then
        exit 1
    fi

    #Gera tela de escolha do usuário do sistema
    if [[ $(echo $ESCOLHA | grep "telegram") ]] || [[ $(echo $ESCOLHA | grep "showdesktop") ]] || [[ $(echo $ESCOLHA | grep "plank-themer") ]]; then
        while : ; do
            ls /home/ > /tmp/scripts.txt
            USUARIOS="$(cat /tmp/scripts.txt)"
            rm /tmp/scripts.txt
            ESCOLHER=""
            NUM=1
            for i in $USUARIOS; do
                ESCOLHER="$ESCOLHER $NUM $i"
                NUM=$NUM+1
            done
            USUARIO=$(zenity  --title="Elementary OS After Install" --width=200 --height=250 --list \
                --text "Escolha o seu usuário de sistema no Elementary OS:" \
                --radiolist \
                --column "Pick" \
                --column "Usuário" \
                --hide-header \
                --Print-column=2 \
                $ESCOLHER)
            if [[ "$USUARIO" != "" ]]; then #se escolheu um usuário, sair do laço
                break
            elif [[ "$?" = "1" ]]; then #se apertar cancelar sai do script
                exit
            fi
        done
    fi

    #Verifica quantas colunas tem o terminal
    COLUMNS=$(tput cols)
    
    #Cria linha de #'s a serem impressas na tela
    LINHA=""
    NUM=1
    while [[ $NUM -lt $COLUMNS ]]; do
        LINHA=$LINHA"#"
        NUM=$NUM+1
    done

    #Função que imprime na tela o passo que está sendo realizado
    Print ()
    {
        #Limpa a tela
        clear
        #Verifica quantas colunas tem o terminal
        COLUMNS=$(tput cols)
        #Limpa variáveis
        LINHAMEIO=""
        LINHA=""
        #Cria linha de #'s a serem impressas na tela
        for (( i = 0; i < $COLUMNS; i++ )); do
            LINHA=$LINHA"#"
        done
        #Cria a linha que contém o texto que será impressa na tela
        RESTO=$(($COLUMNS-${#TEXTO}))
        if test $(($RESTO%2)) -eq 0;then
            RESTODIV=$(($RESTO/2))
            for (( i = 1; i < $RESTODIV; i++ )); do
                LINHAMEIO=$LINHAMEIO"#"
            done
            LINHAMEIO=$LINHAMEIO" "$TEXTO" "
            for (( i = 1; i < $RESTODIV; i++ )); do
                LINHAMEIO=$LINHAMEIO"#"
            done
        elif test $(($RESTO%2)) -ne 0;then
            RESTODIV=$(($RESTO/2))
            for (( i = 1; i < $RESTODIV; i++ )); do
                LINHAMEIO=$LINHAMEIO"#"
            done
            LINHAMEIO=$LINHAMEIO" "$TEXTO" "
            for (( i = 0; i < $RESTODIV; i++ )); do
                LINHAMEIO=$LINHAMEIO"#"
            done
        fi
        echo $LINHA
        echo $LINHAMEIO
        echo $LINHA
        echo ""
        echo ""
    } 

    #Instala as primeiras dependências dos programas
    if ! [[ $(which apt-add-repository) ]]; then
        TEXTO="Instalando dependências"
        Print
        sleep 2
        apt-get update
        apt-get -y install software-properties-common
    fi

    #Define e limpa variável para quardar a lista dos 
    # programas a serem instalados por apt-get
    PROGRAMAS=""

    #Bleachbit
    if [[ $(echo $ESCOLHA | grep "bleachbit") ]]; then
        PROGRAMAS=$PROGRAMAS" bleachbit"
    fi

    #Chromium Browser
    if [[ $(echo $ESCOLHA | grep "chromium") ]]; then
        PROGRAMAS=$PROGRAMAS" chromium-browser chromium-browser-l10n"
    fi

    #Conky & Conky-Manager
    if [[ $(echo $ESCOLHA | grep "conky") ]]; then
        TEXTO="Adiconando repositório do Conky Manager"
        Print
        sleep 2
        apt-add-repository -y ppa:teejee2008/ppa  
        PROGRAMAS=$PROGRAMAS" conky-all conky-manager"
    fi
    
    #Dconf-tools
    if [[ $(echo $ESCOLHA | grep "dconf") ]]; then
        PROGRAMAS=$PROGRAMAS" dconf-tools"
    fi

    #Elementary-Tweaks
    if [[ $(echo $ESCOLHA | grep "tweaks") ]]; then
        TEXTO="Adiconando repositório do Elementary Tweaks"
        Print
        sleep 2
        add-apt-repository -y ppa:philip.scott/elementary-tweaks  
        PROGRAMAS=$PROGRAMAS" elementary-tweaks"
    fi
    
    #Geany Editor
    if [[ $(echo $ESCOLHA | grep "geany") ]]; then
        PROGRAMAS=$PROGRAMAS" geany geany-plugins"
    fi
    
    #Google Chrome
    if [[ $(echo $ESCOLHA | grep "chrome") ]]; then
        TEXTO="Adiconando repositório do Google Chrome"
        Print
        sleep 2
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
        echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list  
        PROGRAMAS=$PROGRAMAS" google-chrome-stable"
    fi

    #Java JRE
    if [[ $(echo $ESCOLHA | grep "javajre") ]]; then
        PROGRAMAS=$PROGRAMAS" default-java-plugin default-jre"
    fi

    #Java JDK
    if [[ $(echo $ESCOLHA | grep "javajdk") ]]; then
        PROGRAMAS=$PROGRAMAS" default-jdk"
    fi

    #Mozilla Firefox
    if [[ $(echo $ESCOLHA | grep "firefox") ]]; then
        PROGRAMAS=$PROGRAMAS" firefox firefox-locale-pt"
    fi

    #Libreoffice
    if [[ $(echo $ESCOLHA | grep "libreoffice") ]]; then
        TEXTO="Adiconando repositório do Libreoffice"
        Print
        sleep 2
        add-apt-repository -y ppa:libreoffice/ppa
        PROGRAMAS=$PROGRAMAS" libreoffice libreoffice-help-pt-br"
    fi

    #Nemo
    if [[ $(echo $ESCOLHA | grep "nemo") ]]; then
        PROGRAMAS=$PROGRAMAS" nemo"
    fi

    #Plank-Themer
    if [[ $(echo $ESCOLHA | grep "plank-themer") ]]; then
        TEXTO="Adiconando repositório do Plank-Themer"
        Print
        sleep 2
        add-apt-repository -y ppa:noobslab/apps
        PROGRAMAS=$PROGRAMAS" plank-themer"
    fi

    #Software-Proprieties-GTK
    if [[ $(echo $ESCOLHA | grep "plank-themer") ]]; then
        PROGRAMAS=$PROGRAMAS" software-properties-gtk"
    fi

    #Transmission
    if [[ $(echo $ESCOLHA | grep "transmission") ]]; then
        PROGRAMAS=$PROGRAMAS" transmission-gtk"
    fi

    #VLC
    if [[ $(echo $ESCOLHA | grep "vlc") ]]; then
        PROGRAMAS=$PROGRAMAS" vlc"
    fi

    #Wine 1.8
    if [[ $(echo $ESCOLHA | grep "wine") ]]; then
        TEXTO="Adiconando repositório do Wine 1.8"
        Print
        sleep 2
        add-apt-repository -y ppa:ubuntu-wine/ppa
        PROGRAMAS=$PROGRAMAS" wine1.8 wine"
    fi

    #Instala todos os programas por apt-get
    TEXTO="Instalando os programas selecionados"
    Print
    sleep 2
    apt-get update
    apt-get -y install $PROGRAMAS

    #Instala script ShowDesktop
    if [[ $(echo $ESCOLHA | grep "showdesktop") ]]; then
        TEXTO="Instalando o script ShowDesktop"
        Print
        sleep 2
        echo "#!/bin/sh" > /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# ------------------------------------------------------------------------------" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# ShowDesktop - Minimize todas as janelas da área de trabalho" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# AUTOR:    Mariel de Jesus™ <marieldejesus12@gmail.com>" >> /usr/local/bin/showdesktop
        echo "# MANTENEDORES: " >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# VERSÃO: 1" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# ------------------------------------------------------------------------------" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# DESCRIÇÃO:" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# Este script mostra a área de trabalho no Elementary OS suprindo a falta" >> /usr/local/bin/showdesktop
        echo "# dessa configuração por padrão." >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# ------------------------------------------------------------------------------" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# LICENÇA:" >> /usr/local/bin/showdesktop
        echo "# Este programa é Software Livre, você pode redistribui-lo e/ou modificá-lo sob" >> /usr/local/bin/showdesktop
        echo "# os termos da Licença Pública Geral GNU publicada pela Free Software Foundation" >> /usr/local/bin/showdesktop
        echo "# qualquer versão 2 da Licença, ou (de acordo com sua opinião) qualquer versão" >> /usr/local/bin/showdesktop
        echo "# mais recente." >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# Este programa é distribuído na esperança de que seja útil, mas SEM NENHUMA" >> /usr/local/bin/showdesktop
        echo "# GARANTIA; Sem mesmo implicar garantias de COMERCIABILIDADE ou ADAPTAÇÃO A UM" >> /usr/local/bin/showdesktop
        echo "# PROPÓSITO PARTICULAR. Veja a Licença Pública Geral GNU (GPL) para mais" >> /usr/local/bin/showdesktop
        echo "# detalhes (http://www.gnu.org/copyleft/gpl.html)." >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# ------------------------------------------------------------------------------" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# NOVIDADES:" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# ------------------------------------------------------------------------------" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# CHANGELOG:" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# Versão 1 - Lançamento do script" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# ------------------------------------------------------------------------------" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# DEPENDÊNCIAS:" >> /usr/local/bin/showdesktop
        echo "#" >> /usr/local/bin/showdesktop
        echo "# wmctrl, grep, cut" >> /usr/local/bin/showdesktop >> /usr/local/bin/showdesktop
        echo "# ------------------------------------------------------------------------------" >> /usr/local/bin/showdesktop
        echo 'if [ $(wmctrl -m | grep "showing the desktop" | cut -d" " -f7) = ON ]; then' >> /usr/local/bin/showdesktop
        echo "    wmctrl -k off" >> /usr/local/bin/showdesktop
        echo "else" >> /usr/local/bin/showdesktop
        echo "    wmctrl -k on" >> /usr/local/bin/showdesktop
        echo "fi" >> /usr/local/bin/showdesktop
        chmod +x /usr/local/bin/showdesktop

        echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom100/ binding '<Super>d'" > /tmp/script
        echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom100/ command 'showdesktop'" >> /tmp/script
        echo "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom100/ name 'ShowDesktop'" >> /tmp/script
        echo 'GCONFSE="$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | cut -d"[" -f 2 | cut -d"]" -f 1)"' >> /tmp/script
        echo 'if [[ $GCONFSE != "" ]]; then' >> /tmp/script
        echo '    GCONFSE="$GCONFSE, "' >> /tmp/script
        echo "fi" >> /tmp/script
        echo 'GCONFSE="[$GCONFSE'"'"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom100/"'"']"' >> /tmp/script
        echo 'gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$GCONFSE"' >> /tmp/script
        echo "exit" >> /tmp/script
        chmod +x /tmp/script
        su $USUARIO -c "pantheon-terminal -e /tmp/script"
        rm /tmp/script
    fi

    #Telegram
    if [[ $(echo $ESCOLHA | grep "telegram") ]]; then
        TEXTO="Instalando o Telegram"
        Print
        sleep 2
        if [[ $(uname -m) = "x86_64" ]]; then 
            telegramsite="https://telegram.org/dl/desktop/linux"
        else
            telegramsite="https://telegram.org/dl/desktop/linux32"
        fi
        wget -t0 -c -O telegram.tar.xz  $telegramsite
        tar -xf telegram.tar.xz
        rm telegram.tar.xz
        mv Telegram /opt
        echo "[Desktop Entry]" > /usr/share/applications/telegramdesktop.desktop
        echo "Encoding=UTF-8" >> /usr/share/applications/telegramdesktop.desktop
        echo "Version=1.0" >> /usr/share/applications/telegramdesktop.desktop
        echo "Name=Telegram Desktop" >> /usr/share/applications/telegramdesktop.desktop
        echo "Comment=Official desktop version of Telegram messaging app" >> /usr/share/applications/telegramdesktop.desktop
        echo "Exec=env QT_IM_MODULE=xim /opt/Telegram/Telegram -- %u" >> /usr/share/applications/telegramdesktop.desktop
        echo "Icon=telegram" >> /usr/share/applications/telegramdesktop.desktop
        echo "Terminal=false" >> /usr/share/applications/telegramdesktop.desktop
        echo "StartupWMClass=Telegram" >> /usr/share/applications/telegramdesktop.desktop
        echo "Type=Application" >> /usr/share/applications/telegramdesktop.desktop
        echo "Categories=Network;" >> /usr/share/applications/telegramdesktop.desktop
        echo "MimeType=x-scheme-handler/tg;" >> /usr/share/applications/telegramdesktop.desktop
        echo "X-Desktop-File-Install-Version=0.22" >> /usr/share/applications/telegramdesktop.desktop
        chmod -R 777 /opt/Telegram
        ln -sf /opt/Telegram/Telegram /usr/local/bin/
        zenity --question --text="Iniciar o Telegram junto com o sistema?"
        if [[ "$?" = "0" ]]; then
          cp /usr/share/applications/telegramdesktop.desktop /home/$USUARIO/.config/autostart/telegramdesktop.desktop
        fi
    fi

    #Configurando o Nemo
    if [[ $(echo $ESCOLHA | grep "nemo") ]]; then
        TEXTO="Configurando o Nemo"
        Print
        sleep 2
        echo "gsettings set org.nemo.desktop home-icon-visible false" > /tmp/script
        echo "gsettings set org.nemo.desktop trash-icon-visible false" >> /tmp/script
        echo "gsettings set org.nemo.desktop computer-icon-visible false" >> /tmp/script
        echo "gsettings set org.nemo.desktop volumes-visible false" >> /tmp/script
        chmod +x /tmp/script
        su $USUARIO -c "pantheon-terminal -e /tmp/script"
        rm /tmp/script
        cp /usr/share/applications/nautilus.desktop /usr/share/applications/nautilus.desktop.backup
        cat /usr/share/applications/nautilus.desktop.backup | sed "s,nautilus %U,Exec=nemo %U,g" > /usr/share/applications/nautilus.desktop
    fi
    
    #Plank-Themer
    if [[ $(echo $ESCOLHA | grep "plank-themer") ]]; then
        TEXTO="Configurando o Plank-Themer"
        Print
        sleep 2
        echo "cd /tmp/ && ./Replace.sh;cd" > /tmp/script
        chmod +x /tmp/script
        su $USUARIO -c "pantheon-terminal -e /tmp/script"
        rm /tmp/script
    fi

    TEXTO="Script de configuração finalizado"
    Print
    echo "Digite enter para sair"
    read p
fi
