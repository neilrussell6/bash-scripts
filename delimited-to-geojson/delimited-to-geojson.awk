#!/usr/bin/env bash

# filter-file
# v0.2
#
# usage:
# awk -v 'TYPE' -f delimited-to-geojson.awk CONFIG_FILE DATA_FILE > OUTPUT_FILE
#
# eg.
# awk -v type='Point' -f delimited-to-geojson.awk cities-config.txt cities-data.txt > cities-output.json
# awk -v type='LineString' -f delimited-to-geojson.awk city-connections-config.txt city-connections-data.txt > city-connections-output.json
#
# for execution time prepend script with time
#
# TODO: run result through http://geojsonlint.com/

# returns the left keys for all intersecting values, but in order or the right array
function intersectionKeysLeft(arr1, arr2, result) {

    for (_k2 in arr2) {
        for (_k1 in arr1) {
            if (arr1[_k1] == arr2[_k2]) {
                _result_str = _result_str _k1 ",";
            }
        }
    }

    gsub(/\,$/, "", _result_str);
    split(_result_str, result, ",");
}

# extract point data from row
# TODO: split this out into multiple generic functions
function extractPointDataFromRow(source_str, keys, indices, result) {

    split(source_str, _source_arr, ",");

    _longitude = "";
    _latitude = "";
    _properties = "";

    for (_i in indices) {

        _key = keys[_i];
        _value = _source_arr[ indices[_i] ];

        if (_key == "longitude") {
            _longitude = _value;
        }
        else if (_key == "latitude") {
            _latitude = _value;
        }
        else {
            _properties = _properties "'" _key "':'" _value "',";
        }
    }

    gsub(/\,$/, "", _properties);

    result["coords"] = _longitude "," _latitude;
    result["properties"] = _properties;
}

# extract line string data from row
# TODO: split this out into multiple generic functions
function extractLineStringDataFromRow(source_str, keys, indices, result) {

    split(source_str, _source_arr, ",");

    _from_longitude = "";
    _from_latitude = "";
    _to_longitude = "";
    _to_latitude = "";
    _properties = "";

    for (_i in indices) {

        _key = keys[_i];
        _value = _source_arr[ indices[_i] ];

        if (_key == "from_longitude") {
            _from_longitude = _value;
        }
        else if (_key == "from_latitude") {
            _from_latitude = _value;
        }
        else if (_key == "to_longitude") {
            _to_longitude = _value;
        }
        else if (_key == "to_latitude") {
            _to_latitude = _value;
        }
        else {
            _properties = _properties "'" _key "':'" _value "',";
        }
    }

    gsub(/\,$/, "", _properties);

    result["coords"] = "[" _from_longitude "," _from_latitude "],[" _to_longitude "," _to_latitude "]";
    result["properties"] = _properties;
}

# creates a feature json using given template
function createFeature(template, type, coordinates, properties) {
    _result = template;
    gsub(/\%TYPE\%/, type, _result);
    gsub(/\%COORDINATES\%/, coordinates, _result);
    gsub(/\%PROPERTIES\%/, properties, _result);
    return _result;
}

# creates a feature collection json using given template
function createFeatureCollection(template, features) {
    _result = template;
    gsub(/\%FEATURES\%/, features, _result);
    return _result;
}

BEGIN {
    FS = ",";
    OFS = ",";
    feature_collection_tpl = "{ 'type': 'FeatureCollection', 'features': [\n%FEATURES%] }";
    feature_tpl = "{ 'type': 'Feature', 'geometry': {'type': '%TYPE%', 'coordinates': [ %COORDINATES% ], 'properties': { %PROPERTIES% } }},\n";
}
{
    while ( getline == 1 ) {

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
            }

            # match or no search
            else if (search_regex == "" || match($0, search_regex)) {

                # extract data
                if (type == "Point") {
                    extractPointDataFromRow($0, grab_columns_arr, grab_column_indices_arr, _obj);
                }
                else if (type == "LineString") {
                    extractLineStringDataFromRow($0, grab_columns_arr, grab_column_indices_arr, _obj);
                }

                # create feature
                features = features createFeature(feature_tpl, type, _obj["coords"], _obj["properties"]);
                #features = features createFeature(feature_tpl, type, "[123.123, 321.312]", "'name': 'London', 'population': '123'");
            }
        }
    }
}
END {

    # remove last , from features (can't get this working when there are \n in string)
    # sub(/\(.*\),/, "", features);

    # remove last \n and , from features and re-add \n
    features = substr(features, 0, length(features) - 2);
    features = features "\n";

    # create feature collection
    features_collection = createFeatureCollection(feature_collection_tpl, features);

    # replace single quotes with double
    gsub(/'/, "\"", features_collection);

    # output
    print features_collection;
}