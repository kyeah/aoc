PASSWORD_PATTERN = /(\d+)-(\d+) (\w): (.*)/

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
    min, max, letter, password = PASSWORD_PATTERN.match(x).captures
    Password.new(Integer(min), Integer(max), letter, password)
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
