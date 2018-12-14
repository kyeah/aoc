class Rule < Struct.new(:state, :next_state)
end

class State < Struct.new(:pots, :rules, :generation)
  def start_num
    self.generation * -10
  end

  def sum
    n = self.start_num
    self.pots.sum do |p|
      ans = p ? n : 0
      n += 1
      if ans
        p n
      end
      ans
    end
  end

  def step
    horizon = 10
    states = [*Array.new(horizon){ false }, *self.pots, *Array.new(horizon){ false }].each_cons(5).map do |cons|
      rules[cons] || false
    end
    self.pots = [*Array.new(2){ false }, *states, *Array.new(2){ false }]
    self.generation += 1
  end
end

def input
  lines = File.readlines('./res/day_12.txt')
  initial_state = lines.shift.split(' ')[2].chars.map{|c| c == '#'}
  lines.shift
  rules = lines.map do |line|
    state, next_state = line.split(' => ').map(&:chomp)
    [state.chars.map{|c| c== '#'}, next_state == '#']
  end.to_h

  State.new(pots = initial_state, rules = rules, generation = 0)
end

def p1
  state = input
  20.times{ state.step }
  state.sum
end

puts p1

