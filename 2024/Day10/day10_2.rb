require 'debug'
require 'set'

require 'algorithms'
include Containers 
lines = File.readlines('./2024/Day10/input')

matrix = lines.map { |line| line.chomp.chars.map { |c| c == '.' ? nil : c.to_i } }
counts = Array.new(matrix.size) { Array.new(matrix[0].size, 0) }

nines = []
zeros = []

matrix.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    nines << [i, j] if cell == 9
    zeros << [i, j] if cell == 0
  end
end

seen = Set.new
queue = Containers::Queue.new(nines)

while queue.size > 0
  i, j = queue.pop
  next if seen.include?([i, j])
  seen.add([i, j])

  if matrix[i][j] == 9
    counts[i][j] = 1
  elsif matrix[i][j] >= 0
    [[i - 1, j], [i + 1, j], [i, j - 1], [i, j + 1]].each do |nx, ny|
      next if nx < 0 || nx >= matrix.size || ny < 0 || ny >= matrix[0].size
      next if matrix[nx][ny] != matrix[i][j] + 1

      counts[i][j] += counts[nx][ny]
    end

  end

  [[i - 1, j], [i + 1, j], [i, j - 1], [i, j + 1]].each do |nx, ny|
    next if nx < 0 || nx >= matrix.size || ny < 0 || ny >= matrix[0].size
    next if seen.include?([nx, ny])
    next if matrix[nx][ny] != matrix[i][j] - 1

    queue.push([nx, ny])
  end
end

result = zeros.sum do |zero|
  counts[zero[0]][zero[1]]
end

p result

