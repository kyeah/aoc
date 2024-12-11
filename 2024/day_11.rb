class CacheVal < Struct.new(:head, :blinks); end

class Stone < Struct.new(:val, :prev, :next, :blinks)
  def advanceto!(blink)
    split = false

    if self.val == "0"
      self.val = "1"
    elsif self.val.length % 2 == 0
      self.split!
      split = true
    else
      self.val = (Integer(self.val) * 2024).to_s
    end

    self.blinks += 1
    split ? self.next.next : self.next
  end

  def split!
    left = self.val[0...self.val.length/2].to_i.to_s
    right = self.val[self.val.length/2..].to_i.to_s
    right_stone = Stone.new(right, self, self.next, self.blinks + 1)

    self.val = left
    self.next.prev = right_stone if self.next
    self.next = right_stone
  end

  def to_s
    node = self
    s = ""

    while node != nil
      s += " #{node.val}"
      node = node.next
    end

    s
  end

  def length
    node = self
    count = 0

    while node != nil
      count += 1
      node = node.next
    end

    count
  end
end

def input(filename)
  stones = []
  File.read(filename).strip.split(" ").each_with_index do |v, idx|
    prev_stone = stones[idx - 1]
    stone = Stone.new(v, prev_stone, nil, 0)
    prev_stone.next = stone if prev_stone != nil
    stones.append(stone)
  end

  stones[0]
end

def part1(filename, blinks)
  # The algorithm appears to be designed to be efficient as a DP problem -- given the same number e.g. 17, 
  # 1. The result is not dependent on any of the other surrounding numbers
  # 2. The result will always be the same after X blinks
  #
  # Therefore, we can take each number and calculate as a DFS.
  head = input(filename)
  for blink_num in 0...blinks
    node = head
    node = node.advance! while node != nil
  end

  p head.length
end

def part2(filename, blinks)
  cache = {}
end

def update_cache(head, blinks, cache)
  start_blink = 0
  root_val = head.val
  cacheval = cache[root_val]

  if cacheval
    head = cacheval.head
    start_blink = cacheval.blinks
  end

  head.prev = nil
  head.next = nil

  node = head
  for blink_num in start_blink...blinks
    while node != nil
      curr_val = node.val
      next_node = node.advance!

      cached_val = cache[curr_val]

      if cached_val == nil || cached_val.blinks < 
      if blink_num > cache[curr_val]
      cache[curr_val] = CacheVal.new()
  end

  cache[root_val] 
end

# part1("./examples/day_11.txt", 25)
part1("./input/day_11.txt", 75)