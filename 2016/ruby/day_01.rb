require 'set'
require 'ostruct'

input = File.read("../res/day_01.txt")

Struct.new("Point", :x, :y) do
  def +(other)
    Struct::Point.new(x + other.x, y + other.y)
  end
  
  def dist
    x + y
  end
end

pos = Struct::Point.new(0, 0)

DIRS = [
  DIR_UP    = Struct::Point.new(0, 1),
  DIR_RIGHT = Struct::Point.new(1, 0),
  DIR_DOWN  = Struct::Point.new(0, -1),
  DIR_LEFT  = Struct::Point.new(-1, 0),
].freeze

dir_pos = 0
seen = Set.new(pos)

for turn in input.split(", ")
  inc     = turn[0] == 'L' ? -1 : 1
  dir_pos = (dir_pos + inc) % DIRS.size
  dir     = DIRS[dir_pos]

  Integer(turn[1..-1]).times do
    pos += dir
    if seen.include?(pos)
      puts "part 2: #{pos.dist}"
    end
    seen.add(pos)
  end
end

puts "part 1: #{pos.dist}"
