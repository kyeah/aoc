RULES = {
  "byr" => lambda { |val| val.length == 4 && Integer(val) >= 1920 && Integer(val) <= 2002 },
  "iyr" => lambda { |val| val.length == 4 && Integer(val) >= 2010 && Integer(val) <= 2020 },
  "eyr" => lambda { |val| val.length == 4 && Integer(val) >= 2020 && Integer(val) <= 2030 },
  "hgt" => lambda do |val|
    return false unless matches = val.match(/(^[0-9]+)(in|cm)/)
    num, unit = matches.captures

    if unit == "in"
      Integer(num) >= 59 && Integer(num) <= 76
    else
      Integer(num) >= 150 && Integer(num) <= 193
    end
  end,
  "hcl" => lambda { |val| val.match(/^#[0-9a-f]{6}$/) },
  "ecl" => lambda { |val| ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include?(val)},
  "pid" => lambda { |val| val.match(/^[0-9]{9}$/)},
}

def helper(p1 = true)
  res = 0
  current_passport = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]

  File.readlines('./res/day_04.txt').each do |x|
    if x.strip.empty?
      if current_passport.empty?
        res += 1
      end
      current_passport = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
    else
      x.split(" ").each do |attr|
        key, val = attr.split(":")
        current_passport.delete_if {|x| x.to_s == key && (p1 ? true : RULES[key] && RULES[key].call(val)) }
      end
    end
  end
  res
end

puts helper(true)
puts helper(false)
