result = 0
input = File.read('./2025/day_5/input')

ranges_section, ids_section = input.split("\n\n")
ranges = []

ranges_section.lines.map.with_index do |line, index|
  start_id, end_id = line.chomp.split('-').map(&:to_i)

  ranges << (start_id..end_id)
end

ingredient_ids = ids_section.lines.map { |line| line.chomp.to_i }

ingredient_ids.each do |ii|
  result += 1 if ranges.any? do |r|
    r.include?(ii)
  end
end

p result
