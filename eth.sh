#! /bin/bash

# test for root

    if [[ $EUID -ne 0 ]]
    then
        printf "%s\n" "This script must be run as root" 
        exit 1
    fi


# check for Ubuntu 16.04

    if [ -e /.os_check ]
    then
        :
    elif [[ "$(uname -v)" =~ .*16.04.* ]]
    then 
        touch /.os_check
    else
        printf "%s\n" "Ubuntu 16.04 not found, exiting..."
        exit 
    fi

# set file descriptors for verbose actions, catch verbose on second pass

    exec 3>&1
    exec 4>&2
    exec 1>/dev/null
    exec 2>/dev/null

    if [ -e /.verbose ]
    then
        exec 1>&3
        exec 2>&4
    fi 
   

# parsing command line options

    cuda_toolkit=0
    driver_version="nvidia-375"
    skip_action="false"
    

    while [ $# -gt 0 ]
    do 
        case $1 in
        -h)   printf "\n%s\n\n%s\n%s\n%s\n%s\n%s\n\n%s\n\n%s\n\n" "--------- eth.sh help menu ---------" \
              "-v       enable verbose mode, lots of output" \
              "-c       install CUDA 8.0 toolkit, not required for ethminer" \
              "-h       print this menu" \
              "-381     installs Nvidia 381 driver instead of Long Lived 375" \
              "-o       overclocking only" \
              "example usage:" "sudo eth.sh -v" 1>&3 2>&4
              exit 1
              ;;
        -v)   exec 1>&3
              exec 2>&4
              touch /.verbose
              ;;
        -o)   skip_action="true"
              ;;
        -c)   cuda_toolkit=1 
              ;;                      
        -381) driver_version="nvidia-381"
              ;;
        --)   shift
              break
              ;;           
        *)    printf "%s\n" "$1: unrecognized option" 1>&3 2>&4
              exit
              ;;
        esac

        shift
    done

# setting up permissions and files for automated second and/or third run

    
    if [ -e /.autostart_complete ] || [ "$skip_action" = "true" ]
    then
        :
    else
        read -d "\0" -a user_array < <(who)
        printf "%s\n" "${user_array[0]} ALL=(ALL:ALL) NOPASSWD:/usr/bin/gnome-terminal" 1>&3 2>&4 >> /etc/sudoers
        cp "$(readlink -f $0)" /usr/local/sbin/eth.sh
        chmod a+x /usr/local/sbin/eth.sh 
        if [ -d "/home/${user_array[0]}/.config/autostart/" ] || mkdir -p "/home/${user_array[0]}/.config/autostart/"
        then           
             printf "%s\n%s\n%s\n%s" "[Desktop Entry]" "Name=eth" \
             "Exec=sudo /usr/bin/gnome-terminal -e /usr/local/sbin/eth.sh" \
             "Type=Application" 1>&3 2>&4 > /home/${user_array[0]}/.config/autostart/eth.desktop 
             touch /.autostart_complete
        fi                       
    fi 
    
    
 
    

# Grabbing materials

    if [ -e /.materials_complete ] || [ "$skip_action" = "true" ]
    then
        :
    else
        printf "%s\n" "Grabbing some materials for later use ..." 1>&3 2>&4
        add-apt-repository -y "ppa:graphics-drivers/ppa" 
        add-apt-repository -y "ppa:ethereum/ethereum"
        apt-get -y install software-properties-common 
        mkdir /setupethminer
        cd /setupethminer
        wget "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb" 
        dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb 
        wget "https://github.com/ethereum-mining/ethminer/releases/download/v0.11.0rc1/ethminer-0.11.0rc1-Linux.tar.gz" 
        tar -xvzf ethminer-0.11.0rc1-Linux.tar.gz 
        apt-get update 
        printf "%s\n" "Done..." 1>&3 2>&4
        touch /.materials_complete 
    fi
    

