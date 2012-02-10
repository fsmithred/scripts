#!/usr/bin/env bash
# mount-crypto03.sh
# zenity checklist to select luks-encrypted partitions and mount them
# Copyright 2012 fsmithred@gmail.com
# License: GPL-3

# NOTES
# Does not handle LVM.
# First checklist shows all encrypted partitions, but does not tell
# you which ones are already opened and mounted.


# Check for root
[[ $(id -u) -eq 0 ]] || { echo -e "\t You need to be root!\n" ; exit 1 ; }


# Record errors in a logfile.
error_log="./errors_mountcrypto"
exec 2>"$error_log"


# Make sure we're in an x-session.
[[ $DISPLAY ]] || { echo "
	You need to be running in a graphical session for this script.
	
	Here's a list of ecrypted partitions before I exit...
	"
	blkid | sort | awk -F: '/crypto/ { print $1 }'
	exit 1 ; }

# Show a checklist of all encrypted partitions
cryptvols=$(blkid | sort | awk -F: '/crypto/ { print "FALSE\n" $1 }' |\
	zenity --list --checklist --title "Encrypted Partitions"  \
	--text "Choose encrypted partitions to open and mount." \
	--multiple --column ' ' --column 'Encrypted Volumes' --height=200)
[[ $? = 0 ]] || exit 0

# Replace "|" with space between the device names. 
to_mount=$(echo "$cryptvols" | sed 's/|/ /g')

# Select a place to create the mountpoint(s)
mountdir=$(zenity --file-selection --directory --title "Choose location for mount points."  --filename="/mnt")


# Create a mount point for each selected partition.
# Open the partition and mount the filesystem.
for i in $(echo "$to_mount"); do
	label="${i##*/}"
	mountpoint="$mountdir/$label"
	if [[ -d "$mountpoint" ]]; then
		echo "$mountpoint already exists!"
		sleep 3
	else
		echo "Creating $mountpoint..."
		mkdir -p "$mountpoint"
	fi

	cryptsetup luksOpen "$i" "$label"
	if [[ -e /dev/mapper/"$label" ]]; then
		echo "$i opened."
	fi

	mount /dev/mapper/"$label" "$mountpoint"
	if $(mount | grep -q "$mountpoint"); then
		echo "/dev/mapper/$label mounted."
	fi
done

exit 0




# For LVM
# todo: need to account for multiple vgnames and lvnames
# cryptsetup luksOpen /dev/sdxN $label
# vgdisplay to get VG Name 
# vgname=$(vgdisplay | awk '/VG\ Name/ { print $3 }')
# vgchange -a y $vgname
# lvnames=$(lvdisplay | awk '/LV\ Name/ { print $3 }')
# can then mount something, either:
#	mount /dev/mapper/"$vgname"-"$lvname" "$mountpoint"
#	mount /dev/"$vgname"/"$lvname" "$mountpoint"
#
# for i in $(echo "${lvnames[@]}"); do
#	echo "${i##*/}"
#	done
#
# if [[ $(lvdisplay | awk '/NOT\ available/ { print $3 }'); then
#	echo "Not available"
# else
# 	echo "must be available"
# fi
#
