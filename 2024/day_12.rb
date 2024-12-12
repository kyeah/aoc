require "./lib/grid"

class RegionalGrid < Grid
  def mark_region(p1, grid, val, x, y, perimeters)
    return [0, 0] if self.get(x, y) != nil
    return [0, 0] if grid.get(x, y) != val
    self.set(x, y, 1)

    total_area = 1

    # The perimeter in part1 is hyper-local.
    perimeter_dirs = perimeters.get(x, y)
    total_perimeter = perimeter_dirs.length if p1

    # perimeter in part2 needs to check its neighbors extending outwards.
    if !p1
      total_perimeter = perimeter_dirs.filter do |pd|
        DIRS.none? do |dir|
          px, py = x + dir.dx, y + dir.dy

          # Walk in a direction until we get to a plot that we've counted already, or a plot that is outside of our region.
          while grid.get(px, py) == val && self.get(px, py) == nil && perimeters.get(px, py).include?(pd)
            px += dir.dx
            py += dir.dy
          end

          # IGNORE the fence in this direction if we reached a plot that is in the region, we've counted the plot already, and the plot
          # has a fence in this direction. This means that the plot we're viewing now is an extension of the existing fence.
          grid.get(px, py) == val && self.get(px, py) != nil && perimeters.get(px, py).include?(pd)
        end
      end.length
    end

    # AAA
    # AxA
    # AxA
    # AxA
    # AAA
    # ---

    # p [val, x, y, total_perimeter, perimeter_dirs]

    DIRS.each do |dir|
      area, plot_perimeter = self.mark_region(p1, grid, val, x + dir.dx, y + dir.dy, perimeters)
      total_area += area
      total_perimeter += plot_perimeter
    end

    [total_area, total_perimeter]
  end
end

def ans(filename, p1=true)
  grid = Grid.from_file(filename)
  regional_grid = RegionalGrid.new(grid.num_rows, grid.num_cols)
  perimeters = Grid.new(grid.num_rows, grid.num_cols)

  score = 0

  for y in 0...grid.num_rows
    for x in 0...grid.num_cols
      perimeter_dirs = DIRS.filter do |dir|
        grid.get(x + dir.dx, y + dir.dy) != grid.get(x, y)
      end

      perimeters.set(x, y, perimeter_dirs)
    end
  end

  for y in 0...grid.num_rows
    for x in 0...grid.num_cols
      regional_area, regional_perimeter = regional_grid.mark_region(p1, grid, grid.get(x, y), x, y, perimeters)
      score += regional_area * regional_perimeter
      # p [grid.get(x, y), regional_area, regional_perimeter] if regional_area > 0
    end
  end

  score
end

p ans("./examples/day_12.txt", true)
p ans("./input/day_12.txt", true)
p ans("./examples/day_12.txt", false)
p ans("./input/day_12.txt", false)

