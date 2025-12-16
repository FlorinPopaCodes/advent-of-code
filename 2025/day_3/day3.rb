input_lines = File.readlines('./2025/day_3/input')

def search_numbers(search_hash, size:, number: 9, index: 0)
  return [] if size <= 0
  return [] if number <= 0

  # p "size: #{size} number: #{number} index: #{index}"
  # p "search_hash" + search_hash[number].select { |i| i >= index }.inspect
  smaller = search_numbers(search_hash, size: size - search_hash[number].size, number: number - 1, index: search_hash[number].last || 0)
  # p "smaller" + smaller.inspect

  # TODO: unhappy path, when size return is smaller than expected search next index or next number
  # Do we need caching?



  (search_hash[number].select { |i| i >= index } + smaller).take(size)

end

def max_joltage(bank, search_size: 12)
  # p "Bank #{bank}, Size: #{bank.size}"
  jolts = bank.chars.map(&:to_i)

  search_hash = Hash.new { |hash, key| hash[key] = [] }

  jolts.each.with_index do |jolt, index|
    search_hash[jolt] << index
  end

  search_hash.each_value(&:sort!)

  # Happy path. All numbers are in order
  keys = search_numbers(search_hash, size: search_size)

  # p keys
  keys.map { |k| jolts[k] }.join.to_i
end

total_joltage = 0

input_lines.each do |line|
  bank = line.chomp
  joltage = max_joltage(bank)
  p "Joltage: #{joltage}"
  total_joltage += joltage
end

#1: 1717913706822276 (high)
#2: 1715868656235176 (high)
p total_joltage
