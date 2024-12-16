class Direction < Struct.new(:dx, :dy)
  def == (other)
    self.dx == other.dx && self.dy == other.dy
  end
end

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

    for i in 0...num_rows
      self.grid.append(Array.new(num_cols))
    end
  end

  def get(x, y)
    return nil if y < 0 || y >= self.num_rows
    return nil if x < 0 || x >= self.num_cols
    self.grid[y][x]
  end

  def get_pos(pos)
    self.get(pos.x, pos.y)
  end

  def set(x, y, val)
    self.grid[y][x] = val
  end
  
  def set_pos(pos, val)
    self.set(pos.x, pos.y, val)
  end

  def self.from_file(filename, &)
    lines = File.readlines(filename).map(&:strip)
    self.from_lines(lines, &)
  end

  def self.from_lines(lines)
    grid = self.new(lines.length, lines[0].length)

    lines.each_with_index do |line, row_idx|
      line.chars.each_with_index do |c, col_idx|
        if block_given?
          yield [grid, col_idx, row_idx, c]
        else
          grid.set(col_idx, row_idx, c)
        end
      end
    end

    grid
  end

  def print
    self.grid.each do |row|
      puts row.join("")
    end
  end
end
