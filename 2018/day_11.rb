def input
  bonus = 3031
  grid = Array.new

  (0...300).each do |y|
    gridy = Array.new

    (0...300).each do |x|
      rack_id = x + 10
      power = rack_id * (rack_id * y + bonus)
      gridy[x] = (power / 100 % 10) - 5
    end

    grid.push(gridy)
  end

  grid
end

def p1
  grid = input
  mx, my, max = nil, nil, nil

  (0...298).each do |y|
    (0...298).each do |x|
      sum = (0...3).sum do |dx|
        (0...3).sum do |dy|
          grid[y + dy][x + dx]
        end
      end

      if !max || sum > max
        mx, my = x, y
        max = sum
      end
    end
  end
  "#{mx},#{my}"
end

def p2
  grid = input
  mx, my, msize, max = nil, nil, nil

  (0...300).each do |y|
    puts y
    (0...300).each do |x|
      grid_size = [300-y, 300-x].min

      gridsum = 0
      (1..grid_size).each do |size|
        gridsum += (0...size).sum{ |dx| grid[y + size - 1][x + dx] }
        if size > 1
          gridsum += (0...size).sum{ |dy| grid[y + dy][x + size - 1] }
          gridsum += grid[y + size - 1][x + size - 1]
        end

        if !max || gridsum > max
          mx, my, msize = x, y, size
          max = gridsum
        end
      end
    end
  end
  "#{mx},#{my},#{msize},#{max}"
end

puts p1
puts p2
