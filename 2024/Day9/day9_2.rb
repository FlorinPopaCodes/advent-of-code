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
numbers = [] # we need to loop in reverse
spaces = []

line.size.times do |bpx|
  start = final_map.size

  if bpx % 2 == 0 # old blocks 
    line[bpx].to_i.times do |c|
      final_map << idx
    end
    numbers << { id: idx, size: line[bpx].to_i, start:, end: final_map.size - 1 }

    idx = idx.succ
  else # spaces
    line[bpx].to_i.times do |c|
      final_map << nil
    end
    spaces << { size: line[bpx].to_i, start:, end: final_map.size - 1 }

  end
end


numbers.reverse.each do |n|
  s_idx = spaces.index { |s| s[:end] < n[:start] && s[:size] >= n[:size] } # bsearch_index
  next unless s_idx
  s = spaces[s_idx]
  next unless s

  final_map.fill nil, n[:start], n[:size]
  final_map.fill n[:id], s[:start], n[:size] 

  if s[:size] == n[:size]
    spaces.delete_at(s_idx)
  else
    spaces[s_idx] = { size: s[:size] - n[:size], start: s[:start] + n[:size], end: s[:end] }
  end

  n_idx = spaces.bsearch_index { |s| s[:start] < n[:start] }
  next unless n_idx
  spaces.insert(n_idx, { size: n[:size], start: n[:start], end: n[:end] })
end

checksum = 0 

final_map.each_with_index { |block, i| block ? checksum += block * i : nil }

p checksum