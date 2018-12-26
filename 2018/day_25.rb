def dist(p1, p2)
  p1.zip(p2).sum{ |dim1, dim2| (dim1 - dim2).abs }
end

def input
  File.readlines('./res/day_25.txt').reduce([]) do |constellations, line|
    line_p = line.split(',').map(&:to_i)
    connected_constellations = constellations.select do |constellation|
      constellation.find{ |p| dist(p, line_p) <= 3 }
    end

    if connected_constellations
      joined_constellation = connected_constellations.reduce([line_p], :concat)
      connected_constellations.each{ |c| constellations.delete(c) }
      constellations.push(joined_constellation)
    else
      constellations.push([line_p])
    end

    constellations
  end
end

def p1
  input.length
end

puts p1
