def input
  File.readlines('./res/day_02.txt').map(&:chomp)
end

def has_char_count(n)
  input.select do |line|
    line.chars.find{ |c| line.count(c) == n }
  end
end

def p1
  has_char_count(2).count * has_char_count(3).count
end

def common_chars(a,b)
  a.chars.zip(b.chars).
    select{ |c1, c2| c1 == c2 }.
    map{ |c1, c2| c1 }.
    join
end

def p2
  # assume everything is the same length, yolo
  len = input[0].length

  input.combination(2).
    map{ |a,b| common_chars(a,b) }.
    find{ |s| s.length == len - 1 }
end

puts p1
puts p2
