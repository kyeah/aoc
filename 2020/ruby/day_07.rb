class Node < Struct.new(:parents, :name, :children); end
class Child < Struct.new(:count, :name); end

def update_node(nodes, name, children = nil, parents = nil)
  name = name.strip()

  if nodes[name]
    nodes[name].parents += parents if parents
    nodes[name].children += children if children
  else
    nodes[name] = Node.new(parents || [], name, children || [])
  end
end

def input
  nodes = {}
  File.readlines('./res/day_07.txt').map do |x|
    continue if !x.strip()
    if x.strip().include?("no other bags")
      update_node(nodes, x.strip().split("bags contain ")[0])
    else
      parent, second = x.strip().split("bags contain ").map(&:strip)
      inner_bags = second.sub!(".", "").split(", ")

      children = inner_bags
        .map{ |bag| /(\d+) (\w+ \w+) bag/.match(bag).captures.map(&:strip) } \
        .map{ |count, name| Child.new(Integer(count), name) }

      update_node(nodes, parent, children)

      children.each do |child|
        update_node(nodes, child.name, nil, [parent])
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
    n.children.map do |child|
      child[:count] * count_children_helper(nodes, child.name) + child.count
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
