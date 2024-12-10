require "./lib/grid"

class HikeGrid < Grid
  attr_accessor :trailheads
  
  def initialize(num_rows, num_cols)
    super(num_rows, num_cols)
    self.trailheads = []
  end

  def self.from_file(filename)
    super(filename) do |grid, x, y, val|
      grid.set(x, y, Integer(val))
      grid.trailheads.append(Pos.new(x, y)) if val == "0"
    end
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
  HikeGrid.from_file("./input/day_10.txt")
end

def ans(p1)
  grid = input
  grid.trailheads.reduce(0) do |accum, trailhead|
    accum + grid.trailhead_score(trailhead, p1)
  end
end

p ans(true)
p ans(false)