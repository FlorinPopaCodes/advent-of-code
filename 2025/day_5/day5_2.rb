input = File.read('./2025/day_5/input')

ranges_section, ids_section = input.split("\n\n")
ranges = []

ranges_section.lines.map.with_index do |line, index|
  start_id, end_id = line.chomp.split('-').map(&:to_i)

  ranges << (start_id..end_id)
end

grouped_ranges = ranges.sort_by(&:begin).reduce([]) do |acc, range|
    if acc.empty? || acc.last.end < range.begin - 1
      acc << range
    else
      acc[-1] = (acc.last.begin..[acc.last.end, range.end].max)
    end
    acc
  end

p grouped_ranges.sum(&:size)
