# Day 7: Laboratories

lines = File.readlines('./2025/day_7/input').map(&:chomp)
grid = lines.map(&:chars)

grid_with_lasers = grid.clone

result = 0

grid[0..-2].each.with_index do |row, row_index|
  row.each.with_index do |grid_cell, col_index|
    cell = grid_with_lasers[row_index][col_index]

    cell_below = grid_with_lasers[row_index + 1][col_index]

    # p cell
    case cell
    when 'S'
      grid_with_lasers[row_index + 1][col_index] = '|'
    when '|'
      case cell_below
      when '.'
        grid_with_lasers[row_index + 1][col_index] = '|'
      when '^'
        result += 1
        grid_with_lasers[row_index + 1][col_index - 1] = '|'
        grid_with_lasers[row_index + 1][col_index + 1] = '|'
      end
    end
  end

end

p result
