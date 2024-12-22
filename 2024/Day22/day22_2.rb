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

def evolve(secret)
  step_1 = prune(mix(secret, secret * 64))

  step_2 = prune(mix(step_1, step_1 / 32))

  result = prune(mix(step_2, step_2 * 2048))

  result
end


@aggr = Set.new
@total = Hash.new { |h, k| h[k] = 0 }

def key(changes)
  changes.last(4).join(',')
end

# Reading comprehension prevented me from implementing this correctly 
def aggregate_changes(changes, mod, line)
  return if changes.compact.size < 4

  key = key(changes)

  return if @aggr.include?([key, line])
    
  @aggr.add([key, line])
  @total[key] += mod
end

@lines.each_with_index do |line, index|
  window = [line]
  changes = [nil]
  mods = [line % 10]

  2000.times do 
    window = window.last(3) + [evolve(window.last)]
    mod = window.last % 10

    changes = changes.last(3) + [mod - mods.last]
    mods = mods.last(3) + [mod]

    # correct above
    
    aggregate_changes(changes, mod, line)
  end

  @lines[index] = window.last
end

p @total.sort_by { |k, v| v }.reverse.first(10)
