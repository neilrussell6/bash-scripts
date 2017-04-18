#!/usr/bin/env bash

# create-data
# v0.1
# provide a comma delimited config file with 2 rows: headings and body config
#
# usage:
# awk -f create-data.awk config.txt > data.csv rows=1000
# for execution time prepend script with time

BEGIN {
    FS = ",";
    OFS = ",";
}
{
    if (NR == 1) {
        headings = $0;
    }
    if (NR == 2) {
        body = $0;
    }
}
END {
    printf "%s,%s\n", "id", headings;
    for (i = 0; i < rows; ++i) {
        printf "%d,%s\n", (i+1), body;
    }
}
