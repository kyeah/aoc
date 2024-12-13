require "./lib/grid"

# a * self.a.dx + b * self.b.dx = self.prize.x
# a * self.a.dy + b * self.b.dy = self.prize.y

# Using pairwise linear equations to solve for a and b lol
# This feels like matrix math but whatever
#
# [a*self.a.dx b*self.b.dx] = [self.prize.x]
# [a*self.a.dy b*self.b.dy] = [self.prize.y]

# a = (self.prize.x - b*self.b.dx) / self.a.dx # needs to be int
# a = (self.prize.y - b*self.b.dy) / self.a.dy # needs to be int

# self.a.dy*self.prize.x - self.a.dy*b*self.b.dx = self.a.dx*self.prize.y - self.a.dx*b*self.b.dy
# self.a.dy*self.prize.x - self.a.dx*self.prize.y = b*(self.a.dy*b*self.b.dx - self.a.dx*b*self.b.dy)

# b = (self.prize.x - a*self.a.dx) / self.b.dx # needs to be int
# b = (self.prize.y - a*self.a.dy) / self.b.dy # needs to be int

# (self.b.dy)*self.prize.x - self.b.dy*a*self.a.dx = (self.b.dx)*self.prize.y - self.b.dx*a*self.a.dy
# blah1 - a*blah2 = blah3 - a*blah4
# blah1 - blah3 = a*(blah2 - blah4)

# (self.b.dy)*self.prize.x -  (self.b.dx)*self.prize.y = a*(self.b.dy*a*self.a.dx - self.b.dx*a*self.a.dy)

# b = self.a.dy*self.prize.x - self.a.dx*self.prize.y / (self.a.dy*self.b.dx - self.a.dx*self.b.dy)
# a = (self.b.dy)*self.prize.x -  (self.b.dx)*self.prize.y / (self.b.dy*self.a.dx - self.b.dx*self.a.dy)

# gonna leave my giant scratch pad here hahahaha

class Button < Struct.new(:dx, :dy); end
class Result < Struct.new(:a, :b, :tokens); end

class Machine < Struct.new(:a, :b, :prize)
  def solve
    a_coeff = (self.b.dy)*self.prize.x -  (self.b.dx)*self.prize.y
    a_denom = self.b.dy*self.a.dx - self.b.dx*self.a.dy

    b_coeff = self.a.dy*self.prize.x - self.a.dx*self.prize.y
    b_denom = self.a.dy*self.b.dx - self.a.dx*self.b.dy

    if a_coeff%a_denom == 0
      a = a_coeff / a_denom
      b = b_coeff / b_denom
      return Result.new(a, b, 3*a + b).tokens
    end

    nil
  end
end

def input(filename, prize_offset = 0)
  machines = [Machine.new]

  File.readlines(filename).map(&:strip).each do |line|
    curr_machine = machines[machines.length - 1]
    if line.strip.length == 0
      machines.append(Machine.new)
      next
    end
    
    a, b = line.match(/(\d+), ..(\d+)/).captures.map{|x| Integer(x)}

    if line.start_with?("Button A")
      curr_machine.a = Button.new(a , b)
    elsif line.start_with?("Button B")
      curr_machine.b = Button.new(a , b)
    elsif line.start_with?("Prize")
      curr_machine.prize = Pos.new(a + prize_offset, b + prize_offset)
    else
      raise ArgumentErorr.new("huhhh")
    end
  end

  machines
end

def ans(filename, offset = 0)
  machines = input(filename, offset)
  machines.reduce(0) do |accum, machine|
    accum + (machine.solve || 0)
  end
end

pp ans("./examples/day_13.txt")
pp ans("./input/day_13.txt")
pp ans("./examples/day_13.txt", 10000000000000)
pp ans("./input/day_13.txt", 10000000000000)