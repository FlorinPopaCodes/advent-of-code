require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

@lines = File.readlines('./2024/Day18/' + (test ? 'test' : 'input')).map { _1.strip.split(',').map(&:to_i) }

grid_w = test ? 7 : 71
grid_h = test ? 7 : 71
runtime = test ? 12 : 1024

start = [0,0]
goal = [grid_w - 1, grid_h - 1]
grid = Array.new(grid_h) { Array.new(grid_w) { true } }

runtime.times do |i|
  grid[@lines[i][1]][@lines[i][0]] = false
end

def debug_grid(grid)
  grid.map { |row| row.map { |cell| cell ? '.' : '#' }.join('') }.join("\n")
end

def bfs(grid, start, goal)
  queue = Containers::Queue.new([[start, 0]])  # [position, distance]
  seen = Set.new
  directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]  # right, down, left, up

  while queue.size > 0
    pos, dist = queue.pop
    i, j = pos
    next if seen.include?([i, j])
    seen.add([i, j])

    if i == goal[0] && j == goal[1]
      return dist  # Return the distance when we reach the goal
    end

    directions.each do |di, dj|
      next if i + di < 0 || i + di >= grid.size
      next if j + dj < 0 || j + dj >= grid[0].size
      next if grid[i + di][j + dj] == false
      queue.push([[i + di, j + dj], dist + 1])  # Increment distance for neighbors
    end
  end

  return -1  # Return -1 if no path found
end


index = (1024..@lines.size).bsearch do |current|
  grid = Array.new(grid_h) { Array.new(grid_w) { true } }
  current.times do |i|
    grid[@lines[i][1]][@lines[i][0]] = false
  end
  bfs(grid, start, goal) == -1
end

p @lines[index - 1]