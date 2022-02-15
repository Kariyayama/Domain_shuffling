#!/bin/bash

# first, copy this file and list file
start_time=`date +%s`
# make working directory
mkdir $1
cd $1
ln -s ../list* ./
binpath="/Users/kariyayama/Labolatory/Matrix/Evalue_no_order/bin"
source $binpath/treat_def.sh
topath=`pwd`
logpath="${topath}/summary"
db="/Users/kariyayama/Labolatory/db"
evalue=$1

echo "Start: `date`"  >> $logpath

# make directory ... for make gene table
mkdir -p Make_table/data
cd Make_table/data

# need file synbolic link
ln -s $topath/list.jgi_ver  ./
ln -s $db/domtblout ./

# create domcom - animal table
$binpath/create_matrix.rb list.jgi_ver $evalue

end_time=`date +%s`

time=$((end_time - start_time))
echo "End: `date`" >> $logpath
echo "$time sec"
