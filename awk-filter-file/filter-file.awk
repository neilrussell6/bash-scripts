#!/usr/bin/env bash

# filter-file
# v0.2
#
# usage:
# awk -f filter-file.awk CONFIG_FILE DATA_FILE > OUTPUT_FILE
# eg.
# awk -f filter-file.awk config.txt data.txt > output.csv
#
# for execution time prepend script with time

# returns the left keys for all intersecting values, but in order or the right array
function intersectionKeysLeft(arr1, arr2, result) {
    for (k2 in arr2) {
        for (k1 in arr1) {
            if (arr1[k1] == arr2[k2]) {
                result_str = result_str k1 ",";
            }
        }
    }
    gsub(/\,$/, "", result_str);
    split(result_str, result, ",");
}

# identifies values in a delimited string and returns filtered string
function filterDelimitedValuesByIndexArray(source_str, indices, delimiter) {
    result_str = "";
    split(source_str, source_arr, delimiter);
    for (i in indices) {
        result_str = result_str source_arr[ indices[i] ] delimiter;
    }
    gsub(/\,$/, "", result_str);
    return result_str;
}

BEGIN {
    FS = ",";
    OFS = ",";
}
{
    # config file
    if (ARGIND == 1) {

        # get search values as regex
        if (FNR == 1) {
            search_regex = $0;
            gsub(/\,/, ",|,", search_regex);
            search_regex = "," search_regex ",";
        }

        # get grab columns as array
        if (FNR == 2) {
            grab_columns_str = $0;
            split(grab_columns_str, grab_columns_arr, ",");
        }
    }

    # data file
    if (ARGIND == 2) {

        # get grab column indices
        if (FNR == 1) {
            split($0, columns_arr, ",");
            intersectionKeysLeft(columns_arr, grab_columns_arr, grab_column_indices_arr);

            # print headings
            # print grab_columns_str;
        }

        # match
        else if (match($0, search_regex)) {

            # print filtered body
            print filterDelimitedValuesByIndexArray($0, grab_column_indices_arr, ",");
        }
    }
}
END {
}
