mmax = 71626 * 100
nmax = 438

circle = Array.new(mmax)
circle[0] = 0

scores = Hash.new { 0 }
current = 0
count = 1

# yeah there's an easier way to do this so what
def loopdeloop(count, i)
  if i < 0
    count - (i.abs % count)
  elsif i >= count
    i % count
  else
    i
  end
end

def pcircle(circle, current)
  clone = circle.compact.clone
  clone[current] = "(#{clone[current]})"
  puts clone.join(" ")
end

def insert_idx(i1, i2, index)
  if i1 === i2
    i1 + 1
  elsif (i1 - i2).abs > 1
    [i1, i2].max + 1
  else
    [i1, i2].max
  end
end

(1..mmax).each do |m|
  puts m if m % 71626 === 0
  if m % 23 === 0
    scores[m % nmax] += m
    current = index = loopdeloop(count, current - 7)
    scores[m % nmax] += circle.delete_at(index)
    count -= 1
  else
    i1 = loopdeloop(count, current + 1)
    i2 = loopdeloop(count, current + 2)
    puts i1, i2
    current = index = insert_idx(i1, i2, index)
    circle[index] = m
    count += 1
  end
  pcircle(circle, current)
end

puts scores.max_by{|k,v| v}
