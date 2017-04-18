BASH / AWK Scripts
==================

> A collection of BASH / AWK scripts I've written to perform small tasks in my projects and for educational purposes.

AWK create-data
===============

> A script that generates a data file (comma delimited txt or csv file etc), using a provided config. Supports config for auto-incrementing column values, random item from array and random number in range.    

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

> A script that filters the content of a given file using a provided config.     

Usage
-----

```bash
awk -f create-data.awk config.txt > data.csv rows=1000
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

License
=======

[MIT](https://github.com/neilrussell6/vuejs-markdown-live-reload/blob/master/LICENSE)
