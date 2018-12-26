require 'set'

FNS = {
  addr: lambda { |regs, a, b, c| regs[c] = regs[a] + regs[b] },
  addi: lambda { |regs, a, b, c| regs[c] = regs[a] + b },
  mulr: lambda { |regs, a, b, c| regs[c] = regs[a] * regs[b] },
  muli: lambda { |regs, a, b, c| regs[c] = regs[a] * b },
  banr: lambda { |regs, a, b, c| regs[c] = regs[a] & regs[b] },
  bani: lambda { |regs, a, b, c| regs[c] = regs[a] & b },
  borr: lambda { |regs, a, b, c| regs[c] = regs[a] | regs[b] },
  bori: lambda { |regs, a, b, c| regs[c] = regs[a] | b },
  setr: lambda { |regs, a, b, c| regs[c] = regs[a] },
  seti: lambda { |regs, a, b, c| regs[c] = a },
  gtir: lambda { |regs, a, b, c| regs[c] = (a > regs[b] ? 1 : 0) },
  gtri: lambda { |regs, a, b, c| regs[c] = (regs[a] > b ? 1 : 0) },
  gtrr: lambda { |regs, a, b, c| regs[c] = (regs[a] > regs[b] ? 1 : 0) },
  eqir: lambda { |regs, a, b, c| regs[c] = (a == regs[b] ? 1 : 0) },
  eqri: lambda { |regs, a, b, c| regs[c] = (regs[a] == b ? 1 : 0) },
  eqrr: lambda { |regs, a, b, c| regs[c] = (regs[a] == regs[b] ? 1 : 0) }
}

class Sample < Struct.new(:before, :opcode, :args, :after)
end

def get_samples
  empty_lines = 0
  samples = []
  instructions = []

  before = after = opcode = args = nil
  reading_samples = true
  File.readlines('./res/day_16.txt').each do |line|
    if line.strip.length == 0
      if empty_lines >= 1
        reading_samples = false
      end
      empty_lines += 1
      next
    end

    if reading_samples
      empty_lines = 0
      if line.start_with?('Before: ')
        before = line.sub('Before: ', '').tr('[]', '').strip.split(',').map(&:to_i)
      elsif line.start_with?('After: ')
        after = line.sub('After: ', '').tr('[]', '').strip.split(',').map(&:to_i)
        samples.push(Sample.new(before, opcode, args, after))
        before = after = opcode = args = nil      
      else
        split = line.split.map(&:to_i)
        opcode = split.shift
        args = split
      end
    else
      instructions.push(line.split.map(&:to_i))
    end
  end

  [samples, instructions]
end

def p1
  samples, _ = get_samples
  samples.select do |sample|
    FNS.select do |name, fn|
      regs = sample.before.clone
      fn.call(regs, *sample.args)
      regs == sample.after
    end.length >= 3
  end.length
end

def p2
  possible_fns = (0...16).map{|k| [k, FNS.keys.to_set]}.to_h
  samples, instructions = get_samples

  samples.each do |sample|
    possible_fn_names = FNS.select do |name, fn|
      regs = sample.before.clone
      fn.call(regs, *sample.args)
      regs == sample.after
    end.map{|k,v| k}

    if possible_fns[sample.opcode].length != 1
      possible_fns[sample.opcode] = possible_fns[sample.opcode].intersection(possible_fn_names)
    end
  end

  while !possible_fns.values.all?{|s| s.length == 1}
    finished = possible_fns.values.select{|s| s.length == 1}.map(&:first)
    possible_fns.values.select{|s| s.length > 1}.each{|s| finished.each{|f| s.delete(f)}}
  end

  opcode_mapping = possible_fns.map{|k,v| [k, v.first]}.to_h
  regs = [0,0,0,0]

  instructions.each do |args|
    opcode = args.shift
    fn = FNS[opcode_mapping[opcode]]
    fn.call(regs, *args)
  end

  regs
end

#puts p1
puts p2.inspect
