#!/bin/bash

usage ()
{
  echo "Usage : $0 <DICOM folder path> "
  echo "-h    Help"
  exit
}

Help ()
{
  clear
  echo "Help passage"
  exit
}

#Check before start the procedure
if [[ $# -eq 0 ]]; then
  echo "Folder path is missing!. Please type a full path which have the DICOM image files."
  usage
  exit
fi

# while [[ $1 != "" ]]; do
#   case $1 in
#     -h ) Help
#       ;;
#   esac
# done

echo "*** Starting script: $0 $1"
folder_path=$1
cd $folder_path
mkdir log
#TODO: Check is the folder is empty
# if [[ "$(ls -A $folder_path)" -eq "" ]]; then
#   echo "The folder in path $1 is empty"
#   exit
# fi

echo "---> Folder listing names"
#Create e log with the names of the folder contained inside the given path

ls $pwd | sort > log/folders_localized.log
folders_names=`cat log/folders_localized.log`

for name in $folders_names; do
  if [[ $name != "log" ]]; then
      echo $name
  fi
done
