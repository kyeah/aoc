class Point < Struct.new(:x, :y, :vx, :vy)
  def step
    self.x += vx
    self.y += vy
  end

  def backstep
    self.x -= vx
    self.y -= vy
  end
end

class Skybox < Struct.new(:points, :xmin, :xmax, :ymin, :ymax, :pxmin, :pymin, :pxmax, :pymax)
  def converging?
    (self.pxmax - self.pxmin) > (self.xmax - self.xmin) &&
      (self.pymax - self.pymin) > (self.ymax - self.ymin)
  end

  def step
    self.points.map(&:step)
    self.pxmin, self.pxmax, self.pymin, self.pymax = self.xmin, self.xmax, self.ymin, self.ymax
    self.xmin, self.xmax = self.points.map(&:x).min, self.points.map(&:x).max
    self.ymin, self.ymax = self.points.map(&:y).min, self.points.map(&:y).max
  end

  def print
    (self.ymin..self.ymax).each do |y|
      s = (self.xmin..self.xmax).map do |x|
        if self.points.find{|p| p.x == x && p.y == y}
          '#'
        else
          '.'
        end
      end.join
      puts s
    end
  end
end

def input
  File.readlines('./res/day_10.txt').map do |line|
    matches = line.scan(/<([\-\d, ]*)>/).flatten
    args = matches.map{|m| m.split(',').map(&:to_i)}.flatten
    Point.new(*args)
  end
end

def p1  
  skybox = Skybox.new(input, *Array.new(8, nil))
  2.times{ skybox.step }
  steps = 2

  while skybox.converging?
    skybox.step
    steps += 1
  end

  skybox.points.each(&:backstep)
  steps -= 1
  skybox.print
  puts steps
end

p1

