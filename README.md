BASH / AWK Scripts
==================

> A collection of BASH / AWK scripts I've written to perform small tasks in my projects and for educational purposes.

create-data
===========

Usage
-----

```bash
awk -f create-data.awk config.txt > data.csv rows=1000
```

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

License
=======

[MIT](https://github.com/neilrussell6/vuejs-markdown-live-reload/blob/master/LICENSE)
