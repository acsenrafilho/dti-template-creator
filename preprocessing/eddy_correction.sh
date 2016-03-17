#!/bin/bash
#Script to perform the eddy current correction.
#See the HIGH_PERF variable in preprocessing/config_var.conf file

NII_FOLDER=$1
ACQ=$2

#Read variables form config file
HIGH_PERF=$3

echo ""
echo " ==> Eddy Correction <=="

if [[ $HIGH_PERF == "Y" ]]; then
  echo "  --> Using FSL-EDDY"
  echo ""
  #Setting the input variables to FSL-Eddy
  INPUT_IMG="$NII_FOLDER/${ACQ}.nii.gz"
  BRAIN_MASK="$NII_FOLDER/${ACQ}_brain_mask.nii.gz"
  BVEC="$NII_FOLDER/${ACQ}.bvec"
  BVAL="$NII_FOLDER/${ACQ}.bval"
  OUTPUT_IMG="$NII_FOLDER/${ACQ}_eddy.nii.gz"

  # Preparing ACQ_PARAM file:
  #Read variables form config file
  ACQ_PE=`cat config/config_var.conf | grep ACQ_PE | cut -c8-10`

  # Number of volumes
  NUM_VOL=`fslnvols $NII_FOLDER/${ACQ}_dti.nii.gz`
  case $ACQ_PE in
    "+Y" )
      echo "      --> Creating acquisition file: +Y PE"
      for (( i = 0; i < 10; i++ )); do
        echo "0 1 0 0.075" >> $NII_FOLDER/tmp_${ACQ}_acqparam.txt
      done
      # indx=""
      # for (( i = 1; i <= $NUM_VOL; i++ )); do
      #   indx="$indx 0 1 0 0.075\n"
      # done
      # echo $indx > $NII_FOLDER/tmp_${ACQ}_acqparam.txt
      ;;
    "-Y" )
      echo "      --> Creating acquisition file: -Y PE"
      ;;
  esac
  # source preprocessing/eddy_acqparam.sh $NII_FOLDER $ACQ
  ACQ_PARAM="$NII_FOLDER/tmp_${ACQ}_acqparam.txt"

  # Preparing the INDEX file:
  indx=""
  for (( i = 1; i <= $NUM_VOL; i++ )); do
    indx="$indx 1"
  done
  echo $indx > $NII_FOLDER/tmp_eddy_index.txt
  # source preprocessing/eddy_index.sh $NII_FOLDER $ACQ
  INDEX="$NII_FOLDER/tmp_eddy_index.txt"

  # Running FSL-EDDY
  echo "      --> Running EDDY..."
  eddy --imain=$NII_FOLDER/${ACQ}_dti.nii.gz --mask=$NII_FOLDER/${ACQ}_brain_mask.nii.gz --index=$NII_FOLDER/tmp_eddy_index.txt --acqp=$NII_FOLDER/tmp_${ACQ}_acqparam.txt --bvecs=$NII_FOLDER/${ACQ}.bvec --bvals=$NII_FOLDER/${ACQ}.bval --out=$NII_FOLDER/${ACQ}_eddy.nii.gz
  # Removing unnecessary files
  rm $NII_FOLDER/tmp* $NII_FOLDER/*.eddy_* $NII_FOLDER/*_brain_mask.nii.gz

else
  echo "  --> Using FDT-eddy_correct"
  echo ""
  #Setting the input variables to FDT-eddy_correct
  INPUT_IMG="$NII_FOLDER/${ACQ}.nii.gz"
  OUTPUT_IMG="$NII_FOLDER/${ACQ}_eddy.nii.gz"

  # Find the reference image
  idx=0
  for i in `cat $NII_FOLDER/${ACQ}.bval`; do
    if [[ $i -lt 100 ]]; then
      break
    fi
    ((idx++))
  done

  eddy_correct $NII_FOLDER/${ACQ}_dti.nii.gz $NII_FOLDER/${ACQ}_eddy.nii.gz $idx

  # Removing ecclog from eddy_correct pipeline
  rm $NII_FOLDER/*.ecclog $NII_FOLDER/*_brain_mask.nii.gz
fi
