require 'debug'
# require 'set'
# require 'algorithms'
# include Containers 
require 'bigdecimal'
@lines = File.readlines('./2024/Day14/input').map(&:strip)

duration = 100
test = false
height = test ? 7 : 103
width = test ? 11 : 101

q1 = 0
q2 = 0
q3 = 0
q4 = 0

@lines.each do |line|
  poz, vel = line.split(' ')
  
  poz_x, poz_y = poz.scan(/p=(\d+),(\d+)/).first.map(&:to_i)
  vel_x, vel_y = vel.scan(/v=(-?\d+),(-?\d+)/).first.map(&:to_i)

  poz_x = (poz_x + vel_x * duration) % width
  poz_y = (poz_y + vel_y * duration) % height  

  next if poz_y == height / 2 || poz_x == width / 2
  if poz_y < height / 2
    if poz_x < width / 2
      q1 += 1
    else
      q2 += 1
    end
  elsif poz_y > height / 2
    if poz_x < width / 2
      q3 += 1
    else
      q4 += 1
    end
  end
end

puts "Q1: #{q1}"
puts "Q2: #{q2}"
puts "Q3: #{q3}"
puts "Q4: #{q4}"
puts "Safety factor: #{q1 * q2 * q3 * q4}"
