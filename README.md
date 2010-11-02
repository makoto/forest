# Forest

## Summary

A simple collection class to aggregate rubytree objects.
It takes [Adjacency List](http://sqlsummit.com/AdjacencyList.htm) as input, shows some stats and the top x biggest trees.

## Why ?

Most database tables have some hierarchy related data (eg: who's your boss, who invited you to join, etc) without evan realising it in adjacency list format. Aggregating info from these trees are [a bit difficult if the depth of each trees are not even](http://dev.mysql.com/tech-resources/articles/hierarchical-data.html). Also, most trees only have 0 or 1 node attached, which need to be filtered out before rendering. That's why I created a simple wrapper to extract only trees (top x giggest trees) which are interesting enough to render.

## Usage

forest.rb [filename]

## Input file format

[parent key], [child key], [any content(optional)]

- If last field is either nil, NULL, or "", then the row becomes a root tree
- Any middle columns are optional. If you specify them, it will be showed at tree diagram as optional information.
- Example sql to generate the input csv "select parent_id, id, name from foo"

## Input file example

### input.csv

    1,,foo,foo2,foo3
    2,1
    13,2
    3,1,bar
    4,3
    5,3
    6,3
    10,9
    9,8
    8,7
    7,
    11,
    14,12
    12,
    16,15
    15,
    17,15
    18,15
    19,15
    20,15

This will form the following tree hirarchy.

    1 - 2 - 13
      - 3 - 4
          - 5
          - 6
    7 - 8 - 9 - 10
    11
    12 - 14
    15 - 16
       - 17
       - 18
       - 19
       - 20

And here is the output.
    
    ruby forest.rb input.csv
    
    Total 20: Average :4.0 Max size :7 Max height :4 Max width :5, Sandard Deviation 2.28035085019828
    Top 100 trees
    #1, sum 7, height 2
    * 1 foo,foo2,foo3
    |---+ 2 
    |    +---> 13 
    +---+ 3 bar
        |---> 4 
        |---> 5 
        +---> 6 
    Node Name: 2 Content:  Parent: 1 Children: 1 Total Nodes: 2
    Node Name: 3 Content: bar Parent: 1 Children: 3 Total Nodes: 4
    #2, sum 6, height 1
    * 15 
    |---> 16 
    |---> 17 
    |---> 18 
    |---> 19 
    +---> 20 
    Node Name: 16 Content:  Parent: 15 Children: 0 Total Nodes: 1
    Node Name: 17 Content:  Parent: 15 Children: 0 Total Nodes: 1
    Node Name: 18 Content:  Parent: 15 Children: 0 Total Nodes: 1
    Node Name: 19 Content:  Parent: 15 Children: 0 Total Nodes: 1
    Node Name: 20 Content:  Parent: 15 Children: 0 Total Nodes: 1
    #3, sum 4, height 3
    * 7 
    +---+ 8 
        +---+ 9 
            +---> 10 
    Node Name: 8 Content:  Parent: 7 Children: 1 Total Nodes: 3
    #4, sum 2, height 1
    * 12 
    +---> 14 
    Node Name: 14 Content:  Parent: 12 Children: 0 Total Nodes: 1
    #5, sum 1, height 0
    * 11 


## Performance.

I tried parsing about 80000 rows. It used to take about 20 min, but now it takes 40 sec with 200mb memory space. The result may very depending on how deep your each tree is.

## TODO (or my wishlist)

- Get rid of "Node Name" output (Annoying)
- Add more aggregate functions
- Add more filtering functions (eg: show trees which has depth of more than 3)
- Create a conversion program to draw on graphiviz diagram
- Create a conversion program to draw histogram on R
- Create a conversion program to [nested set model](http://en.wikipedia.org/wiki/Nested_set_model) or [materialized path](http://stackoverflow.com/questions/2797720/sorting-tree-with-a-materialized-path)
- Create an adapter to switch between rdbms, nosql, or file system to avoid storing everything in memory.