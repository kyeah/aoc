DEBUG = false

class Node < Struct.new(:id, :child_n, :metadata_n, :children, :metadata, :parent)
  def sum
    self.metadata.sum + self.children.map(&:sum).sum
  end

  def value
    if children.empty?
      self.metadata.sum
    else
      self.metadata.map{|m| children[m - 1]}.compact.map(&:value).sum
    end
  end
end

def read_node(id, thingies, parent)
  id += 1
  child_n = thingies.shift
  metadata_n = thingies.shift
  Node.new(id, child_n, metadata_n, Array.new, Array.new, parent)
end

def input
  id = 0
  thingies = File.read('./res/day_08.txt').split.map(&:to_i)

  nodes = Array.new
  root = read_node(id, thingies, nil)
  nodes.push(root)

  while !thingies.empty?
    last_node = nodes.reverse.find{ |n| n.child_n != 0 }
    break if !last_node

    node = read_node(id, thingies, last_node)
    p ["read_node:", last_node.id, node.id, node.child_n, node.metadata_n] if DEBUG

    nodes.push(node)
    last_node.children.push(node)
    last_node.child_n -= 1

    if node.child_n == 0
      mnode = node
      while mnode && mnode.child_n == 0 && mnode.metadata_n > 0
        mnode.metadata = thingies.shift(mnode.metadata_n)
        p ["read_metadata:", mnode.id, mnode.metadata_n, mnode.metadata] if DEBUG

        mnode.metadata_n = 0
        mnode = mnode.parent
      end
    end
  end

  root
end

def p1
  input.sum
end

def p2
  input.value
end

puts p1
puts p2
