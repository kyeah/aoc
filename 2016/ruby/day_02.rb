class Point
  attr_accessor :x
  attr_accessor :y
  attr_reader :use_new_pad

  def initialize(x, y, part2: false)
    @x = x
    @y = y
    @use_new_pad = part2
  end
  
  KEYPAD = [
    [1,2,3].freeze,
    [4,5,6].freeze,
    [7,8,9].freeze
  ].freeze
  
  NEW_KEYPAD = [
    [nil, nil, 1, nil, nil],
    [nil, 2, 3, 4, nil],
    [5,6,7,8,9],
    [nil, 'A','B','C', nil],
    [nil, nil, 'D', nil, nil],
  ].freeze
  
  def pad
    use_new_pad ? NEW_KEYPAD : KEYPAD
  end

  def U
    @y -= 1 if y > 0 && pad[y-1][x] != nil
  end

  def D
    @y += 1 if y < pad.size - 1 && pad[y+1][x] != nil
  end

  def L
    @x -= 1 if x > 0 && pad[y][x-1] != nil
  end

  def R
    @x += 1 if x < pad.size - 1 && pad[y][x+1] != nil
  end

  def key
    pad[y][x]
  end
  
  def runkeys!(input)
    input.lines.map do |line|
      line.chomp.split("").each{ |c| send(c) }
      key
    end
  end
end

key1 = Point.new(1,1).runkeys!(input)
puts "part1: #{key1}"

key2 = Point.new(0, 2, part2: true).runkeys!(input)
puts "part2: #{key2}"
