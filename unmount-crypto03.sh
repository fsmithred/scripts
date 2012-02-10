#!/usr/bin/env bash
# unmount-crypto03.sh
# Copyright 2012 fsmithred@gmail.com
# License: GPL-3


# Check for root
[[ $(id -u) -eq 0 ]] || { echo -e "\t You need to be root!\n" ; exit 1 ; }


# Record errors in a logfile.
error_log="./errors_unmountcrypto"
exec 2>"$error_log"


# Make sure we're in an x-session.
[[ $DISPLAY ]] || { echo "
	You need to be running in a graphical session for this script.
	
	Here's a list of what's in /dev/mapper before I exit...
	"
	ls -1 /dev/mapper | grep -v control
	echo "done!"
	exit 1 ; }


# Show a checklist of mounted encrypted filesystems (what's in /dev/mapper)
uncrypts=$(ls -1 /dev/mapper | awk '!/control/ { print "FALSE\n" $0 }' \
	|  zenity --list --checklist --title "Encrypted Partitions"  \
	--text "Choose encrypted partitions to unmount and close." \
	--multiple --column ' ' --column 'Encrypted Volumes' --height=200)


# Replace "|" with space between the device names.
to_unmount=$(echo "$uncrypts" | sed 's/|/ /g')


# Unmount and close, then remove the mountpoint.
for i in $(echo "$to_unmount"); do
	mountpoint=$(df | awk -v pattern=$i '$0 ~ pattern { print $6 }')

	umount "$mountpoint"
	if ! $(mount | grep -q "$mountpoint"); then
		echo "$mountpoint unmounted"
	fi

	cryptsetup luksClose /dev/mapper/"$i"
	rmdir "$mountpoint"
	if ! [[ -e /dev/mapper/"$i" ]]; then
		echo "$i closed."
	fi
done

exit 0
