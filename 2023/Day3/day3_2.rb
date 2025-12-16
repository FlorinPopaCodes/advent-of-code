lines = IO.readlines('Day3/input')

gear_positions = Array.new(lines.size) { [] }

lines.each_with_index do |line, index|
  offset = 0
  while symbol_index = line.index(/\*/, offset)
    gear_positions[index] << symbol_index
    offset = symbol_index + 1
  end
end

def matching_gear(range, index, min, max, gear_positions)
  start_line = [min, index - 1].max
  end_line = [max, index + 1].min
  range_min, range_max = range.minmax
  range_min = [0, range_min - 1].max
  range_max += 1
  matching = nil
  gear_positions[start_line..end_line].each_with_index do |row, i|
    next if row.empty?

    col = row.find { |r| range_min <= r && r <= range_max }
    matching = [start_line + i, col].join(':') if col
    break if col
  end
  matching
end

gear_numbers = Hash.new { |k, v| k[v] = [] } # !!!

lines.each_with_index do |line, index|
  offset = 0
  while number_start = line.index(/\d/, offset)
    number_end = number_start
    number_end += 1 while line[number_end + 1] =~ /\d/
    matching = matching_gear(number_start..number_end, index, 0, lines.size - 1, gear_positions)
    gear_numbers[matching] << line[number_start..number_end].to_i if matching

    offset = number_end + 1
  end
end

# What is the sum of all of the gear ratios in your engine schematic?
p (gear_numbers.select { |_, v| v.count == 2 }.values.map { |v| v.reduce(:*) }).sum
