require 'set'

def input
  File.readlines('./res/day_01.txt').map{|x| Integer(x)}
end

def p1
  input.sum
end

def p2
  sum, seen = 0, Set[0]

  loop do
    return sum if input.find do |x|
      sum += x
      !seen.add?(sum)
    end
  end
end

puts p1
puts p2
