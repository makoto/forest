#! /usr/bin/ruby
##  Tree hirarchy
# 
#
# 1 - 2 - 13
#   - 3 - 4
#       - 5
#       - 6
# 7 - 8 - 9 - 10
# 11
# 12 - 14
# 15 - 16
#    - 17
#    - 18
#    - 19
#    - 20
# 
## csv file format 
# 1,foo,foo2,foo3,
# 2,1
# 13,2
# 3,bar,1
# 4,3
# 5,3
# 6,3
# 10,9
# 9,8
# 8,7
# 7,
# 11,
# 14,12
# 12,
# 16,15
# 15,
# 17,15
# 18,15
# 19,15
# 20,15
#
## Array
# data = [
#   [1, "foo", "foo2", "foo3", nil] ,
#   [2, 1]   ,
#   [13, 2]  ,
#   [3, "bar", 1]   ,
#   [4, 3]   ,
#   [5, 3]   ,
#   [6, 3]   ,
#   [10, 9]  ,
#   [9, 8]   ,
#   [8, 7]   ,
#   [7, nil] ,
#   [11, nil],
#   [14, 12] ,
#   [12, nil],
#   [16, 15] ,
#   [15, nil],
#   [17, 15] ,
#   [18, 15] ,
#   [19, 15] ,
#   [20, 15]
# ]

require 'rubygems'
require 'tree' 
require 'pp'
require 'csv'


class Forest
  attr_accessor :trees
  
  def initialize(data)
    @trees = []
    p data
    grouped_tree = data.group_by{|d| d.last == nil || d.last == "NULL" || d.last == "" }
    @root = grouped_tree[true]
    @children = grouped_tree[false]
    # p @root
    add_root
    add_children
  end
  
  def total
    @trees.inject(0){|sum, current| sum + current.size}
  end
  
  def avg
    total.to_f / @trees.size
  end
  
  def max_total
    @trees.max{|a, b| a.size <=> b.size }.size
  end
  
  def max_height
    @trees.max{|a, b| a.node_height <=> b.node_height }.node_height
  end
  
  def max_width
    @trees.max{|a, b| a.children.size <=> b.children.size }.children.size
  end
  
  def top(n)
    @trees.sort {|x,y| y.size <=> x.size }[0..(n - 1)]
  end
  
  def print_report(num = 3)
    puts "Total #{total}: Average :#{avg} Max size :#{max_total} Max height :#{max_height} Max width :#{max_width}"
    puts "Top #{num} trees"
    top(num).each {|t| 
      puts t.size
      puts t.node_height
      puts t.print_tree
    }
  end
  
  def add_root
    p "ADDING TO ROOT"
    @root.map do |a|
      # p a.first.to_s
      @trees << Tree::TreeNode.new(a.first.to_s, get_content(a))
    end
  end
  
  def add_children
    add_recursive(@trees, @children)
  end
  
private 
  def get_content(array)
    array[1..-2].join(",")
  end

  def add_recursive(ancestors, decendants, previous = 0)
    remaining = []
    current_generation = []
    counter = decendants.size
    decendants.map do |c| 
      p "#{counter}: #{c.inspect}" if counter % 10 == 0
      child  = c.first
      parent = c.last
      if parent_obj = ancestors.find{|a| a.name.to_s == parent.to_s}
        parent_obj << Tree::TreeNode.new(child.to_s, get_content(c))
        current_generation << parent_obj[child.to_s]
      else
        remaining << c
      end
      counter = counter - 1
    end
    p "remaining.size: #{remaining.size} previous: #{previous}"
    if remaining == [] || remaining.size == previous
      # p "Ending"
    else
      p remaining
      add_recursive(current_generation , remaining, remaining.size)
    end
  end
end

#  Monkey patch
class Tree::TreeNode
  include Enumerable
  
  def print_tree(level = 0)
    if is_root?
      print "*"
    else
      print "|" unless parent.is_last_sibling?
      print(' ' * (level - 1) * 4)
      print(is_last_sibling? ? "+" : "|")
      print "---"
      print(has_children? ? "+" : ">")
    end
    
    puts " #{name} #{content}"
    
    children { |child| child.print_tree(level + 1)}
  end
end

data = []
file_name = ARGV[0]
p file_name
CSV.open(file_name, 'r') do |row|
  data << row
end

forest = Forest.new(data)
forest.print_report(100)
