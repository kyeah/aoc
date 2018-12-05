class Claim < Struct.new(:id, :x, :y, :width, :height, :xend, :yend)
  def xrange
    (self.x...self.xend)
  end

  def yrange
    (self.y...self.yend)
  end
end

def input
  File.readlines('./res/day_03.txt').map do |line|
    items = line.split
    xy = items[2].split(',')
    wh = items[3].split('x')

    Claim.new(
      id     = items[0][1..-1],
      x      = Integer(xy[0]),
      y      = Integer(xy[1][0..-2]),
      width  = Integer(wh[0]),
      height = Integer(wh[1]),
      x + width,
      y + height
    )
  end
end

def hitmap
  input.reduce({}) do |map, claim|
    claim.xrange.each do |x|
      claim.yrange.each do |y|
        map[x] ||= Hash.new { 0 }
        map[x][y] += 1
      end
    end
    map
  end
end

def p1
  hitmap.sum do |x, ys|
    ys.count do |y, count|
      count > 1
    end
  end
end

def p2
  map = hitmap
  input.find do |claim|
    claim.xrange.all? do |x|
      claim.yrange.all? do |y|
        map[x][y] == 1
      end
    end
  end
end

puts p1
puts p2
