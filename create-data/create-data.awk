#!/usr/bin/env bash

# create-data
# v0.3
# added support for semi-colon delimited arrays in body config eg. [33;77;aa]
# which will select a random value from that array
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
        split($0, body, ",");
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

            # array vars
            if (match(col, /^\[/)) {

                # trim brackets from col
                col_str = substr(col, 2, length(col) - 2);

                # convert col to array
                split(col_str, col_arr, ";");

                # get random index
                min = 1;
                max = length(col_arr);
                col_i = int(min + rand() * (max - min + 1));

                # set column
                col = col_arr[ col_i ];
            }

            line = line "," col;
        }

        print line;
    }
}
