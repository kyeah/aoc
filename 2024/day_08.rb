class Pos < Struct.new(:x, :y); end

class Grid
  attr_accessor :grid, :num_rows, :num_cols
  
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

  def set(x, y, val)
    self.grid[y][x] = val
  end

  def self.from_file(filename)
    lines = File.readlines(filename).map(&:strip)
    grid = Grid.new(lines.length, lines[0].length)

    lines.each_with_index do |line, row_idx|
      line.chars.each_with_index do |c, col_idx|
        grid.set(col_idx, row_idx, c)
      end
    end

    grid
  end
end

def input
  Grid.from_file("./input/day_08.txt")
end

def ans(p1 = true)
  grid = input

  # Should build this while reading input but yolo
  # build map of frequencies to all positions
  frequencies = {}

  for y in 0...grid.num_rows
    for x in 0...grid.num_cols
      val = grid.get(x, y)
      next if val == "."

      frequencies[val] ||= []
      frequencies[val].append(Pos.new(x, y))
    end
  end

  frequencies.each do |k, positions|
    # Build pairs of antennae and update the grid to mark antinodes
    pairs = positions.combination(2).to_a

    pairs.each do |pos1, pos2|
      dx = pos2.x - pos1.x
      dy = pos2.y - pos1.y

      if p1
        node1 = Pos.new(pos1.x - dx, pos1.y  - dy)
        node2 = Pos.new(pos2.x + dx, pos2.y + dy)

        grid.set(node1.x, node1.y, "#") if grid.get(node1.x, node1.y) != nil
        grid.set(node2.x, node2.y, "#") if grid.get(node2.x, node2.y) != nil
      else
        def walk(grid, pos, dx, dy)
          curr_pos = Pos.new(pos.x, pos.y)
          while true
            grid.set(curr_pos.x, curr_pos.y, "#")
            curr_pos.x = curr_pos.x + dx
            curr_pos.y = curr_pos.y + dy
            break if grid.get(curr_pos.x, curr_pos.y) == nil
          end
        end

        walk(grid, pos1, dx, dy)
        walk(grid, pos2, -dx, -dy)
      end
    end
  end

  # Should count this while walking the grid but yolo
  count = 0
  for y in 0...grid.num_rows
    for x in 0...grid.num_cols
      count += 1 if grid.get(x, y) == "#"
    end
  end

  count
end

p ans(true)
p ans(false)