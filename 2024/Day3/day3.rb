require 'debug'

input_lines = File.readlines('./2024/Day3/input')


r = 0

input_lines.each do |line|
  line
    .scan(/mul\((\d+),(\d+)\)/)
    .each { |a, b| r += a.to_i * b.to_i  }
 

end

p r