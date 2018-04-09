## Simple LWW-Element-Set CRDT ##

#### Setup
Install Ruby, by [rbenv](https://github.com/rbenv/rbenv), [rvm](https://rvm.io/rvm/install) or [any other solution](https://www.ruby-lang.org/en/documentation/installation/).

#### Usage

```
$ irb # under the project directory
> require './lww_set.rb'
> set = LwwSet.new
> 
> # Add an element to the set
> set.add('3') 
> 
> # Remove an element to the set
> set.remove('3')
  
> # Get all elements in the set
> set.elements  
```

#### Notice
This simple implementation bases on the bias towards deletes.
