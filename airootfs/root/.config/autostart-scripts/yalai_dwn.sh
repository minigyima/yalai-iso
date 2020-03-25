#!/bin/sh
# YaLAI downloader script
# Version 2.0
# Written by minigyima
# Copyright 2020
title="YaLAI Downloader"
wellcome_text="Welcome to YaLAI (Yet another Live Arch Installer)! \n
Please ensure that you have an active connection to the internet, since it is mandatory for downloading the installer and also for the installation of Arch Linux.\n 
If you need to connect to a wifi network, you may click the NetworkManager icon on the panel.\n
However, if you are using a wired connection, NetworkManager should automatically detect that, and configure it for you.\n
Once you are connected to the internet, click the 'Yes' button on this dialogbox to proceed. If you would like to exit the installer, press the 'No' button instead.\n
Also you can use this live installer as a rescue cd, by opening a terminal from the application menu."

# Displaying welcome message
welcome_box () { 

zenity --question --width=450 --height=300 --title="$title" --text "$wellcome_text"

if [ "$?" = "1" ]
	then exit
fi
}
ping_google() {

	if [[ ! $(ping -c 1 google.com) ]]; then
     	zenity --info --title="$title" --text "The internet connection was not detected, please try again."
     	welcome_box
	fi
}
# Downloading installer...
download() {
	installer_picker=$(zenity --list --height=500 --width=450 --title="$title" --radiolist --text "Which installer would you like to use?" --column Select --column Desktop FALSE "YaLAIQt (YaLAI v3, Qt5)" FALSE "YaLAI v2 (GTK+, old version)")
  	case $installer_picker in
	  	'YaLAIQt (YaLAI v3, Qt5)')
		  	mkdir yalai
			cd yalai
		  	wget $(curl --silent "https://api.github.com/repos/minigyima/yalai/releases/latest" | grep -Po '"browser_download_url": "\K.*?(?=")') -O release.tar.gz
			tar -xf release.tar.gz
			chmod +x YaLaI
			chmod +x ./scripts/*
			;;
		'YaLAI v2 (GTK+, old version)')
	  		git clone https://github.com/minigyima/yalai-old.git
			cd yalai-old
  			chmod +x yalai.sh
			;;
			esac
			
}

# execute the installer
installer() {
	case $installer_picker in
	  	'YaLAIQt (YaLAI v3, Qt5)')
		  	./YaLaI
			;;
		'YaLAI v2 (GTK+, old version)')
	  		konsole -e "bash ./yalai.sh"
			;;
			esac
}
welcome_box
ping_google
download
installer