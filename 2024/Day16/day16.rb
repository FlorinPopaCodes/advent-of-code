require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = true

@lines = File.readlines('./2024/Day16/' + (test ? 'test' : 'input')).map(&:strip)

grid_h = @lines.length
grid_w = @lines[0].length
start = nil
START_DIRECTION = :east
goal = nil

grid = Array.new(grid_h) { Array.new(grid_w) }

DIRECTIONS = {
  north: [0, -1],
  east: [1, 0],
  south: [0, 1],
  west: [-1, 0],
}


@lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    case char
    when 'S'
      start = [x, y]
    when 'E'
      goal = [x, y]
    end

    grid[y][x] = char
  end
end

def debug_grid(grid)
  grid.map { |row| row.map { |cell| cell != '#' ? '.' : '#' }.join('') }.join("\n")
end

def dijkstra(grid, start, goal)
  queue = Containers::MinHeap.new  # [position, direction, distance]
  queue.push(0, [start, START_DIRECTION, 0])
  seen = Set.new

  while queue.size > 0
    pos, dir, dist = queue.pop
    i, j = pos

    next if seen.include?([i, j, dir])

    if [i, j] == goal
      return dist
    else
      seen.add([i, j, dir])
    end

    DIRECTIONS.each do |dir_search, (di, dj)|
      next if i + di < 0 || i + di >= grid[0].size     # Check x against width
      next if j + dj < 0 || j + dj >= grid.size        # Check y against height
      next if grid[j + dj][i + di] == '#'
      next if seen.include?([i + di, j + dj, dir_search])

      if dir == dir_search
        queue.push(dist + 1, [[i + di, j + dj], dir_search, dist + 1])
      else 
        queue.push(dist + 1001, [[i + di, j + dj], dir_search, dist + 1001])
      end
    end
  end

  return queue.size == 0 ? -1 : queue.size
end

seen_count = dijkstra(grid, start, goal)
p seen_count 
