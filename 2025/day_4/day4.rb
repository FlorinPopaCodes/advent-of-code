result = 0
input_lines = File.readlines('./2025/day_4/input')

pad_size = input_lines[0].size + 1

grid = [['.'] * pad_size]
grid += input_lines.map { |line| ['.'] + line.chomp.chars + ['.'] }
grid += [['.'] * pad_size]

1.upto(grid.size - 2).each do |row|
  1.upto(grid[0].size - 2).each do |col|
      next if grid[row][col] == '.'
      adj = 0
      adj += 1 if grid[row-1][col-1] == '@'
      adj += 1 if grid[row-1][col] == '@'
      adj += 1 if grid[row-1][col+1] == '@'

      adj += 1 if grid[row][col-1] == '@'
      adj += 1 if grid[row][col+1] == '@'

      adj += 1 if grid[row+1][col-1] == '@'
      adj += 1 if grid[row+1][col] == '@'
      adj += 1 if grid[row+1][col+1] == '@'

      result += 1 if adj <= 3
  end
end

p result
