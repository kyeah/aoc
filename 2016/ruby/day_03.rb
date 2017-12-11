def lens(line)
  line.split(" ").map{ |c| Integer(c) }
end

def valid_triangle?(lens)
  [[0,1,2], [1,2,0], [0,2,1]].all? do |a, b, c|
    lens[a] + lens[b] > lens[c]
  end
end

key_1 = input.lines
  .select do |line|
    valid_triangle?(lens(line))
  end
  .size

puts "part 1: #{key_1}"

key_2 = input.lines
  .each_slice(3)
  .map do |lines|
    lines
      .map{ |line| lens(line) }
      .transpose
      .select{ |lens| valid_triangle?(lens) }
      .size
  end
  .inject(0) { |agg, v| agg + v }

puts "part 2: #{key_2}"
