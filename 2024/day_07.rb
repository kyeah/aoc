OPS = [
  lambda{|a, b| a + b},
  lambda{|a, b| a * b},
  lambda{|a, b| Integer("#{a}#{b}")}, # remove dis for part 1
]

class CalibrationTest < Struct.new(:goal, :values)
  def is_valid
    perms = OPS.repeated_permutation(values.length - 1).to_a
    perms.any? do |seq|
      res = values.each_with_index.reduce do |(accum, idx0), (v, idx1)|
        [seq[idx0].call(accum, v), idx1]
      end

      goal == res[0]
    end
  end
end

def input
  File.readlines("./input/day_07.txt").map(&:strip).map do |line|
    goal, rest = line.split(":")
    values = rest.split(" ").compact.map{|x| Integer(x)}
    CalibrationTest.new(Integer(goal), values)
  end
end

def ans
  calibrations = input
  calibrations.filter(&:is_valid).reduce(0) do |accum, cal|
    accum + cal.goal
  end
end

p ans