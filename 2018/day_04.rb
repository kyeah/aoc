class LogLine < Struct.new(:event, :timestamp, :minute); end

class GuardMap
  attr_accessor :minutes

  def initialize
    @minutes = Hash.new { 0 }
  end
  
  def sleep(fell_asleep_at, woke_up_at)
    (fell_asleep_at...woke_up_at).each do |minute|
      self.minutes[minute] += 1
    end
  end

  def max_minute
    val = self.minutes.max_by{|_,v| v}
    {minute: val[0], num_times: val[1]}
  end

  def total_sleep_time
    self.minutes.values.sum
  end
end

def input
  File.readlines('./res/day_04.txt').map do |line|
    split = line.split
    LogLine.new(
      event = split[2..3].join(' '),
      timestamp = split[0..1].join(' '),
      minute = Integer(split[1][3..4], 10)
    )
  end.sort_by(&:timestamp)
end

def minutemap
  guard_id = nil
  fell_asleep_at = nil
  map = Hash.new

  for log in input
    case log.event
    when 'falls asleep'
      map[guard_id] ||= GuardMap.new
      fell_asleep_at = log.minute
    when 'wakes up'
      map[guard_id].sleep(fell_asleep_at, log.minute)
    else
      guard_id = Integer(log.event.split(' ')[1].sub('#', ''))
    end
  end

  map
end

def ans(&block)
  sleepiest_guard = minutemap.max_by{ |_,v| yield v }
  sleepiest_guard[0] * sleepiest_guard[1].max_minute[:minute]
end

def p1
  ans{ |v| v.total_sleep_time }
end

def p2
  ans{ |v| v.max_minute[:num_times] }
end

puts p1
puts p2
