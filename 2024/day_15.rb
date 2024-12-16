require "./lib/grid"

DIR_MAP = {
  "^" => DIRS[0],
  ">" => DIRS[1],
  "v" => DIRS[2],
  "<" => DIRS[3]
}

class LanternfishGrid < Grid
  attr_accessor :robot

  def move(dir)
    next_nonbox = Pos.new(robot.x + dir.dx, robot.y + dir.dy)

    while self.get_pos(next_nonbox) == "O"
      next_nonbox.x += dir.dx
      next_nonbox.y += dir.dy
    end

    return if self.get_pos(next_nonbox) == "#"
    
    # "push" the boxes by moving the first in the row to the next available location
    next_val = self.get(robot.x + dir.dx, robot.y + dir.dy)
    self.set_pos(next_nonbox, "O") if next_val == "O"

    # move da robot
    self.set_pos(robot, ".")
    robot.x += dir.dx
    robot.y += dir.dy
    self.set_pos(robot, "@")
  end

  def score_1
    self.grid.each_with_index.reduce(0) do |accum, (row, y)|
      accum + row.each_with_index.reduce(0) do |sub_accum, (c, x)|
        next sub_accum if c != "O"
        sub_accum + 100*y + x
      end
    end
  end
end

def part1(filename)
  lines = File.readlines(filename).map(&:strip)
  grid_lines = lines.filter{|line| line.start_with?("#")}

  grid = LanternfishGrid.from_lines(grid_lines) do |grid, x, y, val|
    grid.set(x, y, val)
    grid.robot = Pos.new(x, y) if val == "@"
  end

  lines.each do |line|
    next if line.start_with?("#") || line.length == 0

    line.chars.each do |c|
      grid.move(DIR_MAP[c])
    end
  end

  grid.print
  grid.score_1
end

class Objawdadw < Struct.new(:x, :y, :w)
  def collides(other)
    self_end = self.x + self.w - 1
    other_end = other.x + other.w - 1
    (self.x >= other.x && self.x <= other_end) || (self_end >= other.x && self_end <= other_end)
  end

  def move(dir)
    self.x += dir.dx
    self.y += dir.dy
  end
end

class LanternfishGrid2 < Grid
  attr_accessor :robot

  def get_boxmoves(pos, dir, seen)
    return [] if seen.include?(pos)

    my_val = self.get_pos(pos)
    return nil if my_val == "#"
    return [] if my_val != "[" && my_val != "]"
    seen.append(pos)
  
    other_posx = pos.x + (my_val == "[" ? 1 : -1)
    l = self.get_boxmoves(Pos.new(pos.x + dir.dx, pos.y + dir.dy), dir, seen)
    r = self.get_boxmoves(Pos.new(other_posx + dir.dx, pos.y + dir.dy), dir, seen)

    # Return nil if the spots next to us can't move in that direction.
    return nil if l.nil? || r.nil?
    return [Pos.new(pos.x, pos.y), Pos.new(other_posx, pos.y), l, r].flatten.uniq
  end

  def move(dir)
    return if self.get(robot.x + dir.dx, robot.y + dir.dy) == "#"

    box_moves = self.get_boxmoves(Pos.new(robot.x + dir.dx, robot.y + dir.dy), dir, [])
    return if box_moves.nil?
        
    # "push" everything in sorted order
    box_moves.sort_by{ |pos| -pos.x*dir.dx - pos.y*dir.dy }.each do |box|
      self.set(box.x + dir.dx, box.y + dir.dy, self.get_pos(box))
      self.set(box.x, box.y, ".")
    end

    # move da robot
    self.set_pos(robot, ".")
    robot.x += dir.dx
    robot.y += dir.dy
    self.set_pos(robot, "@")
  end

  def score_2
    self.grid.each_with_index.reduce(0) do |accum, (row, y)|
      accum + row.each_with_index.reduce(0) do |sub_accum, (c, x)|
        next sub_accum if c != "["
        sub_accum + 100*y + x
      end
    end
  end
end

def part2(filename)
  lines = File.readlines(filename).map(&:strip)
  grid_lines = lines.filter{|line| line.start_with?("#")}
  grid = LanternfishGrid2.new(grid_lines.length, grid_lines[0].length * 2)

  grid_lines.each_with_index do |line, row_idx|
    line.chars.each_with_index do |c, col_idx|
      grid.set(2* col_idx, row_idx, c)
      grid.set(2* col_idx + 1, row_idx, c)

      if c == "@"
        grid.robot = Pos.new(2*col_idx, row_idx)
        grid.set(2* col_idx + 1, row_idx, ".")
      elsif c == "O"
        grid.set(2* col_idx, row_idx, "[")
        grid.set(2* col_idx + 1, row_idx, "]")
      end
    end
  end

  lines.each do |line|
    next if line.start_with?("#") || line.length == 0

    line.chars.each_with_index do |c, idx|
      grid.move(DIR_MAP[c])
    end
  end

  grid.print
  grid.score_2
end


p part1("./examples/day_15.txt")
p part1("./input/day_15.txt")

p part2("./examples/day_15.txt")
p part2("./input/day_15.txt")
