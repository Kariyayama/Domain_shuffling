#!/bin/bash

# first, copy this file and list file
start_time=`date +%s`

# make working directory
mkdir $1
cd $1
ln -s ../list* ./
binpath="${HOME}/Labolatory/Matrix/Evalue_Finalized/bin"
source $binpath/treat_def.sh
topath=`pwd`
evalue=$1

echo "Start: `date`"  >> $logpath

# make directory ... for make gene table
mkdir -p Make_table/data
cd Make_table/data

# need file synbolic link
ln -s $db/domtblout ./

# create domcom - animal table
# $binpath/create_matrix.rb $topath/list.jgi_ver $evalue \
#     > creat_matrix.log

# # extract not overlapping domain combination
# extract_not_overlap_domain_combination
#
# # count domcom number & make Gnathostome or Vertebrate specific domcom list
# echo 'all domain combination' >  $logpath
# wc -l combi_out.rm_overlap.csv           >> $logpath
#
# ## gene clustaring
# mkdir $topath/Make_table/Clustaring
# cd    $topath/Make_table/Clustaring
# # need file synbolic link
# for file in combi_out.rm_overlap.csv domain_out.csv; do
#     ln -s $topath/Make_table/data/$file  ./
# done
# # clustaling domcom -> class1 class2 uniq
# classify_domain_combination_each_lineage vertebrate  $include_vert  $exclude_vert
# classify_domain_combination_each_lineage gnathostome $include_gnath "PF00000"
# classify_domain_combination_each_lineage cyclostome  $include_cycl  $exclude_cycl
#
## make domcom - gene table prepere
for lineage in vertebrate gnathostome cyclostome; do
    for class in class1 class2; do
        for dir in Make_gene_list Gene_list; do
            mkdir -p $topath/$dir/${lineage}/${class}
            cd $topath/Make_gene_list/${lineage}/${class}
            ln -s $db/domtblout
            ln -s $topath/Make_table/Clustaring/${lineage}_${class}.csv
        done
    done
done

# create tables from domain combination to gene
for lineage in vertebrate gnathostome cyclostome; do
    for class in class1 class2; do
        cd $topath/Make_gene_list/${lineage}/${class}
        for target in "${all[@]}"; do
            ${binpath}/create_combi_gene_table.rb \
                ${target}.domtblout \
                ${lineage}_${class}.csv \
                $evalue
        done
    done
done

end_time=`date +%s`

time=$((end_time - start_time))
echo "End: `date`" >> $logpath
echo "$time sec"
