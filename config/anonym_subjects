#!/bin/bash
#This script change the subjects folders name in order leave it anonymous
FOLDERS=$1

#Log file to know what was the exact name transformation
if [[ -s "$FOLDERS/log/Anonymous_folders.log" ]]; then
  rm $FOLDERS/log/Anonymous_folders.log
fi
  echo "Old name New name" > $FOLDERS/log/Anonymous_folders.log

#Effectivelly anonymizing the names in each folder to "subjectNUMBER"
count=1
for sub in `ls $FOLDERS`; do
  if [[ "$sub" != "log" ]]; then
    echo $sub       subject$count
    echo $sub       subject$count >> $FOLDERS/log/Anonymous_folders.log
    mv $FOLDERS/$sub $FOLDERS/subject$count
    ((count++))
  fi
done

echo "=== All folders are set to anonymous names in the format: subject<NUMBER> ==="
