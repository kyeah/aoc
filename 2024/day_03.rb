def input
  list1, list2 = [], []
  File.read('./input/day_03.txt')
end

def part1
  matches = input.scan(/mul\(\d{1,3},\d{1,3}\)/)
  matches.reduce(0) do |accum, match|
    captures = parse_mult(match)
    return accum if !captures

    accum + captures.reduce(1, :*)
  end
end

def part2
  r_do = "do\\\(\\\)"
  r_dont = "don't\\\(\\\)"
  r_mul = "mul\\\(\\\d{1,3},\\\d{1,3}\\\)"

  r = /(#{r_do}|#{r_dont}|#{r_mul})/
  matches = input.scan(r)

  enabled = true
  matches.reduce(0) do |accum, match|
    if match[0] == "do()"
      enabled = true
      next accum
    elsif match[0] == "don't()"
      enabled = false
      next accum
    elsif !enabled
      next accum
    end

    captures = parse_mult(match[0])
    next accum if !captures

    accum + captures.reduce(1, :*)
  end
end

def parse_mult(s)
  match = s.match(/mul\((\d{1,3}),(\d{1,3})\)/)
  return nil if !match
  match.captures.map{|x| Integer(x)}
end

p part1
p part2