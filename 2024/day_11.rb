# The algorithm appears to be designed to be efficient as a DP problem -- given the same number e.g. 17, 
# 1. The result is not dependent on any of the other surrounding numbers
# 2. The result will always be the same after X blinks
#
# Therefore, we can take each number and calculate as a DFS to build up a DP cache.
#
# Note: I initially did this with a linkedlist but that is unnecessary..........
#
CACHE = {}

def input(filename)
  File.read(filename).strip.split(" ")
end

def helper(val, blinks)
  return CACHE["#{val},#{blinks}"] if CACHE["#{val},#{blinks}"]

  if blinks == 0
    return 1
  elsif val == "0"
    v = helper("1", blinks - 1)
  elsif val.length % 2 == 0
    left = val[0...val.length/2].to_i.to_s
    right = val[val.length/2..].to_i.to_s
    v = helper(left, blinks - 1) + helper(right, blinks - 1)
  else
    v = helper((val.to_i * 2024).to_s, blinks - 1)
  end

  CACHE["#{val},#{blinks}"] = v
end

def sumall(vals, blinks)
  vals.reduce(0) do |accum, val|
    accum + helper(val, blinks)
  end
end

def part1(filename, blinks)
  vals = input(filename)
  sumall(vals, blinks)
end

p part1("./examples/day_11.txt", 25)
p part1("./input/day_11.txt", 25)
p part1("./examples/day_11.txt", 75)
p part1("./input/day_11.txt", 75)