input = File.read('./2025/day_2/input').strip

# Parse ranges from comma-separated input
ranges = input.split(',').map do |range_str|
  start_id, end_id = range_str.strip.split('-').map(&:to_i)
  (start_id..end_id)
end

# TODO: Implement this method to check if an ID is invalid
# An ID is invalid if it's made of some sequence of digits repeated twice
# Examples: 11 (5 twice), 6464 (64 twice), 123123 (123 twice)
def invalid_id?(id)
  s = id.to_s

  s =~ /^(\d+)\1$/
end

total = 0

ranges.each do |range|
  range.each do |id|
    if invalid_id?(id)
      total += id
    end
  end
end

p total
# 31839939666
# 31839939622
