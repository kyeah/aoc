class Password < Struct.new(:min, :max, :letter, :password)
  def count
    self.password.count(self.letter)
  end
  
  def valid1
    self.min <= count && count <= self.max
  end

  def valid2
    (self.password[self.min - 1] == self.letter) ^ (self.password[self.max - 1] == self.letter)
  end
end

def input
  File.readlines('./res/day_02.txt').map do |x|
    parts = x.split(' ')
    minmax = parts[0].split('-').map{|x| Integer(x)}
    Password.new(minmax[0], minmax[1], parts[1][0], parts[2])
  end
end

def p1
  input.select{|pw| pw.valid1()}.length
end

def p2
  input.select{|pw| pw.valid2()}.length
end

puts p1
puts p2
