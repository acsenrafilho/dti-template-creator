#!/bin/bash
# Script to register Intrasubject sequences in order to reduce motion between each acquisition

NII_FOLDER=$1
LIST_ACQS=`ls $NII_FOLDER | grep _eddy.nii.gz`
DOF=$2

# TODO TERMINAR DE ACERTAR O LOOP PARA FAZER O FLIRT ... PROBLEMA COM NOMES DOS ARQUIVOS.
# A IDEIA EH SEPARAR REF E O RESTO PARA FAZER O COREGISTRO UM A UM E DEPOIS MONTAR O VOLUME 4D

count=0
for acq in $LIST_ACQS; do
  if [[ $count -eq 0 ]]; then
    # Extrating the reference volume
    fslsplit $NII_FOLDER/$acq $NII_FOLDER/ref3D_ -t
  else
    fslsplit $NII_FOLDER/$acq $NII_FOLDER/tmp_acq${count}_ -t
  fi
  ((count++))
done

# List the number of reference images - the first image acquisition volume
ls $NII_FOLDER | grep ref3D > $NII_FOLDER/tmp_reflist.txt
TOTAL_VOL=0
while read line; do
  ((TOTAL_VOL++))
done < $NII_FOLDER/tmp_reflist.txt

# # Registering the rest of acquisitions to the first acquisition volume (reference volume)
# for (( ac = 1; ac < $count; ac++ )); do
#   echo "    --> Registering serie $ac ..."
#   for (( i = 0; i < $TOTAL_VOL; i++ )); do
#     echo "    -----> Registering volume $i ..."
#       if [[ $i -lt 10 ]]; then
#         flirt -in $NII_FOLDER/tmp_acq${ac}_000${i}.nii.gz -ref $NII_FOLDER/ref3D_000${i}.nii.gz -out $NII_FOLDER/tmp_acq${ac}_000${i}_corr -dof $DOF
#       elif [[ $i -ge 10 && $i -lt 100 ]]; then
#         flirt -in $NII_FOLDER/tmp_acq${ac}_00${i}.nii.gz -ref $NII_FOLDER/ref3D_00${i}.nii.gz -out $NII_FOLDER/tmp_acq${ac}_00${i}_corr -dof $DOF
#       fi
#   done
# done

# # Merging each volume through each volume
# for (( i = 0; i < $TOTAL_VOL; i++ )); do
#   echo "    --> Merging volume $i to tmp_stack${i}"
#     if [[ $i -lt 10 ]]; then
#       echo "$NII_FOLDER/ref3D_000${i}.nii.gz" > $NII_FOLDER/tmp_mergelist_${i}.txt
#       for name in `ls $NII_FOLDER | grep _000${i}_corr`; do
#         echo "$NII_FOLDER/$name" >> $NII_FOLDER/tmp_mergelist_${i}.txt
#       done
#       fslmerge -t $NII_FOLDER/tmp_stack${i} `cat $NII_FOLDER/tmp_mergelist_${i}.txt`
#       echo "      -----> Calculating the mean volume ${i}"
#       fslmaths $NII_FOLDER/tmp_stack${i} -Tmean $NII_FOLDER/tmp_dti_vol000${i}.nii.gz
#     elif [[ $i -ge 10 && $i -lt 100 ]]; then
#       echo "$NII_FOLDER/ref3D_00${i}.nii.gz" > $NII_FOLDER/tmp_mergelist_${i}.txt
#       for name in `ls $NII_FOLDER | grep _00${i}_corr`; do
#         echo "$NII_FOLDER/$name" >> $NII_FOLDER/tmp_mergelist_${i}.txt
#       done
#       fslmerge -t $NII_FOLDER/tmp_stack${i} `cat $NII_FOLDER/tmp_mergelist_${i}.txt`
#       echo "      -----> Calculating the mean volume ${i}"
#       fslmaths $NII_FOLDER/tmp_stack${i} -Tmean $NII_FOLDER/tmp_dti_vol00${i}.nii.gz
#     fi
# done

# # Final merge between all the mean B0 and B1
# echo ""
# echo "    --> Creating the mean subject DTI"
# for name in `ls $NII_FOLDER | grep tmp_dti_vol`; do
#     echo "$NII_FOLDER/$name" >> $NII_FOLDER/tmp_finalmerge.txt
# done
# fslmerge -t $NII_FOLDER/dti_ec_corr_mean.nii.gz `cat $NII_FOLDER/tmp_finalmerge.txt`

# Removing trash files
rm $NII_FOLDER/tmp* $NII_FOLDER/ref3D*
