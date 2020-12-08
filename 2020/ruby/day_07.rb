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
    x = x.strip()
    parent, child_details = x.strip().split("bags contain ").map(&:strip)

    continue if !x

    if x.include?("no other bags")
      update_node(nodes, parent)
    else
      children = child_details
        .sub!(".", "") \
        .split(", ") \
        .map{ |bag| /(\d+) (\w+ \w+) bag/.match(bag).captures.map(&:strip) } \
        .map{ |count, name| Child.new(Integer(count), name) }

      update_node(nodes, parent, children)

      children.each do |child|
        update_node(nodes, child.name, nil, [parent])
      end
    end
  end
  nodes
end

def count_helper(nodes, n)
  return [] if !n.parents    
  n.parents + n.parents.flat_map{ |x| count_helper(nodes, nodes[x]) }
end

def count_children_helper(nodes, n)
  return 0 if n.children.length == 0

  n.children.map do |child|
    child.count + child.count * count_children_helper(nodes, nodes[child.name])
  end.sum
end

def p1
  nodes = input
  count_helper(nodes, nodes["shiny gold"]).uniq.length
end

def p2
  nodes = input
  count_children_helper(nodes, nodes["shiny gold"])
end

puts p1
puts p2
