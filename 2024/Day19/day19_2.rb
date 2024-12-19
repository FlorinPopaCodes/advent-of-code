require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

@lines = File.readlines('./2024/Day19/' + (test ? 'test' : 'input')).map(&:strip)

@stripes = @lines[0].split(', ')
@towels = @lines[2..]

# Group stripes by their first character for faster lookup
@stripe_map = @stripes.group_by { |s| s[0] }

CACHE = { '' => 1 }

def count_patterns(towel)
  return CACHE[towel] if CACHE[towel]
  return 0 if towel.empty? || !@stripe_map[towel[0]] # No valid stripes start with this char

  count = 0
  # Try each stripe that starts with the current character
  @stripe_map[towel[0]].each do |stripe|
    next if stripe.size > towel.size # Skip if stripe is longer than remaining towel
    next if towel[0...stripe.size] != stripe # Skip if stripe doesn't match

    # Add the number of ways to match the rest of the towel
    count += count_patterns(towel[stripe.size..])
  end

  CACHE[towel] = count
  count
end

p @towels.map { |towel| count_patterns(towel) }.sum
