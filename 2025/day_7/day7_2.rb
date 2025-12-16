# Day 7: Laboratories - Part 2

lines = File.readlines('./2025/day_7/input').map(&:chomp)
grid = lines.map(&:chars)

grid_with_lasers = Hash.new { |h,k| h[k] = Hash.new(0) }

grid[0..-1].each.with_index do |row, row_index|
  row.each.with_index do |grid_cell, col_index|
    case grid_cell
    when 'S'
      grid_with_lasers[row_index + 1][col_index] = 1
    when '^'
      if grid_with_lasers[row_index - 1][col_index] > 0
        grid_with_lasers[row_index][col_index - 1] += grid_with_lasers[row_index - 1][col_index]
        grid_with_lasers[row_index][col_index + 1] += grid_with_lasers[row_index - 1][col_index]
      end
    when '.'
      if grid_with_lasers[row_index - 1][col_index] > 0
        grid_with_lasers[row_index][col_index] += grid_with_lasers[row_index - 1][col_index]
      end
    end
  end
end


puts grid_with_lasers[grid.size - 1].values.sum
