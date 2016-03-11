#!/bin/bash
#Script to extract the non-brain tissues from the dti volumes

NII_FOLDER=$1
ACQ=`$2 | cut -c` #TODO FAZER COM QUE O NOME DO ARQUIVO NAO TENHA .NII.GZ --- PARA NOMEAR CORRETAMENTE NO BET!!!!
BET_THR=$3
NECK_RM=$4

# for vol in $LIST_DTI; do
  echo ""
  echo " ==> BET <=="
  if [[ "which fsl" == "" ]]; then
    echo "  Error: FSL is missing! Please intall FSL packages before using this script."
    exit
  fi

  echo ""
  if [[ "$NECK_RM" == "Y" ]]; then
    bet $NII_FOLDER/$ACQ $NII_FOLDER/${ACQ}_brain -m -f $BET_THR -B
  else
    bet $NII_FOLDER/$ACQ $NII_FOLDER/${ACQ}_brain -m -f $BET_THR
  fi

  # Remove the unnecessary dti brain extract volume
  rm $NII_FOLDER/$ACQ $NII_FOLDER/${ACQ}_brain.nii.gz
# done
