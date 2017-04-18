#!/usr/bin/env bash

# filter-file
# v0.1
#
# usage:
# awk -f filter-file.awk CONFIG_FILE DATA_FILE > OUTPUT_FILE
# eg.
# awk -f filter-file.awk config.txt data.csv > output.csv
#
# for execution time prepend script with time

BEGIN {
    FS = ",";
    OFS = ",";
}
{
    # config file
    if (ARGIND == 1) {

        # get search column
        if (FNR == 1) {
            search_column = $1;
        }

        # get search values
        if (FNR == 2) {
            split($0, search_values, ",");

        }

        # get grab columns
        if (FNR == 3) {
            split($0, grab_columns, ",");
        }
    }

    # data file
    if (ARGIND == 2) {

        # heading row
        if (FNR == 1) {

            # loop columns and find search column's index & grab column indices
            for (i=1;i<=NF;i++) {

                # find search column's index
                if ($i == search_column) {
                    search_column_index = i;
                }

                # find grab column indices
                for (j = 1; j < length(grab_columns) + 1; j++) {

                    if ($i == grab_columns[j]) {
                        grab_column_indices_str = grab_column_indices_str i ",";
                    }
                }
            }

            # convert grab column indices to array
            gsub(/\,$/, "", grab_column_indices_str);

            split(grab_column_indices_str, grab_column_indices, ",");
        }

        # body rows
        else {

            # loop columns and search_values and extract grab column values for matches
            for (i=1;i<=NF;i++) {

                for (j = 1; j < length(search_values) + 1; j++) {
                    if ($i == search_values[j]) {
                        match_data = match_data $0 ";";
                    }
                }
            }
        }
    }
}
END {

    # print headings
    for (i = 1; i < length(grab_columns) + 1; i++) {
        headings = headings grab_columns[i] ",";
    }
    gsub(/\,$/, "", headings);
    print headings;

    # print body
    split(match_data, match_data_rows_arr, ";");

    for (i = 1; i < length(match_data_rows_arr) + 1; i++) {

        row = "";
        split(match_data_rows_arr[i], match_data_col_arr, ",");

        for (j = 1; j < length(match_data_col_arr) + 1; j++) {

            for (k = 1; k < length(grab_column_indices) + 1; k++) {

                if (j == grab_column_indices[k]) {
                    row = row match_data_col_arr[j] ",";
                }
            }
        }
        gsub(/\,$/, "", row);
        print row;
    }
}