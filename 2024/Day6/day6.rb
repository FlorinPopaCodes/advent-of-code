require 'debug'

puzzle_map = File.readlines('./2024/Day6/input')

guard_position = nil
visited = Set.new

width = puzzle_map[0].size
height = puzzle_map.size

# People decouple input parsing from the problem solving.
puzzle_map.each_with_index do |row, r|
  break if guard_position 

  row.each_char.with_index do |cel, c|
    if cel == '^'
      guard_position = { c:, r: }
      guard_direction = :up
      break
    end
  end
end

dc = 0
dr = -1

# I could either or each loop.
while true
  visited.add("#{guard_position[:c]}x#{guard_position[:r]}")
  break unless 0 <= guard_position[:c] + dc && guard_position[:c] + dc < width && 0 <= guard_position[:r] + dr && guard_position[:r] + dr < height

  if puzzle_map[guard_position[:r] + dr][guard_position[:c] + dc] != '#'
    guard_position[:c] = guard_position[:c] + dc
    guard_position[:r] = guard_position[:r] + dr
  else
    dc, dr = -dr, dc
  end
end

p visited.size # 4663