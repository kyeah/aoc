class Direction < Struct.new(:dx, :dy); end
DIRS = [
  Direction.new(0, -1), 
  Direction.new(1, 0),
  Direction.new(0, 1),
  Direction.new(-1, 0)
]

class Pos < Struct.new(:x, :y)
  def == (other)
    self.x == other.x && self.y == other.y
  end
end

class Grid
  attr_accessor :grid, :num_rows, :num_cols, :trailheads
  
  def initialize(num_rows, num_cols)
    self.grid = []
    self.num_rows = num_rows
    self.num_cols = num_cols
    self.trailheads = []

    for i in 0...num_rows
      self.grid.append(Array.new(num_cols))
    end
  end

  def get(x, y)
    return nil if y < 0 || y >= self.num_rows
    return nil if x < 0 || x >= self.num_cols
    self.grid[y][x]
  end

  def set(x, y, val)
    self.grid[y][x] = val
  end

  def self.from_file(filename)
    lines = File.readlines(filename).map(&:strip)
    grid = Grid.new(lines.length, lines[0].length)

    lines.each_with_index do |line, row_idx|
      line.chars.each_with_index do |c, col_idx|
        grid.set(col_idx, row_idx, Integer(c))
        grid.trailheads.append(Pos.new(col_idx, row_idx)) if c == "0"
      end
    end

    grid
  end

  def trailhead_score(trailhead, p1=true)
    trailends = self.trailends(trailhead, 0)
    p1 ? trailends.uniq.length : trailends.length
  end

  def trailends(curr_pos, expected_val)
    curr_val = self.get(curr_pos.x, curr_pos.y)
    return [] if curr_val != expected_val
    return [curr_pos] if expected_val == 9

    DIRS.reduce([]) do |accum, dir|
      new_pos = Pos.new(curr_pos.x + dir.dx, curr_pos.y + dir.dy)
      accum.concat(self.trailends(new_pos, expected_val + 1))
    end
  end
end

def input
  Grid.from_file("./input/day_10.txt")
end

def ans(p1)
  grid = input
  grid.trailheads.reduce(0) do |accum, trailhead|
    accum + grid.trailhead_score(trailhead, p1)
  end
end

p ans(true)
p ans(false)