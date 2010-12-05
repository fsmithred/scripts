#!/usr/bin/env bash
#
# set-selections.sh
# This script is to be used with get-selections.sh

# THE DIRECTORY YOU PUT HERE NEEDS A TRAILING SLASH!
list_dir=""



 Check that user is root
if [[ $(id -u) -ne 0 ]]
then
    echo "
    You must be root to run this.
    "
    exit 0
fi

if [[ -n $list_dir ]] && ! [[ -d $list_dir ]]
then
    echo "
        $list_dir does not exist.
        Exiting...
        "
    exit 1
fi


# Use this if script is re-written to look for 
# filenames on the command line -
# package_selections_$datetime and auto-packages_$datetime
#if [[ $# -ne 2 ]]
#then
#    echo "
#    You need to name two files.
#    "
#    exit 0
#fi

datetime=
echo "
To choose which files to use, enter the date/time stamp
(example: 20101117_1289996978)
"
ls "$list_dir"*package*
echo "
Enter: "
read datetime

echo "
 Running apt-get update...
"
sleep 1
apt-get update
echo "
 Running dpkg --clear-selections..."
sleep 1
dpkg --clear-selections
echo "
 Running dpkg --set-selections <" "$list_dir"package_selections_"$datetime"...

sleep 1
dpkg --set-selections < "$list_dir"package_selections_"$datetime"
echo "
 Running apt-get -u dselect-upgrade...
 " 
sleep 1
apt-get -u dselect-upgrade
echo "
 Running aptitude markauto \$(cat '$list_dir'auto-packages_$datetime)...
"

sleep 1
aptitude markauto $(cat "$list_dir"auto-packages_"$datetime")
echo "
And that would be it. 
"

exit 0 
