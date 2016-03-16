#!/bin/bash
#Script to perform the index parameters file creation for the eddy current correction.
#See the INDEX_FILE variable in preprocessing/config_var.conf file

NII_FOLDER=$1
ACQ=$2

#Read variables form config file
# INDEX_FILE=`cat config/config_var.conf | grep INDEX_FILE | cut -c12-14`

# Number of volumes
#NUM_VOL=`fsl5.0-fslnvols $NII_FOLDER/${ACQ}_dti.nii.gz`

indx=""
for (( i = 1; i <= $NUM_VOL; i++ )); do
  indx="$indx 1"
done
echo $indx > $NII_FOLDER/tmp_eddy_index.txt
