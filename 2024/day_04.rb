PART_2_CORNERS = [
  {x: 1, y: 1},
  {x: -1, y: 1},
  {x: -1, y: -1},
  {x: 1, y: -1}
]

PART_2_VALID_SEQUENCES = ["SSMM", "SMMS", "MSSM", "MMSS"]

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
    self.grid[y][x]
  end

  def set(x, y, val)
    self.grid[y][x] = val
  end

  # For part 1, iterate over each grid cell and check the word in all directions recursively.
  def get_word_count(x, y, word)
    count = 0

    for x_dir in -1..1
      for y_dir in -1..1
        next if x_dir == 0 && y_dir == 0
        
        # Verify bounds and short-circuit if it's gonna leave the grid.
        last_x = x + x_dir * (word.length - 1)
        last_y = y + y_dir * (word.length - 1)

        next if last_x >= self.num_cols || last_x < 0
        next if last_y >= self.num_rows || last_y < 0

        # Check the word in this direction recursively. This is a little ugly but yolo
        count += 1 if self.found_word(word, x, y, 0, x_dir, y_dir)
      end
    end

    count
  end

  def found_word(word, curr_x, curr_y, curr_idx, x_dir, y_dir)
    # Base case -- we finished the word yay!
    return true if word.length === curr_idx

    # This is not the word we're looking for.
    return false if self.get(curr_x, curr_y) != word[curr_idx]

    # Keep going and increment the character index
    self.found_word(word, curr_x + x_dir, curr_y + y_dir, curr_idx + 1, x_dir, y_dir)
  end

  # In part 2, we only have a specific set of valid char sequences on the outside of the "X".
  # We can check the central letter and then go around the corners to verify the sequence.
  def found_mas_at_center(x, y)
    return false if grid.get(x, y) != "A"
    return false if x == 0 || y == 0 || x == self.num_cols-1 || y == self.num_rows-1

    seq = PART_2_CORNERS.map do |corner|
      self.get(x + corner[:x], y + corner[:y])
    end.join("")

    PART_2_VALID_SEQUENCES.include?(seq)
  end
end

def input
  lines = File.readlines('./input/day_04.txt')
  grid ||= Grid.new(lines.length, lines[0].strip.length)

  lines.each_with_index do |line, y_idx|
    line.strip.chars.each_with_index do |c, x_idx|
      grid.set(x_idx, y_idx, c)
    end
  end

  grid
end

def ans(part1 = true)
  grid = input
  count = 0

  for y in 0...grid.num_rows
    for x in 0...grid.num_cols
       count += grid.get_word_count(x, y, "XMAS") if part1
       count += 1 if !part1 && grid.found_mas_at_center(x, y)
    end
  end

  count
end

p ans(true)
p ans(false)