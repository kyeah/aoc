def input(p1 = true)
  current_group = []
  sum = 0

  start = true
  File.readlines('./res/day_06.txt').map do |x|
    if x.strip().empty?
      sum += current_group.uniq.length
      current_group = []
      start = true
    elsif p1 || start
      current_group += x.strip().chars()
      start = false
    else
      current_group = current_group & x.strip().chars()
    end
  end

  if current_group
    sum += current_group.uniq.length
  end

  sum
end

def p1
  input(true)
end

def p2
  input(false)
end

puts p1
puts p2
