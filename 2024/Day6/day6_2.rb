require 'debug'

puzzle_map = File.readlines('./2024/Day6/input')

guard_position = nil

WIDTH = puzzle_map[0].size
HEIGHT = puzzle_map.size

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

# TODO: modify functional graph and check for loops
def check_loop(grid, gc, gr)
  dc = 0
  dr = -1

  visited = Set.new

  while true
    visited.add("#{gc}x#{gr}x#{dc}x#{dr}")
    return false unless 0 <= gc + dc && gc + dc < WIDTH && 0 <= gr + dr && gr + dr < HEIGHT
  
    if grid[gr + dr][gc + dc] == '#'
      dc, dr = -dr, dc
    else
      gc, gr = gc + dc, gr + dr
    end

    if visited.include?("#{gc}x#{gr}x#{dc}x#{dr}")
      return true
    end
  end
end


def initial_path(grid, gc, gr)
  path = Set.new

  dc = 0
  dr = -1

  while true
    path.add("#{gc}x#{gr}")
    break unless 0 <= gc + dc && gc + dc < WIDTH && 0 <= gr + dr && gr + dr < HEIGHT

    if grid[gr + dr][gc + dc] == '#'
      dc, dr = -dr, dc
    else
      gc, gr = gc + dc, gr + dr
    end
  end

  path
end

# TODO: create functional graph
path = initial_path(puzzle_map, guard_position[:c], guard_position[:r])

loops = 0

WIDTH.times do |cc|
  HEIGHT.times do |cr|
    next unless path.include?("#{cc}x#{cr}")

    puzzle_map[cr][cc] = '#'
    loops += 1 if check_loop(puzzle_map, guard_position[:c], guard_position[:r])
    puzzle_map[cr][cc] = '.'
  end
end

p loops
