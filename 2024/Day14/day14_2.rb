require 'debug'
# require 'set'
# require 'algorithms'
# include Containers 
require 'bigdecimal'
@lines = File.readlines('./2024/Day14/input').map(&:strip)

test = false
height = test ? 7 : 103
width = test ? 11 : 101

def increment_position(duration,poz_x, poz_y, vel_x, vel_y, width, height)
  poz_x = (poz_x + vel_x * duration) % width
  poz_y = (poz_y + vel_y * duration) % height  

  [poz_x, poz_y]
end

def display_points(points, width, height)
  outputs = ('.' * width + "\n") * height
  points.each do |poz_x, poz_y|
    outputs[poz_y * (width + 1) + poz_x] = '#'
  end
  outputs
end

points = []
line = '#' * 8 # outputing to png would also have worked here.

@lines.each do |line|
  poz, vel = line.split(' ')
  
  poz_x, poz_y = poz.scan(/p=(\d+),(\d+)/).first.map(&:to_i)
  vel_x, vel_y = vel.scan(/v=(-?\d+),(-?\d+)/).first.map(&:to_i)

  points << [poz_x, poz_y, vel_x, vel_y]
end

10000.times do |duration| 
  new_map = []
  points.each do |poz_x, poz_y, vel_x, vel_y|
    poz_x, poz_y = increment_position(duration, poz_x, poz_y, vel_x, vel_y, width, height)

    new_map << [poz_x, poz_y]
  end

  map = display_points(new_map, width, height)
  if map.index(line)
    puts map
    puts duration
    break
  end
end
