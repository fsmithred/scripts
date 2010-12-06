#!/usr/bin/env bash

####    fsr notes to mt...
# MAX is arbitrary number I picked.
# BU_DIR is empty. Put your folder in there. I wiped it out and can't remember.
# I changed the output a bit - only DONE_ARRAY and FUL_SIZE get echoed
# FIT_SIZE is FUL_SIZE, but only after trimming BU_ARRAY
# When FIT_SIZE becomes zero, the script stops. That's the point at 
# which there are no more directories to add to BU_ARRAY, because they've
# all been added on previous iterations of the loop.


#check for root
#[[ $(id -un) = "root" ]] || { echo "you need to be root!" ; exit 1 ; }

#->
# VARIABLES: backup_directory; index for the array and 
# the maximum of size for the stick
#->
BU_DIR=""
INDEX=0
MAX=880000
NUM=0
#declare -a DONE_ARRAY

#create BU_ARRAY; all directories which shall be backed up:
function fill_array {
unset BU_ARRAY[@]
for i in "$BU_DIR"/*
do
  if [[ -d "$i" ]] &&  $(echo "${DONE_ARRAY[@]}" | grep -qv  "$i" )
  then
#	echo $(du -sh "$i")
	BU_ARRAY[$INDEX]="$i"
        (( INDEX++))
  fi
done 
}

# FUL_SIZE: size of all folders, which will be backed up
# SIZE: size of each folder
# C_FILE: SIZE renamed to only the size value of "du -s"
FUL_SIZE=0
function _test_size {
for i in "${BU_ARRAY[@]}"
do 
	SIZE=$(du -s "$i") 
	C_SIZE="${SIZE%%/*}"
	(( FUL_SIZE=$FUL_SIZE + $C_SIZE ))
done
}

function fit_array {
# set the COUNTER 
((COUNTER = $INDEX -1 ))

# until the size of the folders to be backed up is less than the max
# remove the last element of the array:
until [[  $FUL_SIZE -le  $MAX ]] 
do
	FUL_SIZE=0
	unset BU_ARRAY[$COUNTER]
	((COUNTER-- ))
	_test_size
done
FIT_SIZE="$FUL_SIZE"
# result
echo -e "\n\t this is the final folders we will backup:"
for i in "${BU_ARRAY[@]}"; do echo "$i"; done 
}

function mark_done {
DONE_ARRAY=( "${DONE_ARRAY[@]}" "${BU_ARRAY[@]}" )
echo ====================
echo $NUM These are finished: "${DONE_ARRAY[@]}"
((NUM++))
}

#until [[ $NUM -eq 3 ]]
#until [[ ${#DONE_ARRAY[@]} -eq $(ls -p $BU_DIR | grep "/" | wc -l) ]]
#until [[ ${#DONE_ARRAY[@]} -eq $(tree -d -L 1 $BU_DIR | grep "/" | wc -l) ]]
#until [[ $FIT_SIZE -eq 0 ]]
#until [[ -z ${BU_DIR[@]} ]]
while true; do
fill_array
_test_size
echo $NUM Full Size = $FUL_SIZE
fit_array
echo $NUM Fit Size = $FIT_SIZE
  if [[ $FIT_SIZE -eq 0 ]]; then
      exit 0
  fi
mark_done
done


exit 0
