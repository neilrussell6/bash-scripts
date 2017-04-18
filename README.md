BASH / AWK Scripts
==================

> A collection of BASH / AWK scripts I've written to perform small tasks in my projects and for educational purposes.

AWK create-data
===============

> An AWK script that generates a data file (comma delimited txt or csv file etc), using a provided config. Supports config for auto-incrementing column values, random item from array and random number in range.    

Usage
-----

```bash
awk -f create-data.awk config.txt > data.csv rows=1000
```

Example 1 :: simple config
--------------------------

Given the following config template:

```
foreign_id,name
33,bobby
```

The command above will create a `data.csv` file with 1000 rows, auto-incrementing an id column so that the result looks something like this:

```
id,foreign_id,name
1,33,bobby
2,33,bobby
3,33,bobby
4,33,bobby
...
```

Example 2 :: id variable
------------------------

Given the following config template:

```
static_fk,name,incrementing_fk,interpolated_incrementing_fk
33,bobby,{id},aaa{id}
```

The command above will create a `data.csv` file with 1000 rows, auto-incrementing an id column as well as all {id} variables, so that the result looks something like this:

```
id,static_fk,name,incrementing_fk,interpolated_incrementing_fk
1,33,bobby,1,aaa1
2,33,bobby,2,aaa2
3,33,bobby,3,aaa3
4,33,bobby,4,aaa4
...
```

Example 3 :: random item from array
-----------------------------------

Given the following config template:

```
foreign_id,name,date,price
[33;44],bobby,[2016-12-11 01:00:00;2016-12-10 02:00:00;2016-12-09 03:00:00],[50.00;100.00;200.00]
```

The command above will create a `data.csv` file with 1000 rows, auto-incrementing an id column as well as randomly selecting an item from each array column, so that the result looks something like this:

```
id,foreign_id,name,date,price
1,33,bobby,2016-12-11 01:00:00,200.00
2,33,bobby,2016-12-10 02:00:00,50.00
3,44,bobby,2016-12-11 01:00:00,100.00
4,33,bobby,2016-12-10 02:00:00,100.00
...
```

Example 4 :: random number in range
-----------------------------------

Given the following config template:

```
name,points
bobby,[1...50000]
```

The command above will create a `data.csv` file with 1000 rows, auto-incrementing an id column as well as randomly selecting a number for each range column, so that the result looks something like this:

```
id,name,points
1,bobby,11890
2,bobby,14554
3,bobby,42291
4,bobby,7611
...
```

AWK filter-file
===============

> An AWK script that filters the content of a given file using a provided config.     

Usage
-----

```bash
awk -f filter-file.awk config.txt data.txt > output.csv
```

Config explained
----------------

> The first row contains the values to filter by.
> The second row contains the column to capture in the result.

So the following config:

```
Johannesburg,London,Bangkok
longitude,latitude,city
```

> Translates to:
> Grab the following columns (latitude, longitude & city) from all rows with values that match any of these (Johannesburg, London or Bangkok) 

Example
-------

So given a data file with some geo data, and the following config:

```
Johannesburg,London,Bangkok
longitude,latitude,full_name
```

The command above will create an `output.csv` file with a row for each matching city (as specified in the config), with 3 columns (those specified in the config), so the result looks something like this:

```
28.0436,-26.2023,Johannesburg,2026469
-0.09184,51.5128,London,7556900
100.501,13.754,Bangkok,5104476
```

AWK delimited-to-geojson
========================

> An AWK script that converts comma delimited text data to [GEOJSON format](http://geojson.org/).
> Currently supports generating both points for geo-locations and lines connecting geo-locations.
> NOTE: This is an extension of the filter-file script above.

Usage
-----

```bash
awk -v type='Point' -f delimited-to-geojson.awk cities-config.txt cities-data.txt > cities-output.json
awk -v type='LineString' -f delimited-to-geojson.awk city-connections-config.txt city-connections-data.txt > city-connections-output.json
```

Config explained
----------------

> The first row contains the values to filter by.
> The second row contains the column to capture in the result.

So the following config:

```
Johannesburg,London,Bangkok
longitude,latitude,city
```

> Translates to:
> Grab the following columns (latitude, longitude & city) from all rows with values that match any of these (Johannesburg, London or Bangkok) 

Point Example
-------------

So given a data file with some geo data, and the following config:

```
Johannesburg,Bangkok,Chennai
longitude,latitude,full_name_nd,population
```

The following command:
 
```bash
awk -v type='Point' -f delimited-to-geojson.awk cities-config.txt cities-data.txt > cities-output.json
```

Will create a `cities-output.json` file with GEOJSON formatting, that looks something like this:

```
{
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "geometry": {
                "type": "Point", 
                "coordinates": [ 28.0436,-26.2023 ], 
                "properties": { "full_name_nd": "Johannesburg", "population":"2026469" }
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point", 
                "coordinates": [ 100.501,13.754 ], 
                "properties": { "full_name_nd":"Bangkok","population":"5104476" }
            }
        },
        ...
    ]
}
```

LineString Example
------------------

Given the same data file containing some geo data, but now with this config:

```
Johannesburg,Bangkok,Chennai
from_full_name_nd,from_latitude,from_longitude,to_full_name_nd,to_latitude,to_longitude
```

The following command:
 
```bash
awk -v type='LineString' -f delimited-to-geojson.awk city-connections-config.txt city-connections-data.txt > city-connections-output.json
```

Will create a `city-connections-output.json` file with GEOJSON formatting, that looks something like this:

```
{
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "geometry": {
                "type": "LineString", 
                "coordinates": [
                    [100.501, 13.754],
                    [88.363, 22.5626]
                ], 
                "properties": {
                    "from_full_name_nd": "Bangkok",
                    "to_full_name_nd": "Kolkata"
                }
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "LineString", 
                "coordinates": [
                    [100.501, 13.754],
                    [80.2785, 13.0878]
                ], 
                "properties": {
                    "from_full_name_nd": "Bangkok",
                    "to_full_name_nd": "Chennai"
                }
            }
        },
        ...
    ]
}
```

License
=======

[MIT](https://github.com/neilrussell6/vuejs-markdown-live-reload/blob/master/LICENSE)
