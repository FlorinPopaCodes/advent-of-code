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

  moves_a = BigDecimal("Infinity")
  moves_b = BigDecimal("Infinity")

  100.times do |idx|
    pa_x = p[:x] - a[:x] * idx
    pa_y = p[:y] - a[:y] * idx

    jdx_x, pb_xmod = pa_x.divmod(b[:x])
    next if pb_xmod != 0
    jdx_y, pb_ymod = pa_y.divmod(b[:y])
    next if pb_ymod != 0
    next if jdx_x != jdx_y

    moves_a = idx if moves_a > idx
    moves_b = jdx_x if moves_b > jdx_x
  end

  next if moves_a == BigDecimal("Infinity") || moves_b == BigDecimal("Infinity")
  result += moves_a * 3 + moves_b 
end


puts "Total fewest tokens: #{result}"

