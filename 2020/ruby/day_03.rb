PASSWORD_PATTERN = /(\d+)-(\d+) (\w): (.*)/

def input
  File.readlines('./res/day_03.txt').map(&:strip)
end

def helper(right, down)
  grid = input
  x, y = right, down

  trees = 0
  while y < grid.length
    trees += 1 if grid[y][x] == "#"
    x = (x + right) % grid[y].length
    y += down
  end

  trees
end

def p1
  helper(3, 1)
end

def p2
  [
    [1,1],
    [3,1],
    [5,1],
    [7,1],
    [1,2]
  ].map{ |r, d| helper(r, d) }.inject(&:*)
end

puts p1
puts p2
