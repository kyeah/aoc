require 'set'

class Graph
  attr_accessor :vertices

  def initialize
    @vertices = Set.new
  end

  def add_edge(a, b)
    vA = self.vertices.find{ |v| v.id == a }
    vB = self.vertices.find{ |v| v.id == b }
    if !vA
      vA = Vertex.new(a, Array.new, Array.new)
      self.vertices.add(vA)
    end
    if !vB
      vB = Vertex.new(b, Array.new, Array.new)
      self.vertices.add(vB)
    end    
    vA.children.push(vB)
    vB.parents.push(vA)
  end

  def roots_helper(node)
    if node.parents.empty?
      [node]
    else
      node.parents.map{|n| roots_helper(n)}.flatten
    end
  end

  def roots
    self.vertices.map{|v| self.roots_helper(v)}.flatten.uniq
  end
end

class Vertex < Struct.new(:id, :parents, :children)
end

def input
  Graph.new.tap do |graph|
    File.readlines('./res/day_07.txt').each do |line|
      graph.add_edge(line.split[1], line.split[7])
    end
  end
end

def p1
  graph = input
  done = Array.new
  queue = graph.roots.sort_by(&:id)

  while !queue.empty?
    idx = queue.find_index{|n| !done.include?(n.id) && n.parents.all?{|p| done.include?(p.id)} }
    break unless idx
    node = queue.delete_at(idx)
    done.push(node.id)
    queue = (queue + node.children).sort_by(&:id)
  end
  done.join
end

puts p1
