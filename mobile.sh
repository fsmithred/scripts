#!/usr/bin/env bash

taskfer_dir=$HOME/.taskfer


if ! [[ -d $taskfer_dir ]]
    then
        mkdir $taskfer_dir
fi

function taskfer_configuration {
    if [[ -f $taskfer_dir/taskferrc ]] ; then
        source $taskfer_dir/taskferrc
    fi
#
#    # check for values in $taskfer_dir/taskferrc and use them.
#    # if any are unset, this will set them.
    tasklist=${tasklist:="$taskfer_dir/tasklist"}
    tmplist=${tmplist:="$taskfer_dir/tmplist"}
    taskfer_pager=${taskfer_pager:=$(which less)}
    taskfer_editor=${taskfer_editor:=$(which vim)}
}

taskfer_configuration


# make sure tmplist doesn't exist from an aborted previous run.
if [[ -f "$tmplist" ]]
then
    rm "$tmplist"
fi


function print_daysheets {
    echo "Wait..."
    count=0
    ddt=$(date +%Y-%m-%d)
    until [[ "$count" = "$days" ]]
    do
        while read line
        do
          if [[ -n $(echo $line | cut -d"|" -f2 | grep  $ddt) ]]
          then
          echo "$line" >> "$tmplist"
          fi
        done < "$tasklist"
            if [[ -f $tmplist ]]
            then    
            { sort -t"|" -k2 "$tmplist" | awk -F"|" '{ print $1 "|" $3 }' ; } > todolist_"$ddt"
            rm "$tmplist"
            fi
      ddt=$(date --date="$ddt + 1 day" +%Y-%m-%d)
      ((count+=1))
    done
exit 0
}

while [[ $1 == -* ]]
do
    case "$1" in

      -p)
              if [[ "$2" ]]
              then 
                  days="$2"
              else
                  days=8 
              fi 
              print_daysheets ;;
              
       *) 
              printf "\t invalid option: $1 \n\n"
              printf "\t Try:  $0 -h for full help. \n\n"
                  1>&2; exit 1 ;;
    esac
done

