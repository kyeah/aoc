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

## UHUGUHU
class Worker < Struct.new(:node, :time_left)
end

def p2
  graph = input
  done = Array.new
  queue = graph.roots.sort_by(&:id)
  workers = Array.new(5){ Worker.new(nil, 0) }

  elapsed_time = 0
  while !queue.empty?
    while true
      p queue.map(&:id)
      idx = queue.find_index do |n|
        !done.include?(n.id) &&
          n.parents.all?{|p| done.include?(p.id)} &&
          workers.none?{|w| w.node&.id == n.id}
      end
      available_worker = workers.find{|w| !w.node}
      if idx && available_worker
        node = queue.delete_at(idx)
        available_worker.node = node
        available_worker.time_left = 60 + (node.id.ord - 64)
      else
        break
      end
    end

    break if workers.all?{|w| !w.node}
    step = workers.select(&:node).compact.map(&:time_left).min

    workers.each do |w|
      next if !w.node
      w.time_left -= step
      if w.time_left == 0
        done.push(w.node.id)
        queue = (queue + w.node.children).sort_by(&:id)
        w.node = nil
      end
    end

    elapsed_time += step
  end

  elapsed_time
end

puts p1
puts p2
