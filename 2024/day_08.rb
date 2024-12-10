require "./lib/grid"

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