require 'debug'
require 'set'

line = File.readlines('./2024/Day9/input').first.chomp

spaces = 0

line.size.times do |bpx|
  if bpx % 2 == 1 # spaces
    spaces += line[bpx].to_i
  end
end

idx = 0
final_map = []

line.size.times do |bpx|
  if bpx % 2 == 0 # old blocks 
    line[bpx].to_i.times do |c|
      final_map << idx
    end
    idx = idx.succ

  else # spaces
    line[bpx].to_i.times do |c|
      final_map << nil
    end
  end
end

left, right = 0, final_map.size

while true
  left += 1 while !final_map[left].nil?
  right -= 1 while final_map[right].nil?

  break if left >= right
  
  final_map[left], final_map[right] = final_map[right], final_map[left]
end

checksum = 0 

final_map.each_with_index { |block, i| block ? checksum += block * i : nil }

p checksum