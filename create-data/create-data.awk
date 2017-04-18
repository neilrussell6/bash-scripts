#!/usr/bin/env bash

# create-data
# v0.2
# added support for {id} variable
#
# usage:
# awk -f create-data.awk config-example-2.txt > data.csv rows=1000
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
        split($0,body,",");
    }
}
END {
    print "id," headings;
    for (i = 0; i < rows; ++i) {
        id = i + 1;
        line = id;

        # columns
        for (j = 1; j < length(body) + 1; j++) {

            col = body[j];

            # replace id vars
            if (match(col, /\{id\}/)) {
                gsub(/\{id\}/, id, col);
            }

            line = line "," col;
        }

        print line;
    }
}
