class Node < Struct.new(:score, :prev, :next)
  def backstr
    n = self
    5.times{ n = n.prev }

    s = n.score.to_s
    5.times do
      n = n.next
      s += n.score.to_s
    end
    s
  end
end

def p1(scores, a, b, n)
  while scores.length < n + 10
    val = scores[a] + scores[b]
    scores.concat(val.to_s.chars.map(&:to_i))
    a = (1 + a + scores[a]) % scores.length
    b = (1 + b + scores[b]) % scores.length
  end
  scores[n..(n+10)].join
end

def p2(tail, na, nb, n)
  length = 2
  while true
    val = na.score + nb.score

    new_scores = val.to_s.chars.map(&:to_i)
    length += new_scores.length
    
    new_scores.each do |s|
      n = Node.new(s, tail, tail.next)
      tail.next.prev = n
      tail.next = n
      n.prev = tail
      tail = n
    end

    (1 + na.score).times{ na = na.next }
    (1 + nb.score).times{ nb = nb.next }

    if (tail.prev.score === 6 || tail.prev.score === 1)
      if tail.prev.backstr == "505961"
        return length - 7
      elsif tail.backstr == "505961"
        return length - 6
      end
    end
  end
end

n7 = Node.new(7, nil)
n3 = Node.new(3, n7, n7)
n7.next = n7.prev = n3

puts p1([3,7], 0, 1, 505961)
puts p2(n7, n3, n7, 505961)
