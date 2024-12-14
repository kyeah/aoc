require "./lib/grid"

def input(filename, num_rows, num_cols)
  grid = Grid.new(num_rows, num_cols)
  robots = File.readlines(filename).map do |line|
    px, py, vx, vy = line.strip.match(/p=([-\d]+),([-\d]+) v=([-\d]+),([-\d]+)/).captures.map{|x| Integer(x)}
    grid.set(px, py, (grid.get(px, py) || 0) + 1)
    Robot.new(px, py, vx, vy)
  end

  [grid, robots]
end

class Robot < Struct.new(:x, :y, :vx, :vy)
  def move(grid)
    grid.set(self.x, self.y, grid.get(self.x, self.y) - 1)
    self.x = (self.x + self.vx) % grid.num_cols
    self.y = (self.y + self.vy) % grid.num_rows
    grid.set(self.x, self.y, (grid.get(self.x, self.y) || 0) + 1)
  end
end

def part1(filename, num_cols, num_rows, seconds)
  grid, robots = input(filename, num_rows, num_cols)

  robots.each do |robot|
    robot.x = (robot.x + robot.vx*seconds) % grid.num_cols
    robot.y = (robot.y + robot.vy*seconds) % grid.num_rows
  end

  score(grid, robots)
end

def score(grid, robots)
  counts = [0, 0, 0, 0]

  robots.each do |robot|
    next if ignore_middle?(robot.x, grid.num_cols) || ignore_middle?(robot.y, grid.num_rows)

    qx = (robot.x / (grid.num_cols / 2.0).ceil).floor
    qy = (robot.y / (grid.num_rows / 2.0).ceil).floor
    counts[2*qx + qy] += 1
  end

  counts.reduce(&:*)
end

def ignore_middle?(val, total)
  is_split = total % 2 == 1
  split_idx = (total - 1) / 2
  is_split && val == split_idx
end

############ 
## PART 2 ##
############

def is_treeish(grid, robot, depth)
  (1..depth).all? do |d|
    y = robot.y + d
    (-d..d).all? do |x|
      (grid.get(robot.x + x, y) || 0) > 0
    end
  end
end

def part2(filename, num_cols, num_rows)
  grid, robots = input(filename, num_rows, num_cols)

  for s in 1...1_000_000
    robots.each do |robot|
      robot.move(grid)
    end

    robots.each do |robot|
      if is_treeish(grid, robot, 2)
        # print the grid to validate that it looks like a tree
        grid.grid.each do |row|
          puts row.map{|v| v.nil? || v == 0 ? " " : v}.join("")
        end
        return s
      end
    end
  end
end

p part1("./examples/day_14.txt", 11, 7, 100)
p part1("./input/day_14.txt", 101, 103, 100)
p part2("./input/day_14.txt", 101, 103)