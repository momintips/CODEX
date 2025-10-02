#!/bin/bash

clear

# dx color
r='\033[1;91m'
p='\033[1;95m'
y='\033[1;93m'
g='\033[1;92m'
n='\033[1;0m'
b='\033[1;94m'
c='\033[1;96m'

# dx Symbol
X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;92m]\033[92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'

# dx icon
OS="\uf6a6"
HOST="\uf6c3"
KER="\uf83c"
UPT="\uf49b"
PKGS="\uf8d6"
SH="\ue7a2"
TERMINAL="\uf489"
CHIP="\uf2db"
CPUI="\ue266"
HOMES="\uf015"

MODEL=$(uname -m)
VENDOR=$(hostname)
devicename="${VENDOR} ${MODEL}"
THRESHOLD=100
random_number=$(( RANDOM % 2 ))

exit_script() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"              
    echo -e "\n ${g}[${n}${KER}${g}] ${c}Exiting ${g}Momin Banner \033[1;36m"
    echo
    cd "$HOME"
    rm -rf CODEX
    exit 0
}

trap exit_script SIGINT SIGTSTP

check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size
    local used_size
    local disk_usage

    total_size=$(df -h "$HOME" | awk 'NR==2 {print $2}')
    used_size=$(df -h "$HOME" | awk 'NR==2 {print $3}')
    disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//g')

    if [ "$disk_usage" -ge "$threshold" ]; then
        echo -e "${g}[${n}\uf0a0${g}] ${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    else
        echo -e "${y}Disk usage: ${g}${disk_usage}% ${c}| ${g}${used_size}"
    fi
}

data=$(check_disk_usage)

