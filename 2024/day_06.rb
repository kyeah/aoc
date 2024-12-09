class Direction < Struct.new(:dx, :dy); end
DIRS = [
  Direction.new(0, -1), 
  Direction.new(1, 0),
  Direction.new(0, 1),
  Direction.new(-1, 0)
]

class Pos < Struct.new(:x, :y, :dir_idx)
  def dx
    DIRS[self.dir_idx].dx
  end

  def dy
    DIRS[self.dir_idx].dy
  end

  def rotate!
    self.dir_idx = self.nextdir_idx
  end

  def nextdir_idx
    (self.dir_idx + 1) % DIRS.length
  end
end

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

  def self.fromFile(filename)
    lines = File.readlines(filename).map(&:strip)
    grid = Grid.new(lines.length, lines[0].length)

    start_pos = nil

    lines.each_with_index do |line, row_idx|
      line.chars.each_with_index do |c, col_idx|
        grid.set(col_idx, row_idx, c)
        start_pos = Pos.new(col_idx, row_idx, 0) if c == "^"
      end
    end

    [grid, start_pos]
  end

  def deep_copy
    arr = Marshal.load(Marshal.dump(self.grid))
    Grid.withValues(arr)
  end

  def self.withValues(arr)
    grid = Grid.new(arr.length, arr[0].length)
    grid.grid = arr
    grid
  end

  def move(pos)
    self.set(pos.x, pos.y, "#")
    nextval = self.get(pos.x + pos.dx, pos.y + pos.dy)
    
    # Check bounds, and rotate if we are about to hit a wall.
    return nil if nextval == nil
    if (nextval == "#")
      pos.rotate!
      return pos
    end
    
    # Make a move and increment the counter if needed.
    pos.x += pos.dx
    pos.y += pos.dy
    pos
  end

  def next_val(pos)
    nextval = self.get(pos.x + pos.dx, pos.y + pos.dy)
    return nil if nextval == nil
    return nextval if (nextval != "#")

    self.get(pos.x + DIRS[pos.nextdir_idx].dx, pos.y + DIRS[pos.nextdir_idx].dy)
  end
end

def part1
  grid, pos = Grid.fromFile("./input/day_06.txt")

  count = 1
  while true
    pos = grid.move(pos)
    break if pos == nil
    count += 1 if grid.get(pos.x, pos.y) == "."
  end

  count
end

def part2_diff
  grid, pos = Grid.fromFile("./input/day_06.txt")

  loops = 0

  for yy in 0...grid.num_cols
    p grid.grid[yy].join("")
  end

  for xx in 0...grid.num_rows
    for yy in 0...grid.num_cols
      puts "Testing #{xx}/#{grid.num_rows} #{yy}/#{grid.num_cols}"
      next if grid.get(xx, yy) == "^"

      grid2 = grid.deep_copy
      grid2.set(xx, yy, "#")
      pos2 = Pos.new(pos.x, pos.y, pos.dir_idx)

      seen = {}
      while true
        seen["#{pos2.x},#{pos2.y},#{pos2.dir_idx}"] = true
        pos2 = grid2.move(pos2)
        break if pos2 == nil

        if seen["#{pos2.x},#{pos2.y},#{pos2.dir_idx}"]
          loops += 1
          break
        end
      end
    end
  end

  loops
end

def part2
  grid, pos = Grid.fromFile("./input/day_06.txt")
  loops = []

  while true
    pos = grid.move(pos)
    break if pos == nil
    
    curr_icon = grid.get(pos.x, pos.y)
    next_icon = grid.next_val(pos)
    next if next_icon != "." # continue if next valid position is a place we went to before

    grid2 = grid.deep_copy
    pos2 = Pos.new(pos.x, pos.y, pos.dir_idx)

    # set next valid position to "#"
    nextval = grid.get(pos.x + pos.dx, pos.y + pos.dy)
    if (nextval != "#")
      grid2.set(pos.x + pos.dx, pos.y + pos.dy, "#")
    else
      grid2.set(pos.x + DIRS[pos.nextdir_idx].dx, pos.y + DIRS[pos.nextdir_idx].dy, "#")
    end

    # Move continuously and see if we end up overlapping exactly in an existing location
    looped = false

    puts "Looping with #{pos}"
    itr = 0
    while true
      itr += 1
      pos2 = grid2.move(pos2)
      break if pos2 == nil

      curr_icon = grid2.get(pos2.x, pos2.y)
      if curr_icon.is_a?(Array) && curr_icon.include?(pos2.dir_idx)
        looped = true
        break
      end
    end
    puts "Finished looping with #{pos} with itr #{itr}, looped = #{looped}"

    if looped
      nextval = grid.get(pos.x + pos.dx, pos.y + pos.dy)
      if (nextval != "#")
        loops.append("#{pos.x + pos.dx},#{pos.y + pos.dy}")
      else
        loops.append("#{pos.x + DIRS[pos.nextdir_idx].dx}, #{pos.y + DIRS[pos.nextdir_idx].dy}")
      end
    end

  end

  loops
end

p part1
v = part2_diff
p v