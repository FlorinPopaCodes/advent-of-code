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


seeds.each_with_index do |_seed, index|
  dictionary.each do |batch|
    _, offset = batch.find { |k,v| k.include? seeds[index] }

    next unless offset
    p offset

    seeds[index] += offset
    p "#{index}: #{seeds[index]}"
  end
end

p seeds
p seeds.min

