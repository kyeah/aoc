val = input.lines.map{ |line| line.split('-')}.inject(0) do |sum, line|
  id_s, checksum = line.pop.split("[")
  name = line.join
  id = Integer(id_s)
  checksum = checksum[0...5].split("")
  
  chars = name
    .split("")
    .group_by{|c| c}
    .to_h
    .sort_by{ |k,v| [v.size, -k.ord] }
    .map{ |k,_| k }
    .reverse
    .first(5)
  
  if (chars - checksum).empty?
    sum + id
  else
    sum
  end
end

puts val

def rotate(c, len)
  start = 'a'.ord
  (start + ((c.ord - start + len) % 26)).chr
end

names = input.lines.map{ |line| line.split('-')}.map do |line|
  id = Integer(line.pop.split("[").first)  
  name = line.map do |word|
    word
      .split("")
      .map{ |c| rotate(c, id) }
      .join
  end.join("-")
  
  "#{id} - #{name}"
end

puts names.select{ |name| name.include?("north") }
