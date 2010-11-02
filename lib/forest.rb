#! /usr/bin/ruby

require 'rubygems'
require "bundler/setup"
require 'tree' 

class Forest
  attr_accessor :trees, :orphants
  
  def initialize(data)
    grouped_tree = data.group_by{|d| [nil, "NULL", ""].include?(d[1])}
    @root = grouped_tree[true]
    @children = grouped_tree[false]
    add_root
    add_children
  end
  
  def count
    @trees.size
  end
  
  def sum
    @trees.values.inject(0){|sum, current| sum + current.size}
  end
  
  def sd
    standard_deviation(@trees.values.map{|v| v.size })
  end
  
  def avg
    sum.to_f / @trees.size
  end
  
  def biggest_node
    max_node(:size)
  end
  
  def heighest_node
    max_node(:node_height)
  end
  
  def widest_node
    max_node(:children_size)
  end
  
  def max_sum
    biggest_node.size
  end

  def max_height
    heighest_node.node_height + 1
  end
  
  def max_width
    widest_node.children_size
  end
  
  def top(n)
    @trees.values.sort {|x,y| y.size <=> x.size }[0..(n - 1)]
  end
  
  def print_report(num = 3)
    puts "Total #{sum}: Average :#{avg} Max size :#{max_sum} Max height :#{max_height} Max width :#{max_width}, Sandard Deviation #{sd}"
    puts "Top #{num} trees"
    top(num).each_with_index {|value, index| 
      puts "##{index + 1}, sum #{value.size}, height #{value.node_height}"
      puts value.print_tree
    }
  end
  
  def add_root
    @trees = @root.reduce({}) do |final, current|
      key = current.first.to_s
      final[key] = Tree::TreeNode.new(key, get_content(current))
      final
    end
  end
  
  def add_children
    add_recursive(@trees, @children)
  end
  
private 
  def max_node(obj)
    @trees.values.max{|a, b| a.send(obj) <=> b.send(obj) }
  end

  def get_content(array)
    array[2..-1].join(",")
  end
  
  def variance(population)
    n = 0
    mean = 0.0
    s = 0.0
    population.each { |x|
      n = n + 1
      delta = x - mean
      mean = mean + (delta / n)
      s = s + delta * (x - mean)
    }
    # if you want to calculate std deviation
    # of a sample change this to "s / (n-1)"
    return s / n
  end

  # calculate the standard deviation of a population
  # accepts: an array, the population
  # returns: the standard deviation
  def standard_deviation(population)
    Math.sqrt(variance(population))
  end

  def add_recursive(ancestors, decendants, previous = 0)
    remaining = []
    current_generation = {}
    counter = decendants.size
    decendants.map do |c| 
      # p "#{counter}: #{c.inspect}" if counter % 10 == 0
      child  = c[0]
      parent = c[1]
      if parent_obj = ancestors[parent.to_s]
        parent_obj << Tree::TreeNode.new(child.to_s, get_content(c))
        current_generation[child.to_s] = parent_obj[child.to_s]
      else
        remaining << c
      end
      counter = counter - 1
    end
    # p "remaining.size: #{remaining.size} previous: #{previous}"
    if remaining == [] || remaining.size == previous
      @orphants = remaining 
    else
      # p remaining
      add_recursive(current_generation , remaining, remaining.size)
    end
  end
end

#  Monkey patch
class Tree::TreeNode
  include Enumerable
  
  def children_size
    children.size
  end
  
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