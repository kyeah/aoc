def input
  list1, list2 = [], []
  File.readlines('./input/day_01.txt').reduce([[], []]) do |lists, v| 
    val1, val2 = v.split(" ")
    lists[0].append(Integer(val1))
    lists[1].append(Integer(val2))
    lists
  end
end

# Note: performance complexity of sorting at the end is O(nlogn) or O(n^2) in the worst case.
#       this is usually better than trying to insert one at a time into a complex sorted structure, which
#       is the same performance complexity but may require additional space.
def part1
  lists = input
  lists[0].sort!
  lists[1].sort!

  sorted_pairs = lists[0].zip(lists[1])

  sorted_pairs.reduce(0) do |sum, vals|
    sum + (vals[0] - vals[1]).abs
  end
end

# Maintain two hashmaps that count the number of occurrences of each value
# This is O(n) insertion + O(n) calculation so O(n) performance and space complexity overall.
def input_p2
  list1, list2 = {}, {}

  File.readlines('./input/day_01.txt').each do |v| 
    val1, val2 = v.split(" ").map{|v| Integer(v)}
    list1[val1] ||= 0
    list1[val1] += 1

    list2[val2] ||= 0
    list2[val2] += 1
  end

  return list1, list2
end

def part2
  list1, list2 = input_p2

  score = 0
  list1.each do |val, occurrences|
    score += occurrences * val * (list2[val] || 0)
  end

  score
end

p part2