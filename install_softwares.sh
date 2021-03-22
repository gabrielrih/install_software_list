#!/bin/bash
# Software:	install-software.sh
# Description: 	Install a list of softwares
# Author:	Gabriel Richter <gabrielrih@gmail.com>
#
# Created on	22 December, 2015
# Modified on	23 Septiembre, 2016
#

version=1.1
lastmodification="Fri Sep 23 00:12:41 BRT 2016"
allpackets=0
packets_installed=0
packets_dropped=0

use="USAGE: $0 [options]

Options:
	[-i | --install]	Install softwares
	[-v | --version]	Show version
	[-h | --help]		Show help

INFO: Use this script to install softwares"

install_software () {

	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -y
	apt-get autoremove -y
	apt-get autoclean

	while read i
	do

		# Ckecking if package is already installed
		packet=$(dpkg --get-selections | grep "$i")

		if [ -n "$packet" ]
		then
			echo "The '$i' package is already installed!"
			packets_dropped=$(($packets_dropped + 1))
		else
			apt-get install $i -y
			echo "The '$i' package was installed!"
			packets_installed=$(($packets_installed + 1))
		fi

		allpackets=$(($allpackets + 1))

	done < softwares.list

	echo ""
	echo "All analyzed packages: $allpackets"
	echo "Packages installed: $packets_installed"
	echo "Packages dropped: $packets_dropped"

}


case $1 in

        -i | --install)
                install_software
        ;;

        -v | --version)
                echo "Version $version"
                echo "Last Modification $lastmodification"
				echo "Created by Gabriel Richter <gabrielrih@gmail.com>"
        ;;

        -h | --help)
                echo "$use"
        ;;

        *)
                echo "$use"
                echo ""

                if [ ! -f $1 ]
                then
                        echo "ERROR: Invalid argument! Argument $1 not found."
                fi

                exit 1
        ;;

esac

exit 0 
