class Node < Struct.new(:parents, :name, :children_count, :children); end

def update_node(nodes, name, children = nil, parents = nil)
  name = name.strip()

  if nodes[name]
    nodes[name].parents += parents if parents
    nodes[name].children_count += children.map{|x| x[0]} if children
    nodes[name].children += children.map{|x| x[1]} if children
  else
    nodes[name] = Node.new(parents || [], name, (children && children.map{|x| x[0]}) || [], (children && children.map{|x| x[1]}) || [])
  end
end

def input
  nodes = {}
  File.readlines('./res/day_07.txt').map do |x|
    continue if !x.strip()
    if x.strip().include?("no other bags")
      update_node(nodes, x.strip().split("bags contain ")[0])
    else
      outer_bag, second = x.strip().split("bags contain ").map(&:strip)
      inner_bags = second.sub!(".", "").split(", ")

      inner_names = inner_bags.map{ |bag| /(\d+) (\w+ \w+) bag/.match(bag).captures.map(&:strip) }
      update_node(nodes, outer_bag, inner_names)

      inner_names.each do |count, name|
        update_node(nodes, name, nil, [outer_bag])
      end
      #caps = /(\w+) (\w+) bags contain ((\d+) (\w+) (\w+) bags?,? ?)+/.match(x.strip()).captures
    end
  end
  nodes
end

def count_helper(nodes, node)
  n = nodes[node]
  if n.parents
    n.parents + n.parents.flat_map{ |x| count_helper(nodes, x) }
  else
    []
  end
end

def count_children_helper(nodes, node)
  n = nodes[node]
  if n.children.length > 0
    n.children.zip(n.children_count).map do |child, count|
      Integer(count) * count_children_helper(nodes, child) + Integer(count)
    end.sum
  else
    return 0
  end
end

def p1
  nodes = input
  node = "shiny gold"
  count_helper(nodes, node).uniq.length
end

def p2
  nodes = input
  node = "shiny gold"
  count_children_helper(nodes, node)
end

puts p1
puts p2
