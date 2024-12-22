require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

@lines = File.readlines('./2024/Day22/' + (test ? 'test' : 'input')).map(&:strip).map(&:to_i)

def mix(a, b)
  a ^ b
end

def prune(a)
  a % 16777216
end

# p mix(42, 15) == 37
# p prune(100000000) == 16113920

def evolve(secret)
  step_1 = prune(mix(secret, secret * 64))

  step_2 = prune(mix(step_1, step_1 / 32))

  result = prune(mix(step_2, step_2 * 2048))

  result
end



2000.times do |i|
  @lines.each_with_index do |line, index|
    @lines[index] = evolve(line)
  end
end

p @lines.sum # 12664695565