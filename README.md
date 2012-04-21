# ruby-simple-graph

Ruby implimentation of 'Programming the Semantic Web' Chapter2

## Example

    > require 'simplegraph'

    > graph = SimpleGraph.new

    > graph.add 'blade_runner', 'name', 'Blade Runner'  
    > graph.add 'blade_runner', 'directed_by', 'ridley_scott'
    > graph.add 'ridley_scott', 'name', 'Ridley Scott'

    > graph.value 'blade_runner', 'directed_by', nil
    "ridley_scott"

    > graph.triples nil, 'name', nil
    [["blade_runner", "name", "Blade Runner"], ["ridley_scott", "name", "Ridley Scott"]]

## Backlog
* Implement Chapter3 and more

## Reference
* ['Programming the Semantic Web' by By Toby Segaran, Colin Evans, Jamie Taylor](http://shop.oreilly.com/product/9780596153823.do)
* [SEMANTIC PROGRAMMING](http://semprog.com)
