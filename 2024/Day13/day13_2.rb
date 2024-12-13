require 'debug'
# require 'set'
# require 'algorithms'
# include Containers 
require 'bigdecimal'
@lines = File.readlines('./2024/Day13/input').map(&:strip)


result = 0 

@lines.each_slice(4) do |line_group|
  line_a, line_b, prize = line_group
  
  a = [:x, :y].zip(line_a.scan(/X\+(\d+), Y\+(\d+)/).first.map(&:to_i)).to_h
  b = [:x, :y].zip(line_b.scan(/X\+(\d+), Y\+(\d+)/).first.map(&:to_i)).to_h
  p = [:x, :y].zip(prize.scan(/X\=(\d+), Y\=(\d+)/).first.map(&:to_i)).to_h

  p[:x] = p[:x] + 10000000000000
  p[:y] = p[:y] + 10000000000000

  moves_b = (p[:x] * a[:y] - p[:y] * a[:x]) / (a[:y] * b[:x] - b[:y] * a[:x])
  moves_a = (p[:x] * b[:y] - p[:y] * b[:x]) / (b[:y] * a[:x] - b[:x] * a[:y])

  if a[:x] * moves_a + b[:x] * moves_b == p[:x] && a[:y] * moves_a + b[:y] * moves_b == p[:y]
    result += moves_a * 3 + moves_b 
  end
end


puts "Total fewest tokens: #{result}"

