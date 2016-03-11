#!/bin/bash
#Script to create the nii files from the DICOM folders

if [[ "`which dcm2nii`" == "" ]]; then
  echo "dcm2nii program is missing!"
  echo "Please, previously intall dcm2nii in order to use templateCreator"
  exit
fi

FOLDERS_PATH=$1
SUBJECT_NAME=$2

#Read variables form config file
DATE=`cat config/config_var.conf | grep DATE_FILE | cut -c11-13`
EVENTS=`cat config/config_var.conf | grep EVENTS_FILE | cut -c13-15`


#Executing the nii extraction
for acq in `ls $FOLDERS_PATH/$SUBJECT_NAME`; do
  #Create folder nii into the subject sequence folder
  if [[ ! -d "$FOLDERS_PATH/$SUBJECT_NAME/nii" ]]; then
    mkdir $FOLDERS_PATH/$SUBJECT_NAME/nii
  fi

  #Using dcm2nii
  echo "  ==> Extracting Nifti files, bvec and bval files in $SUBJECT_NAME/$acq <=="
  dcm2nii -d $DATE -e $EVENTS -o $FOLDERS_PATH/$SUBJECT_NAME/nii $FOLDERS_PATH/$SUBJECT_NAME/$acq
  echo ""
  #Renaming the files to reduce the file name and puting in the composite former: subj_acq_NUMBER.nii, *.bvec, *.bvec
  echo "  ====> Renaming .nii, .bvec and .bval file names <===="
  mv $FOLDERS_PATH/$SUBJECT_NAME/nii/xDTI*.nii.gz $FOLDERS_PATH/$SUBJECT_NAME/nii/acq${acq}_dti.nii.gz
  rm $FOLDERS_PATH/$SUBJECT_NAME/nii/DTI*.nii.gz
  mv $FOLDERS_PATH/$SUBJECT_NAME/nii/xDTI*.bvec $FOLDERS_PATH/$SUBJECT_NAME/nii/acq${acq}.bvec
  mv $FOLDERS_PATH/$SUBJECT_NAME/nii/xDTI*.bval $FOLDERS_PATH/$SUBJECT_NAME/nii/acq${acq}.bval
done
# dcm2nii -d N -e N -o /home/antonio/Pictures/ /home/antonio/Pictures/SE000001/
