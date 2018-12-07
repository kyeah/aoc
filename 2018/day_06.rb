class Point < Struct.new(:id , :x, :y)
  attr_accessor :sum

  def mark
    self.sum ||= 0
    self.sum += 1
  end
end

class Grid
  attr_accessor :grid
  attr_accessor :points
  attr_accessor :minx, :miny
  attr_accessor :width, :height

  def initialize(points)
    @minx = points.map(&:x).min
    @miny = points.map(&:y).min

    @width = points.map(&:x).max - minx + 1
    @height = points.map(&:y).max - miny + 1
    @points = points

    @grid = Array.new(@width)
    @width.times{ |idx| grid[idx] = Array.new(@height) }
  end

  def mark
    (0...self.width).each do |x|
      (0...self.height).each do |y|
        mindistA, mindistB = self.points.
          map{|p| [p, mdist(x + self.minx, y + self.miny, p)] }.
          sort_by{|a,b| b}

        if mindistA[1] != mindistB[1]
          grid[x][y] = mindistA[0].id
          mindistA[0].mark
        else
          grid[x][y] = '.' # lol
        end
      end
    end
  end

  def unbounded
    a1 = (0...self.height).map do |n|
      [self.grid[0][n], self.grid[self.width - 1][n]]
    end.flatten

    a2 = (0...self.width).map do |n|
      [self.grid[n][0], self.grid[n][self.height - 1]]
    end.flatten

    @unbounded = (a1 + a2).uniq
  end
end

def mdist(x, y, gridpoint)
  (gridpoint.y - y).abs + (gridpoint.x - x).abs
end

def input
  id = 0
  File.readlines('./res/day_06.txt').map do |line|
    id+=1
    coords = line.split(',').map{|x| Integer(x)}
    Point.new(id, coords[0], coords[1])
  end
end

def p1
  grid = Grid.new(input)
  grid.mark

  # grab unbounded ids

  grid.points.
    select{|p| !grid.unbounded.include?(p.id) }.
    sort_by(&:sum).last.sum
end

puts p1

