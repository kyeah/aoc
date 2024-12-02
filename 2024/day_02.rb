def input
  list1, list2 = [], []
  File.readlines('./input/day_02.txt').map do |line| 
    line.split(" ").map{|val| Integer(val)}
  end
end

def part1
  input.reduce(0) do |safe_count, report|
    safe_count += 1 if is_safe_report(report)
    safe_count
  end
end

def is_safe_report(report, skip_idx = -1)
  safe = true

  idx0 = skip_idx == 0 ? 1 : 0
  idx1 = (skip_idx != 0 && skip_idx != 1) ? 1 : 2
  is_increasing = (report[idx1] - report[idx0]) > 0

  prev_val = report[idx0]

  report.each_with_index do |val, idx|
    next if skip_idx == idx || idx == idx0
    diff = val - prev_val

    if diff == 0 || diff.abs > 3 || (is_increasing && diff < 0) || (!is_increasing && diff > 0)
      safe = false
      break
    end

    prev_val = val
  end

  safe
end

p part1

# This is a very not-efficient way to do this
def part2
  input.reduce(0) do |safe_count, report|
    for counter in -1..report.length
      if is_safe_report(report, counter)
        safe_count += 1
        break
      end
    end
    safe_count
  end
end

p part2