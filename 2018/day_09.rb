# Doubly-linked list oh yeaaa
class Node < Struct.new(:prev, :next, :val)
  def delete
    self.prev.next = self.next
    self.next.prev = self.prev
    self
  end
end

def have_fun(mmax, nmax)
  head = Node.new(nil, nil, 0)
  head.prev = head
  head.next = head

  scores = Hash.new { 0 }
  current = head

  def loopdeloop(current, shift)
    node = current
    shift.abs.times do
      node = node.prev if shift < 0
      node = node.next if shift > 0
    end
    node
  end

  iter = 0
  (1..mmax).each do |m|
    puts "#{iter += 1}/100" if m % 71626 === 0

    if m % 23 === 0
      scores[m % nmax] += m
      deleted_node = loopdeloop(current, -7).delete
      scores[m % nmax] += deleted_node.val
      current = deleted_node.next
    else
      n1 = loopdeloop(current, 1)
      n2 = loopdeloop(current, 2)
      n1, n2 = n2, n1 if n2.next.val === n1.val

      node = Node.new(n1, n2, m)
      n1.next = n2.prev = current = node
    end
  end

  scores.max_by{|k,v| v}[1]
end

puts have_fun(71626, 438)
puts have_fun(7162600, 438)
