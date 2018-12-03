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

def p2
  input.combination(2).
    select{ |a,b| a.length == b.length }.
    map{ |a,b| a.chars.zip(b.chars) }.
    find{ |cpairs| cpairs.count{ |c1, c2| c1 != c2 } == 1 }.
    map{ |c1, c2| c1 == c2 ? c1 : '' }.
    join
end

puts p1
puts p2
