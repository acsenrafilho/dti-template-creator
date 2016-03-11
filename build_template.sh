#!/bin/bash

usage(){
  echo "The template creator is a group of shell scripts to build a population brian template. At this point, the scripts are able to build only DTI templates."
  echo "Usage: $0 <DICOM path>"
  echo ""
  echo  "DICOM path = The path where is a structured folder with all the subjects for the template creation. Please, set the folder as:"
  echo "DICOM"
  echo "  -> subject1"
  echo "    -> DTI DICOM folder 1 (all the DICOM images that compose one single DTI acquisition)"
  echo "    -> DTI DICOM folder 2"
  echo "    -> ..."
  echo "    -> DTI DICOM folder n"
}

if [[ $# -eq 0 ]]; then
  usage
  exit
fi

#Selecting and listing the folders passed to build the brain template.
# source preprocessing/folder_list.sh $1

#Turn the folders name in anonymous style
# source preprocessing/anonym_subjects.sh $1

for subj in `ls $1 | grep "subj*"`; do
  echo "***********************************************************************"
  echo "*********** DTI normalization from $subj initiated ************"
  echo "***********************************************************************"
  echo ""
  echo "*** Initial process to create a brain template ***"
  echo ""
  echo "Step 1: Converting DICOM to Nifti"

  #Apply dcm2nii to create the nii files from the DICOM FOLDERS
  #Starting to select each subject to do all the process.
  source preprocessing/dcm2nii.sh $1 $subj

  #nii folder has all the images to process
  NII_FOLDER=$1/$subj/nii

  #Split the pre processing procedures to each acquisition per time. Less consumption of time per volume.
  for acq in `ls $NII_FOLDER | grep .nii.gz`; do
    echo "Step 2: Pre processing DWIs volumes"
    # Show the parameters choosen: Reference image, BET (threshold f), registration (flirt -> DOF (affine, 6 dof, 3 dof), fnirt (warpsize, fhwmin, fwhmref, subsamp, ))
    #Read conf file with the variables values.
    echo "  --> Creating brain mask..."
    BET_THR=`cat config/config_var.conf | grep BET_THR | cut -c9-12`
    NECK_RM=`cat config/config_var.conf | grep NECK_RM | cut -c9-10`
    # source preprocessing/brain_extraction.sh $NII_FOLDER $acq $BET_THR $NECK_RM

    echo "  --> Eddy current correction procedure..."
    HIGH_PERF=`cat config/config_var.conf | grep HIGH_PERF | cut -c10-12`
    # source preprocessing/eddy_correction.sh  $acq $HIGH_PERF


    #   echo "  --> Extracting b0 volume..."
    #   # fslroi resolve this
    #
  #   echo "Step 3: Registration procedure: Initial linear approximation"
  #   echo "  --> Non-diffusion volume (B0)"
  #   # Initialize registration process from b0 volume
  #   #   ->Use FLIRT initially.
  #   echo "  --> Apply affine transformation on DWIs volumes"
  #   #   ->Apply on all DWIs volumes applyxfm
  #
  # echo "Step 4: Registration procedure: Initial non linear approximation"
  # echo "  --> Non-diffusion volume (B0)"
  # # Again with the b0 volume
  # #   ->Use FNIRT  (fnirt --ref=MNI --in=b0_ec_brain_MNI --iout=b0_ec_brain_MNI_2mm_spline --fout=b0_spline_field --warpres=8,8,8 --infwhm=0 --reffwhm=0 --subsamp=2,1,1,1
  # echo "  --> Apply non linear warping on DWIs volumes"
  # #   ->Use applywarp -i dti_ec_brain_MNI.nii.gz -r MNI152 -o dti_ec_brain_MNI_spline.nii.gz -w b0_ec_brain_MNI_2mm_warpcoef.nii.gz
  #
  # echo "***********************************************************************"
  # echo "*** DTI normalization from $subj terminated with success.***"
  # echo "***********************************************************************"
  # echo ""
  # echo ""
  done
done
