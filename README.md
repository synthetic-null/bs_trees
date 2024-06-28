# BSTrees

This is a Ruby gem that implements binary search and AVL trees.

## WARNING!

This gem was created in educational purposes and is not intended for use in production. It may contain a lot of bugs, have indeterminate behavior in some cases and be critically changed from version to version. Therefore, it was not published on RubyGems.

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add bs_trees --github "synthetic-null/bs_trees"
```

If bundler is not being used to manage dependencies, first you must download the gem and then install it by executing:

```shell
gem install bs_trees-0.2.0.gem
```

## Usage
### Semantics

This gem provides some kinds of binary search trees as
sorted collections, each of which maintains its elements in ascending order.
The elements are sorted using the <=> method.
The interfaces of the presented trees are almost identical.

### Initialization

First, you need to load gem:

```ruby
require 'bs_trees'
```

Then you can create a search tree like this:

```ruby
# tree = BSTrees::BST.new
tree = BSTrees::AVL.new
```

Or, you can fill it with elements by giving any enumerable object
that responds to #each as argument:

```ruby
# tree = BSTrees::AVL.new %w[d a c b f i e]
tree = BSTrees::AVL.new 1..100
```

And, finally, you can just use ::[] method and list elements:

```ruby
tree = BSTree::AVL[1, 6, 4, 3, 7]
```

### Iteration

All trees include Enumerable module and provide iteration methods:

* #each\_inorder - yields elements in ascending order,
  aliased by #each
* #reverse\_each\_inorder - yields elements in descending order,
  aliased by #reverse\_each
* #each\_preorder - yields elements in preorder
* #each\_postorder - yields elements in postorder

### Searching

You can get an object from tree like this:

```ruby
tree.get 10
```

### Insertion

```ruby
tree.insert 10
tree << 'a' << 'b'
```

Also you can insert many elements at once:

```ruby
tree.insert_each 30..50
```

### Deletion

```ruby
tree.delete 10
```

Also you can delete many elements at once:

```ruby
tree.delete_each 30..50
```

If you want to delete all elements, use #clear:

```ruby
tree.clear
```

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/synthetic-null/bs_trees).

## License

Copyright (C) 2024 Roman Kozachenko <romkozachenko@gmail.com>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the LICENSE file for more details.
