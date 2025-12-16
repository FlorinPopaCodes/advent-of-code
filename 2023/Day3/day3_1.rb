lines = IO.readlines('Day3/input')

symbol_positions = Array.new(lines.size) { [] }

lines.each_with_index do |line, index|
  offset = 0
  while symbol_index = line.index(/[^\d.\n]/, offset)
    symbol_positions[index] << symbol_index
    offset = symbol_index + 1
  end
end

def part_of_engine_schematic?(range, index, min, max, symbol_positions)
  start_line = [min, index - 1].max
  end_line = [max, index + 1].min
  range_min, range_max = range.minmax
  range_min = [0, range_min - 1].max
  range_max += 1
  symbol_positions[start_line..end_line].flatten.any? { |pos| range_min <= pos && pos <= range_max }
end

part_numbers = []

lines.each_with_index do |line, index|
  offset = 0
  while number_start = line.index(/\d/, offset)
    number_end = number_start
    number_end += 1 while line[number_end + 1] =~ /\d/
    part_numbers << line[number_start..number_end].to_i if part_of_engine_schematic?(number_start..number_end, index,
                                                                                     0, lines.size - 1, symbol_positions)
    offset = number_end + 1
  end
end

p part_numbers
# What is the sum of all of the part numbers in the engine schematic?
p part_numbers.sum
