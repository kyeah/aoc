def input
  File.readlines('./res/day_01.txt').map{|x| Integer(x)}
end

def helper(num)
  input.combination(num) do |items|
    if items.sum() == 2020
      return items.inject(:*)
    end
  end  
end

def p1
  helper(2)
end

def p2
  helper(3)
end

puts p1
puts p2
