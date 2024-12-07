# Define a custom structure for comparing values based on the provided rules.
class Val < Struct.new(:processor, :val)
  def <=> (other)
    compare(self.processor, self.val, other.val, [])
  end
end

# Recursive comparison function based on the processed input. YOLO and hope it doesn't blow up.
def compare(processor, val, other, seen)
  return 0 if seen.include?(val) || seen.include?(other)
  seen = [*seen, val, other].uniq

  must_come_before = processor.invalid_orders[val]
  must_come_after = processor.valid_orders[val]

  is_lower = must_come_after.any? do |val_after|
    val_after == other || compare(processor, val_after, other, seen) == -1
  end

  return -1 if is_lower

  is_higher = must_come_before.any? do |val_before|
    val_before == other || compare(processor, val_before, other, seen) == 1
  end

  return 1 if is_higher
  
  puts "I have no idea"
  0
end

class InvalidPair < Struct.new(:seen_idx, :seen_val, :val, :idx); end
class Processor < Struct.new(:valid_orders, :invalid_orders, :updates)
  def self.fromFile(filename)
    p = Processor.new({}, {}, [])
    lines = File.readlines(filename).map(&:strip)

    lines.each do |line|
      matches = line.match(/(\d+)\|(\d+)/)
      if matches != nil
        # Parse rule
        a, b = matches.captures.map{|x| Integer(x)}
        p.valid_orders[a] ||= []
        p.valid_orders[a].append(b)
        p.invalid_orders[b] ||= []
        p.invalid_orders[b].append(a)
      else
        # Parse update
        update = line.split(",").map{|x| Integer(x)}
        p.updates.append(update) if update.length > 0
      end
    end

    p
  end
  
  def is_valid(update)
    seen = Set.new
      
    update.all? do |val|
      ok = seen.none? do |seen_val|
        self.invalid_orders[seen_val].include?(val)
      end
  
      seen.add(val)
      ok
    end
  end
end

def part1
  processor = Processor.fromFile('./input/day_05.txt')
  valid_updates = processor.updates.filter do |update|
    processor.is_valid(update)
  end

  calc_sum(valid_updates)
end

def part2
  processor = Processor.fromFile('./input/day_05.txt')
  invalid_updates = processor.updates.filter do |update|
    !processor.is_valid(update)
  end

  # sort those bad bois
  new_updates = invalid_updates.map do |update|
    update.map{|v| Val.new(processor, v)}.sort.map{|v| v.val}
  end

  calc_sum(new_updates)
end

def calc_sum(updates)
  updates.reduce(0) do |accum, update|
    accum + update[(update.length - 1) / 2]
  end
end

p part1
p part2