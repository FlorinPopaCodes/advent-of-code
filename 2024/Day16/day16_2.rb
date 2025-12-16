require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

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

GRID_SCORES = Hash.new { |h, k| h[k] = [] } 
BEST_PATH_TILES = Set.new

def available_directions(grid, i, j, seen)
  DIRECTIONS.select do |dir_search, (di, dj)|
    i + di >= 0 && i + di < grid[0].size &&    # Check x bounds
    j + dj >= 0 && j + dj < grid.size &&       # Check y bounds
    grid[j + dj][i + di] != '#'
  end
end

def dijkstra(grid, start, goal)
  queue = Containers::MinHeap.new  # [position, direction, distance]
  queue.push(0, [start, START_DIRECTION, 0])

  seen = Set.new
  GRID_SCORES[start] = [0]

  while queue.size > 0
    pos, dir, dist = queue.pop
    i, j = pos

    if seen.include?([i, j])
      next 
    end

    seen.add([i, j])

    dirs = available_directions(grid, i, j, seen)
  
    dirs.each do |dir_search, (di, dj)|
      score = dir == dir_search ? dist + 1 : dist + 1001
      GRID_SCORES[[i + di, j + dj]] << score 

      queue.push(score,[[i + di, j + dj], dir_search, score]) unless seen.include?([i + di, j + dj])
    end
  end

  return queue.size == 0 ? -1 : queue.size
end

def bfs(grid, start, goal, start_score)
  queue = Containers::Queue.new  # [position]
  queue.push([start, [start_score]])

  seen = Set.new
  BEST_PATH_TILES.add(start)
  score = start_score

  while queue.size > 0
    pos, scores = queue.pop
    i, j = pos

    if seen.include?([i, j])
      next 
    end

    seen.add([i, j])

    dirs = available_directions(grid, i, j, seen)
      .reject { |dir_search, (di, dj)| BEST_PATH_TILES.include?([i + di, j + dj]) }
  
    dirs.each do |dir_search, (di, dj)|
      valid_scores =  scores.flat_map { |score| [score - 1, score - 1001].select(&:positive?) }

      inner = GRID_SCORES[[i + di, j + dj]].intersection(valid_scores)
      next if inner.empty?

      BEST_PATH_TILES.add([i + di, j + dj])
      queue.push([[i + di, j + dj], inner])
    end
  end

  return queue.size == 0 ? -1 : queue.size
end

dijkstra(grid, start, goal)

bfs(grid, goal, start, GRID_SCORES[goal].min)

GRID_SCORES[goal]

p BEST_PATH_TILES.size + 1 # 500 too high. response for someone else
