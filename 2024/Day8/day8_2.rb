require 'debug'
require 'set'

@puzzle_map = File.readlines('./2024/Day8/test')

antennas = Hash.new { |h,k| h[k] = [] }
antinodes = Set.new

def within_bounds(p)
  c, r = p
  edges = { c: @puzzle_map[0].chomp.size, r: @puzzle_map.size }

  0 <= c && c < edges[:c] && 0 <= r && r < edges[:r]
end

# generates 0, 1 or 2 antinodes
def generate_antinodes(d, e) # [c, r], [c, r]
  d, e = [d, e].sort
  diff = [e[0] - d[0], e[1] - d[1]]

  r = []

  r << d
  t = d
  while within_bounds([t[0] - diff[0], t[1] - diff[1]])
    r << [t[0] - diff[0], t[1] - diff[1]]
    t = [t[0] - diff[0], t[1] - diff[1]]
  end

  r << e
  t = e
  while within_bounds([t[0] + diff[0], t[1] + diff[1]])
    r << [t[0] + diff[0], t[1] + diff[1]]
    t = [t[0] + diff[0], t[1] + diff[1]]
  end
  
  r
end


@puzzle_map.each_with_index do |row, r|
  row.chomp.each_char.with_index do |cel, c|
    if cel != '.' && cel != '#'
      antennas[cel] << [c, r]
    end
  end
end

antennas.each do |_, locations|
  locations.combination(2).each do |l1, l2|
    generate_antinodes(l1, l2).each do |antinode|
      # p [l1, l2, antinode]
      antinodes << antinode
    end
  end
end

puts antinodes.size # 1174