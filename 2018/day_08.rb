class Node < Struct.new(:child_n, :metadata_n, :children, :metadata)
  attr_accessor :id
  def sum
    self.metadata.sum + self.children.map(&:sum).sum
  end
end

def read_node(thingies)
  child_n = thingies.shift
  metadata_n = thingies.shift
  Node.new(child_n, metadata_n, Array.new, Array.new)
end

def input
  id = 0
  thingies = File.read('./res/day_08.txt').split.map(&:to_i)
  #thingies = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2".split.map(&:to_i)
  nodes, nodes_waiting_for_metadata = Array.new, Array.new
  root = read_node(thingies)
  nodes.push(root)

  while !thingies.empty?
    last_node = nodes.reverse.find{ |n| n.child_n != 0 }
    break if !last_node

    node = read_node(thingies)
    node.id = id
    id += 1
    p ["read_node:", node.id, node.child_n, node.metadata_n]

    nodes.push(node)

    last_node.children.push(node)
    last_node.child_n -= 1

    if last_node.child_n == 0
      nodes_waiting_for_metadata.push(last_node)
    end

    if node.child_n == 0
      nodes_waiting_for_metadata.push(node)
      mnode = nodes_waiting_for_metadata.last
      while mnode && mnode.child_n == 0
        nodes_waiting_for_metadata.pop
        mnode.metadata = thingies.shift(mnode.metadata_n)
        mnode.metadata_n = 0
        mnode = nodes_waiting_for_metadata.last
      end
    end
  end

  if !nodes_waiting_for_metadata.empty?
    puts 'uh oh'
  end

  root
end

def p1
  input.sum
end

puts p1
