require 'set'

def input
  Graph.new.tap do |graph|
    File.readlines('./res/day_07.txt').each do |line|
      graph.add_edge(line.split[1], line.split[7])
    end
  end
end

class Worker < Struct.new(:node, :time_left)
  def working?
    !!self.node
  end
end

class Vertex < Struct.new(:id, :parents, :children)
  def ready?(done, working)
    !done.include?(self.id) &&
      !working.map(&:node).map(&:id).include?(self.id) &&
      self.parents.all?{ |p| done.include?(p.id) }
  end
end

class Graph
  attr_accessor :vertices

  def initialize
    @vertices = Set.new
  end

  def add_or_insert_vertex(id)
    v = self.vertices.find{ |v| v.id == id }
    v || Vertex.new(id, Array.new, Array.new).tap do |v|
      self.vertices.add(v)
    end
  end

  def add_edge(a, b)
    vA = self.add_or_insert_vertex(a)
    vB = self.add_or_insert_vertex(b)
    vA.children.push(vB)
    vB.parents.push(vA)
  end

  def roots(nodes = self.vertices)
    nodes.map do |node|
      node.parents.empty? ? [node] : roots(node.parents)
    end.flatten.uniq
  end
end

def run(n = 1, withTime = false)
  graph = input

  done = Array.new
  queue = graph.roots.sort_by(&:id)
  workers = Array.new(n){ Worker.new(nil, 0) }
  elapsed_time = 0
  
  while !queue.empty?
    loop do
      available_worker = workers.find{|w| !w.working?}
      idx = queue.find_index{ |n| n.ready?(done, workers.select(&:working?)) }
      break unless available_worker && idx

      node = queue.delete_at(idx)
      available_worker.node = node

      time = withTime ? 60 + (node.id.ord - 64) : 0
      available_worker.time_left = time
    end

    break if workers.none?(&:working?)
    step = workers.select(&:working?).map(&:time_left).min

    workers.select(&:working?).each do |w|
      w.time_left -= step
      if w.time_left == 0
        done.push(w.node.id)
        queue = (queue + w.node.children).sort_by(&:id)
        w.node = nil
      end
    end

    elapsed_time += step
  end

  [done.join, elapsed_time]
end

puts run(1, false)
puts run(5, true)