# check for Nvidia driver

    if [ -e /.driver_complete ] || [ "$skip_action" = "true" ]
    then
        :
    elif nvidia-smi 
    then
        printf "%s\n" "Nvidia driver found ..." 1>&3 2>&4
        printf "%s\n" "Generating xorg config with cool-bits enabled" 1>&3 2>&4
        nvidia-xconfig 
        nvidia-xconfig --cool-bits=8 
        touch /.driver_complete
        printf "%s\n" "Done, system will reboot in 10 seconds..." 1>&3 2>&4
        printf "%s\n" "This will continue automatically upon reboot..." 1>&3 2>&4           
        sleep 10s
        systemctl reboot        
    else
        printf "%s\n" "Grabbing driver, this may take a while..." 1>&3 2>&4
        apt-get -y install "$driver_version" 
        printf "%s\n" "Done, system will reboot in 10 seconds..." 1>&3 2>&4
        printf "%s\n" "This will continue automatically upon reboot..." 1>&3 2>&4
        sleep 10s
        systemctl reboot
    fi
            
                      
 # get CUDA 8.0 toolkit

    if [ -e /.cuda_toolkit_complete ] || [ "$skip_action" = "true" ]
    then
        :
    elif [ $cuda_toolkit -eq 1 ]
    then
        if nvcc -V | grep "release 8" 
        then
            printf "%s\n" "CUDA toolkit 8.0 already installed..." 1>&3 2>&4
            touch /.cuda_toolkit_complete
        else
            printf "%s\n" "Getting CUDA 8.0 toolkit, this may take a really long time..." 1>&3 2>&4
            apt-get -y install cuda 
            export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
            printf "%s\n" "Done..." 1>&3 2>&4
            touch /.cuda_toolkit_complete
        fi
    fi
          

# get ethminer
    
    if [ -e /.ethminer_complete ] || [ "$skip_action" = "true" ]
    then
         :
    else
        printf "%s\n" "Installing CUDA optimized ethminer" 1>&3 2>&4
        cp "/setupethminer/bin/ethminer" "/usr/local/sbin/"
        chmod a+x "/usr/local/sbin/ethminer"
        touch /.ethminer_complete
        printf "%s\n" "ethminer installed..." 1>&3 2>&4
     fi

# install Ethereum

    if [ -e /.ethereum_complete ] || [ "$skip_action" = "true" ]
    then
        :
    else
        printf "%s\n" "Getting Ethereum..." 1>&3 2>&4
        apt-get -y install ethereum
        printf "%s\n" "Done..." 1>&3 2>&4
        touch /.ethereum_complete 
    fi 

# overclocking and reducing power limit on GTX 1060 and GTX 1070

    exec 1>&3
    exec 2>&4 

    
    number_of_gpus="$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits)"
    printf "%s\n" "found $number_of_gpus gpu[s]..."
    index=$(( number_of_gpus - 1 ))
    for i in $(seq 0 $index)
    do
       if nvidia-smi -i $i --query-gpu=name --format=csv,noheader,nounits | grep -E "1060" 1> /dev/null
       then
           printf "%s\n" "found GeForce GTX 1060 at index $i..."
           printf "%s\n" "setting persistence mode..."
           nvidia-smi -i $i -pm 1
           printf "%s\n" "setting power limit to 75 watts.."
           nvidia-smi -i $i -pl 75
           printf "%s\n" "setting memory overclock of 500 Mhz..."
           nvidia-settings -a [gpu:${i}]/GPUMemoryTransferRateOffset[3]=500
       elif nvidia-smi -i $i --query-gpu=name --format=csv,noheader,nounits | grep -E "1070" 1> /dev/null
       then 
           printf "%s\n" "found GeForce GTX 1070 at index $i..."
           printf "%s\n" "setting persistence mode..."
           nvidia-smi -i $i -pm 1
           printf "%s\n" "setting power limit to 95 watts.."
           nvidia-smi -i $i -pl 95
           printf "%s\n" "setting memory overclock of 500 Mhz..."
           nvidia-settings -a [gpu:${i}]/GPUMemoryTransferRateOffset[3]=500
       fi 
    done
           
           
           

# Test for 60 minutes

    if [ -e /.test_complete ] || [ "$skip_action" = "true" ]
    then
         :
    else
         printf "%s\n" "This is a stability check and donation, it will automatically end after 60 minutes" 
         touch /.test_complete
         read -d "\0" -a user_array < <(who)
         rm -f /home/${user_array[0]}/.config/autostart/eth.desktop
         rm -rf /setupethminer
         timeout 60m ethminer -U -F "http://eth-us.dwarfpool.com:80/0xf1d9bb42932a0e770949ce6637a0d35e460816b5" 
    fi

