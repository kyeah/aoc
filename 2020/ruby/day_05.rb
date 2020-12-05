class PP < Struct.new(:s, :row, :col, :id); end

def parse(s, l1, l2)
  min, max = 0, 2**s.length - 1

  s.chars().each do |cmd|
    diff = ((max - min) / 2.0).ceil()
    if cmd == l1
      max = max - diff
    else
      min = min + diff
    end
  end

  return min
end

def input
  File.readlines('./res/day_05.txt').map do |val|
    val.strip!()
    row = parse(val[0, 7], "F", "B")
    col = parse(val[-3, 3], "L", "R")
    id = 8*row + col
    PP.new(val, row, col, id)
  end.map(&:id)
end

def p1
  input.max
end

def p2
  ids = input.sort
  for i in 1...ids.length do
    return i if ids[i] - ids[i-1] > 1
  end
end

puts p1
puts p2
