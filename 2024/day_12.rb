require "./lib/grid"

class RegionalGrid < Grid
  def mark_region(p1, grid, val, x, y, deep=true)
    return [0, 0] if self.get(x, y) != nil
    return [0, 0] if grid.get(x, y) != val

    total_area = 1

    # The perimeter in part1 is hyper-local.
    perimeter_dirs = DIRS.filter do |dir|
      grid.get(x + dir.dx, y + dir.dy) != val
    end
    self.set(x, y, perimeter_dirs)

    total_perimeter = perimeter_dirs.length if p1

    if !p1
      total_perimeter = perimeter_dirs.filter do |pd|
        DIRS.all? do |dir|
          existing_sibling_dirs = []
          px, py = x + dir.dx, y + dir.dy
          while grid.get(px, py) == val
            seen = self.get(px, py)

            if seen != nil
              break if !seen.include?(pd)
              existing_sibling_dirs.push(*seen)
            end

            px += dir.dx
            py += dir.dy
          end
          !existing_sibling_dirs.include?(pd)
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
      area, plot_perimeter = self.mark_region(p1, grid, val, x + dir.dx, y + dir.dy, false)
      total_area += area
      total_perimeter += plot_perimeter
    end

    [total_area, total_perimeter]
  end
end

def part1(filename, p1=true)
  grid = Grid.from_file(filename)
  regional_grid = RegionalGrid.new(grid.num_rows, grid.num_cols)

  score = 0

  for y in 0...grid.num_rows
    for x in 0...grid.num_cols
      regional_area, regional_perimeter = regional_grid.mark_region(p1, grid, grid.get(x, y), x, y)
      score += regional_area * regional_perimeter
      p [grid.get(x, y), regional_area, regional_perimeter] if regional_area > 0
    end
  end

  score
end

#p part1("./examples/day_12.txt", true)
#p part1("./input/day_12.txt", true)
p part1("./examples/day_12.txt", false)
p part1("./input/day_12.txt", false)

