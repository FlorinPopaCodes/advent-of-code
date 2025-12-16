require 'debug'

input_lines = File.readlines('./2024/Day3/input')


r = 0
add = true

input_lines.each do |line|
  line
    .scan(/mul\((\d+),(\d+)\)|(don\'t|do)/)
    .each do |a, b, action|
      add = true if action == "do"
      add = false if action == "don't"
      next if action

      r += a.to_i * b.to_i if add
     end
end

p r