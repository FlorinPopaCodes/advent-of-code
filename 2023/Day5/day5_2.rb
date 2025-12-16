require 'debug'

lines = File.read(%(2023/Day5/input))

# Destination, Source, Range Length
# Unmapped correspond to the same number
# 
# Result is the lowest location  number that corresponds to any of the initial seeds
seeds, *rest = lines.split("\n\n")

seeds = seeds.split(" ")[1..].map(&:to_i)
rest = rest.map do |r|
  r.split("\n")[1..].map(&:split).map { _1.map(&:to_i) }
end 

dictionary = [] # [{}]

rest.each_with_index do |map, idx|
  dictionary[idx] ||= {}

  map.each do |m|
    dictionary[idx][Range.new(m[1], m[1] + m[2])] = m[0] - m[1]
  end

end

dictionary.each do |batch|

  seeds.each_slice(2) do |range_start, length|
    ranges = [ range_start..(range_start+length) ]


    overlaps = batch.select { |k,v| k.overlap?(range_start..range_end)}

    binding.break

    next unless offset

    item += offset
  end

end

p results.min


