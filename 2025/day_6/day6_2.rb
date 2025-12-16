# Day 6: Trash Compactor - Part 2
# Parse vertical math worksheet and compute grand total

# Read input and parse as grid
lines = File.readlines('./2025/day_6/input').map(&:chomp)
max_len = lines.map(&:length).max
grid = lines.map { |l| l.ljust(max_len).chars }

# Find separator columns (columns that are all spaces)
separator_cols = (0...max_len).select do |col|
  grid.all? { |row| row[col] == ' ' }
end

# Add boundaries (start and end of grid) to make range extraction easier
boundaries = [-1] + separator_cols + [max_len]

# Extract column ranges for each problem
# Each problem is bounded by consecutive separator columns
problem_ranges = []
(0...boundaries.length - 1).each do |i|
  left = boundaries[i] + 1
  right = boundaries[i + 1] - 1
  problem_ranges << (left..right) if left <= right
end

# TODO(human): Extract numbers for Part 2
def extract_numbers(col_range, grid)
  col_range.to_a.reverse.map do |c|
    0.upto(grid.size - 2).map { |l| grid[l][c] }.join.to_i
  end
end

def get_operator(col_range, grid)
  grid.last[col_range].join.strip
end

def compute_result(numbers, operator)
  case operator
  when '+'
    numbers.sum
  when '*'
    numbers.reduce(:*)
  end
end

# Main computation
grand_total = 0

problem_ranges.each do |col_range|
  numbers = extract_numbers(col_range, grid)
  operator = get_operator(col_range, grid)
  result = compute_result(numbers, operator)
  grand_total += result
end

p grand_total
