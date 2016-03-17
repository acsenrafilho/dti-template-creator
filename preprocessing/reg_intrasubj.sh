#!/bin/bash
# Script to register Intrasubject sequences in order to reduce motion between each acquisition

# Remover volume de referencia (fslroi ref0)
# extrair encefalo (-f 0.1)
# registrar todas as outras imagens _eddy.nii.gz com relacao ao volume ref0 (flirt dof 6)

NII_FOLDER=$1
LIST_ACQS=`ls $NII_FOLDER | grep _eddy.nii.gz`
DOF=$2

# TODO TERMINAR DE ACERTAR O LOOP PARA FAZER O FLIRT ... PROBLEMA COM NOMES DOS ARQUIVOS.
# A IDEIA EH SEPARAR REF E O RESTO PARA FAZER O COREGISTRO UM A UM E DEPOIS MONTAR O VOLUME 4D

count=1
for acq in $LIST_ACQS; do
  if [[ $count -eq 1 ]]; then
    # Extrating the reference volume
    fslsplit $NII_FOLDER/$acq $NII_FOLDER/ref3D_ -t
  else
    fslsplit $NII_FOLDER/$acq $NII_FOLDER/tmp_`echo ${acq} | cut -c12-20`_ -t
  fi
  ((count++))
done

REF_LIST=`ls $NII_FOLDER | grep ref3D`
# TMP_LIST=`ls $NII_FOLDER | grep tmp_` TODO TALVEZ NAO PRECISA DESSA LINHA
for vol in $REF_LIST; do
  tmp_number=`echo $vol | cut -c7-10`
  echo "    --> Registering volume ${tmp_number}"
  flirt -in $NII_FOLDER/tmp_*_${tmp_number}.nii.gz -ref $NII_FOLDER/${vol}.nii.gz -out $NII_FOLDER/tmp_vol_${tmp_number}_corr -dof $DOF
done

MERGE_LIST=`ls $NII_FOLDER | grep _corr`

# Merge the tmp files to build a corrected 4D volume
# fslmerge -t
