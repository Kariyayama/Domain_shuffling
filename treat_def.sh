#!/bin/bash
topath=`pwd`
logpath="${topath}/summary"
db="${HOME}/Labolatory/db"
any_vert="0,0,0,0,0,0,0,0,0,0,"
include_vert="0,0,0,0,0,0,0,0,0,0,.,.,.,1,1,1,1,1,1,1,1"
exclude_vert="0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1"
any_gnath="0,0,0,0,0,0,0,0,0,0,0,"
include_gnath="0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1"
any_cycl="0,0,0,0,0,0,0,0,0,0,.,.,.,0,0,0,0,0,0,0,0"
include_cycl="0,0,0,0,0,0,0,0,0,0,.,.,1,0,0,0,0,0,0,0,0"
exclude_cycl="0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0"

all=("C_milii" "H_sapiens" "X_tropicalis_jgi" "T_rubripes_jgi" \
    "G_gallus" "M_musculus" "R_norvegicus" "D_rerio" \
    "L_camtschaticum" "PmarSIMR" "E_burgeri")

extract_not_overlap_domain_combination (){
    for file in combi_out overlap_out; do
        cat ${file}.csv | \
                sort -t , -k 22,23 | awk -F , '{if($22!=$23) print}' | \
                grep -e PF -e N_ \
                > ${file}.sorted.csv
    done

    # 同じ領域にあるドメインの組み合わせから除去対象のドメインの組み合わせを抽出する
    tail -n 1 overlap_out.sorted.csv \
        > combi_out.rm_overlap.csv
    # そのドメインの組み合わせを持つ全ての動物で重なっている場合を除去
    diff -y overlap_out.sorted.csv combi_out.sorted.csv| \
        grep -e '|' -e '<' -e '>' | \
        awk '{print $3}' | \
        grep PF | \
        awk -F , '{if($22 != $23) print}' \
        >> combi_out.rm_overlap.csv
}

classify_domain_combination_each_lineage (){
    class1=`cat domain_out.csv | grep PF | \
        grep $2 | grep -v $3 | \
        awk -F , '{print " -e "$22}'`
    cat combi_out.rm_overlap.csv | grep $2 | grep -v $3 > ${1}.csv
    cat ${1}.csv | grep    $class1 > ${1}_class1.csv
    cat ${1}.csv | grep -v $class1 > ${1}_class2.csv
}