sp() {
    IFS=''
    sentence=$1
    second=${2:-0.05}
    for (( i=0; i<${#sentence}; i++ )); do
        char=${sentence:$i:1}
        echo -n "$char"
        sleep $second
    done
    echo
}

mkdir -p .Codex-simu

tr() {
    # Check if curl is installed
    if command -v curl &>/dev/null; then
        echo ""
    else
        if [ -f "/etc/os-release" ]; then
            apt install curl -y &>/dev/null 2>&1
        else
            pkg install curl -y &>/dev/null 2>&1
        fi
    fi
    
    if command -v tput &>/dev/null; then
        echo ""
    else
        if [ -f "/etc/os-release" ]; then
            apt install ncurses-bin -y >/dev/null 2>&1
        else
            pkg install ncurses-utils -y >/dev/null 2>&1
        fi
    fi
}

help() {
    clear
    echo
    echo -e " ${p}■ \e[4m${g}Use Button\e[4m ${p}▪︎${n}"
    echo
    echo -e " ${y}Use Termux Extra key Button${n}"
    echo
    echo -e " UP          ↑"
    echo -e " DOWN        ↓"
    echo
    echo -e " ${g}Select option Click Enter button"
    echo
    echo -e " ${b}■ \e[4m${c}If you understand, click the Enter Button\e[4m ${b}▪︎${n}"
    read -p ""
}

help

spin_linux() {
    echo
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    show_spinner() {
        local pid=$!
        while ps -p $pid > /dev/null; do
            for i in "${spinner[@]}"; do
                tput civis
                echo -ne "\033[1;96m\r [+] Installing $1 please wait \e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
                sleep $delay
                printf "\b\b\b\b\b\b\b\b"
            done
        done
        printf "   \b\b\b\b\b"
        tput cnorm
        printf "\e[1;93m [Done $1]\e[0m\n"
        echo
        sleep 1
    }

    # Linux system update
    apt update >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1
    
    # Linux packages installation
    packages=("git" "python3" "python3-pip" "jq" "figlet" "ruby" "curl" "wget" "zsh")

    for package in "${packages[@]}"; do
        apt install "$package" -y >/dev/null 2>&1 &
        show_spinner "$package"
    done

    # Python packages
    pip3 install lolcat >/dev/null 2>&1
    
    # ZSH setup for Linux
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh >/dev/null 2>&1
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions >/dev/null 2>&1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1
    
    # Move files
    mkdir -p /usr/local/bin/
    cp $HOME/CODEX/files/chat.sh /usr/local/bin/chat 2>/dev/null || true
    chmod +x /usr/local/bin/chat
    cp $HOME/CODEX/files/remove /usr/local/bin/ 2>/dev/null || true
    chmod +x /usr/local/bin/remove
    
    echo "y" | gem install lolcat > /dev/null 2>&1
}

spin_termux() {
    echo
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    show_spinner() {
        local pid=$!
        while ps -p $pid > /dev/null; do
            for i in "${spinner[@]}"; do
                tput civis
                echo -ne "\033[1;96m\r [+] Installing $1 please wait \e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
                sleep $delay
                printf "\b\b\b\b\b\b\b\b"
            done
        done
        printf "   \b\b\b\b\b"
        tput cnorm
        printf "\e[1;93m [Done $1]\e[0m\n"
        echo
        sleep 1
    }

    apt update >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1
    
    packages=("git" "python" "ncurses-utils" "jq" "figlet" "termux-api" "lsd" "zsh" "ruby" "exa")

    for package in "${packages[@]}"; do
        pkg install "$package" -y >/dev/null 2>&1 &
        show_spinner "$package"
    done

    pip install lolcat >/dev/null 2>&1
    rm -rf data/data/com.termux/files/usr/bin/chat >/dev/null 2>&1
    mv $HOME/CODEX/files/report $HOME/.Codex-simu 2>/dev/null || true
    mv $HOME/CODEX/files/chat.sh /data/data/com.termux/files/usr/bin/chat 2>/dev/null || true
    chmod +x /data/data/com.termux/files/usr/bin/chat
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh >/dev/null 2>&1
    rm -rf /data/data/com.termux/files/usr/etc/motd
    chsh -s zsh
    rm -rf ~/.zshrc >/dev/null 2>&1
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    git clone https://github.com/zsh-users/zsh-autosuggestions /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-autosuggestions >/dev/null 2>&1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1
    echo "y" | gem install lolcat > /dev/null 2>&1
}

# dx setup
setup() {
    # Linux ke liye directory
    if [ -f "/etc/os-release" ]; then
        ds="$HOME/.config/termux-style"
        mkdir -p "$ds"
    else
        ds="$HOME/.termux"
    fi
    
    dx="$ds/font.ttf"
    simu="$ds/colors.properties"
    
    if [ -f "$dx" ]; then
        echo
    else
        cp $HOME/CODEX/files/font.ttf "$ds" 2>/dev/null || true
    fi

    if [ -f "$simu" ]; then
        echo
    else 
        cp $HOME/CODEX/files/colors.properties "$ds" 2>/dev/null || true
    fi
    
    # Figlet fonts
    if [ -f "/etc/os-release" ]; then
        mkdir -p /usr/share/figlet/
        cp $HOME/CODEX/files/ASCII-Shadow.flf /usr/share/figlet/ 2>/dev/null || true
    else
        cp $HOME/CODEX/files/ASCII-Shadow.flf $PREFIX/share/figlet/ 2>/dev/null || true
    fi
    
    # Binary files
    if [ -f "/etc/os-release" ]; then
        cp $HOME/CODEX/files/remove /usr/local/bin/ 2>/dev/null || true
        chmod +x /usr/local/bin/remove
    else
        cp $HOME/CODEX/files/remove /data/data/com.termux/files/usr/bin/ 2>/dev/null || true
        chmod +x /data/data/com.termux/files/usr/bin/remove
        termux-reload-settings
    fi
}

dxnetcheck() {
    clear
    echo
    echo -e "               ${g}╔═══════════════╗"
    echo -e "               ${g}║ ${n}</>  ${c}MOMIN${g}   ║"
    echo -e "               ${g}╚═══════════════╝"
    echo -e "  ${g}╔════════════════════════════════════════════╗"
    echo -e "  ${g}║  ${C} ${y}Checking Your Internet Connection¡${g}  ║"
    echo -e "  ${g}╚════════════════════════════════════════════╝${n}"
    while true; do
        curl --silent --head --fail https://github.com > /dev/null
        if [ "$?" != 0 ]; then
            echo -e "              ${g}╔══════════════════╗"
            echo -e "              ${g}║${C} ${r}No Internet ${g}║"
            echo -e "              ${g}╚══════════════════╝"
            sleep 2.5
        else
            break
        fi
    done
    clear
}

donotchange() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo
    echo -e " ${A} ${c}Please Enter Your ${g}Banner Name${c}"
    echo

    while true; do
        read -p "[+]──[Enter Your Name]────► " name
        echo

        if [[ ${#name} -ge 1 && ${#name} -le 8 ]]; then
            break
        else
            echo -e " ${E} ${r}Name must be between ${g}1 and 8${r} characters. ${y}Please try again.${c}"
            echo
        fi
    done

    D1="$HOME/.config/termux-style"
    mkdir -p "$D1"
    USERNAME_FILE="$D1/usernames.txt"
    VERSION="$D1/dx.txt"
    INPUT_FILE="$HOME/CODEX/files/.zshrc"
    THEME_INPUT="$HOME/CODEX/files/.codex.zsh-theme"
    OUTPUT_ZSHRC="$HOME/.zshrc"
    OUTPUT_THEME="$HOME/.oh-my-zsh/themes/codex.zsh-theme"
    TEMP_FILE="$HOME/temp.zshrc"

    mkdir -p "$HOME/.oh-my-zsh/themes/"

    sed "s/SIMU/$name/g" "$INPUT_FILE" > "$TEMP_FILE" 2>/dev/null
    sed "s/SIMU/$name/g" "$THEME_INPUT" > "$OUTPUT_THEME" 2>/dev/null
    echo "$name" > "$USERNAME_FILE"
    echo "version 1 1.5" > "$VERSION"

    if [[ $? -eq 0 ]]; then
        mv "$TEMP_FILE" "$OUTPUT_ZSHRC"
        clear
        echo
        echo
        echo -e "		        ${g}Hey ${y}$name"
        echo -e "${c}              (\_/)"
        echo -e "              (${y}^ω^${c})     ${g}I'm Dx-Simu${c}"
        echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
        echo
        echo -e " ${A} ${c}Your Banner created ${g}Successfully¡${c}"
        echo
        sleep 3
    else
        echo
        echo -e " ${E} ${r}Error occurred while processing the file."
        sleep 1
        rm -f "$TEMP_FILE"
    fi

    echo
    clear
}

banner() {
    echo
    echo
    echo -e "   ${y}░███╗░░░███╗░█████╗░███╗░░░███╗██╗███╗░░██╗"
    echo -e "   ${y}████╗░████║██╔══██╗████╗░████║██║████╗░██║"
    echo -e "   ${c}██╔████╔██║███████║██╔████╔██║██║██╔██╗██║"
    echo -e "   ${c}██║╚██╔╝██║██╔══██║██║╚██╔╝██║██║██║╚████║"
    echo -e "   ${c}██║░╚═╝░██║██║░░██║██║░╚═╝░██║██║██║░╚███║"
    echo -e "   ${c}╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝${n}"
    echo -e "${y}               +-+-+-+-+-+-+-+-+-+"
    echo -e "${c}               |T|I|P|S|-|M|O|M|I|N|"
    echo -e "${y}               +-+-+-+-+-+-+-+-+-+${n}"
    echo
    if [ $random_number -eq 0 ]; then
        echo -e "${b}╭════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/momintipss"
        echo -e "${b}╰════════════════════════⊷"
    else
        echo -e "${b}╭══════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/momintip"
        echo -e "${b}╰══════════════════════════⊷"
    fi
    echo
    echo -e "${b}╭══ ${g}〄 ${y}ᴍᴏᴍɪɴᴛɪᴘs ${g}〄"
    echo -e "${b}┃❁ ${g}ᴄʀᴇᴀᴛᴏʀ: ${y}ᴍᴏᴍɪɴ"
    echo -e "${b}┃❁ ${g}ᴅᴇᴠɪᴄᴇ: ${y}${VENDOR} ${MODEL}"
    echo -e "${b}╰┈➤ ${g}Hey ${y}Dear"
    echo
}

setup_linux() {
    tr
    dxnetcheck
    
    banner
    echo -e " ${C} ${y}Detected Linux System (VPS)¡"
    echo -e " ${lm}"
    echo -e " ${A} ${g}Updating Package..¡"
    echo -e " ${dm}"
    echo -e " ${A} ${g}Wait a few minutes.${n}"
    echo -e " ${lm}"
    spin_linux
    
    if [ -d "$HOME/CODEX" ]; then
        sleep 2
        clear
        banner
        echo -e " ${A} ${p}Updating Completed...!¡"
        echo -e " ${dm}"
        clear
        banner
        echo -e " ${C} ${c}Package Setup Your Linux System..${n}"
        echo
        echo -e " ${A} ${g}Wait a few minutes.${n}"
        setup
        donotchange
        clear
        banner
        echo -e " ${C} ${c}Type ${g}exit ${c} then ${g}enter ${c}Now Open Your Terminal Again¡¡ ${g}[${n}${HOMES}${g}]${n}"
        echo
        sleep 3
        cd "$HOME"
        rm -rf CODEX
        exit 0
    else
        clear
        banner
        echo -e " ${E} ${r}Tools Not Exits Your Terminal.."
        echo
        echo
        sleep 3
        exit
    fi
}

setup_termux() {
    tr
    dxnetcheck
    
    banner
    echo -e " ${C} ${y}Detected Termux on Android¡"
    echo -e " ${lm}"
    echo -e " ${A} ${g}Updating Package..¡"
    echo -e " ${dm}"
    echo -e " ${A} ${g}Wait a few minutes.${n}"
    echo -e " ${lm}"
    spin_termux
    
    if [ -d "$HOME/CODEX" ]; then
        sleep 2
        clear
        banner
        echo -e " ${A} ${p}Updating Completed...!¡"
        echo -e " ${dm}"
        clear
        banner
        echo -e " ${C} ${c}Package Setup Your Termux..${n}"
        echo
        echo -e " ${A} ${g}Wait a few minutes.${n}"
        setup
        donotchange
        clear
        banner
        echo -e " ${C} ${c}Type ${g}exit ${c} then ${g}enter ${c}Now Open Your Termux¡¡ ${g}[${n}${HOMES}${g}]${n}"
        echo
        sleep 3
        cd "$HOME"
        rm -rf CODEX
        exit 0
    else
        clear
        banner
        echo -e " ${E} ${r}Tools Not Exits Your Terminal.."
        echo
        echo
        sleep 3
        exit
    fi
}

banner2() {
    echo
    echo
    echo -e "   ${y}░███╗░░░███╗░█████╗░███╗░░░███╗██╗███╗░░██╗"
    echo -e "   ${y}████╗░████║██╔══██╗████╗░████║██║████╗░██║"
    echo -e "   ${c}██╔████╔██║███████║██╔████╔██║██║██╔██╗██║"
    echo -e "   ${c}██║╚██╔╝██║██╔══██║██║╚██╔╝██║██║██║╚████║"
    echo -e "   ${c}██║░╚═╝░██║██║░░██║██║░╚═╝░██║██║██║░╚███║"
    echo -e "   ${c}╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝${n}"
    echo -e "${y}               +-+-+-+-+-+-+-+-+-+"
    echo -e "${c}               |T|I|P|S|-|M|O|M|I|N|"
    echo -e "${y}               +-+-+-+-+-+-+-+-+-+${n}"
    echo
    if [ $random_number -eq 0 ]; then
        echo -e "${b}╭════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/momintipss"
        echo -e "${b}╰════════════════════════⊷"
    else
        echo -e "${b}╭══════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/momintipss"
        echo -e "${b}╰══════════════════════════⊷"
    fi
    echo
    echo -e "${b}╭══ ${g}〄 ${y}ᴍᴏᴍɪɴᴛɪᴘs ${g}〄"
    echo -e "${b}┃❁ ${g}ᴄʀᴇᴀᴛᴏʀ: ${y}momintips"
    echo -e "${b}╰┈➤ ${g}Hey ${y}Dear"
    echo
    echo -e "${c}╭════════════════════════════════════════════════⊷"
    echo -e "${c}┃ ${p}❏ ${g}Choose what you want to use. then Click Enter${n}"
    echo -e "${c}╰════════════════════════════════════════════════⊷"
}

options=("Free Usage" "Premium")
selected=0

display_menu() {
    clear
    banner2
    echo
    echo -e " ${g}■ \e[4m${p}Select An Option\e[0m ${g}▪︎${n}"
    echo
    for i in "${!options[@]}"; do
        if [ $i -eq $selected ]; then
            echo -e " ${g}〄> ${c}${options[$i]} ${g}<〄${n}"
        else
            echo -e "     ${options[$i]}"
        fi
    done
}

# Main loop
while true; do
    display_menu

    read -rsn1 input

    if [[ "$input" == $'\e' ]]; then
        read -rsn2 -t 0.1 input
        case "$input" in
            '[A')
                ((selected--))
                if [ $selected -lt 0 ]; then
                    selected=$((${#options[@]} - 1))
                fi
                ;;
            '[B')
                ((selected++))
                if [ $selected -ge ${#options[@]} ]; then
                    selected=0
                fi
                ;;
            *)
                display_menu
                ;;
        esac
    elif [[ "$input" == "" ]]; then
        case ${options[$selected]} in
            "Free Usage")
                echo -e "\n ${g}[${n}${HOMES}${g}] ${c}Continue Free..!${n}"
                sleep 1
                # Check if it's Linux VPS or Termux
                if [ -f "/etc/os-release" ]; then
                    setup_linux
                elif [ -d "/data/data/com.termux/files/usr/" ]; then
                    setup_termux
                else
                    echo -e " ${E} ${r}Unsupported system${n}"
                    sleep 2
                    exit 1
                fi
                ;;
            "Premium")
                echo -e "\n ${g}[${n}${HOST}${g}] ${c}Wait for opening Telegram..!${n}"
                sleep 1
                xdg-open "https://t.me/momintipss" 2>/dev/null || \
                echo -e " ${A} ${y}Please visit: https://t.me/momintipss${n}"
                cd "$HOME"
                rm -rf CODEX
                exit 0
                ;;
        esac
    fi
done