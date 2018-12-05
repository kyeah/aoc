def input
  File.read('./res/day_05.txt').chomp
end

def react!(s)
  i = 0
  while s[i+1]
    if s[i] != s[i+1] && s[i].upcase == s[i+1].upcase
      s.delete_at(i)
      s.delete_at(i)
      i -= 1
    else
      i += 1
    end
  end
  s
end

def p1
  react!(input.chars).length
end

def p2
  ('a'..'z').map do |unit|
    [unit, react!(input.tr(unit, '').tr(unit.capitalize, '').chars).length]
  end.min_by{|arr| arr[1]}
end

puts p1
puts p2
