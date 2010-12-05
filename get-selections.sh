#!/usr/bin/env bash



stamp=$(date +%Y%m%d_%s)

# THE DIRECTORY YOU PUT HERE NEEDS A TRAILING SLASH!
list_dir=""


if [[ -n $list_dir ]] && ! [[ -d $list_dir ]]
then
    echo "
        $list_dir does not exist.
        Exiting...
        "
    exit 1
fi

echo "
    Running dpkg --get-selections \"*\" >" "$list_dir"package_selections_"$stamp"
    dpkg --get-selections "*" > "$list_dir"package_selections_"$stamp"
    echo "    Done!
    "
echo "
    Now running aptitude -F '%p' search '~M' >" "$list_dir"auto-packages_"$stamp"
    aptitude -F '%p' search '~M' > "$list_dir"auto-packages_"$stamp"
    echo "    Done!
    "
exit 0
 


        
#        Then, on the new system:
# apt-get update
# dpkg --clear-selections
# dpkg --set-selections < package_selections_blah
# apt-get -u dselect-upgrade

#after the download/install is complete
   # aptitude markauto $(cat auto-packages_blah)
   
#  Notes:
# apt-get:    -u, --show-upgraded
#           Show upgraded packages; Print out a list of all packages that are
#           to be upgraded. Configuration Item: APT::Get::Show-Upgraded.
#
#
# dpkg  --clear-selections
#              Set  the requested state of every non-essential package to dein‐
#              stall.   This  is  intended  to  be  used   immediately   before
#              --set-selections, to deinstall any packages not in list given to
#              --set-selections.

