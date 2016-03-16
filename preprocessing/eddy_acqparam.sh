#!/bin/bash
#Script to perform the acquisition parameters file creation for the eddy current correction.
#See the ACQ_PARAM variable in preprocessing/config_var.conf file

NII_FOLDER=$1
ACQ=$2

#Read variables form config file
ACQ_PE=`cat config/config_var.conf | grep ACQ_PE | cut -c8-10`

case $ACQ_PE in
  "+Y" )
    echo "      --> Creating acquisition file: +Y PE"
    echo "0 1 0 0.075" >> $NII_FOLDER/${ACQ}_acqparam.txt
    ;;
  "-Y" )
    echo "      --> Creating acquisition file: -Y PE"
    ;;
esac
