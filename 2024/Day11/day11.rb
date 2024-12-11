require 'debug'
# require 'set'
# require 'algorithms'
# include Containers 

lines = File.readlines('./2024/Day11/input')

line = lines[0].split(' ').map(&:to_i)

# memoization is done at the tree level, not the item level
@memory = Hash.new do |h, (item, level)|
  h[[item, level]] = if level == 0
    1
  elsif item == 0
    h[[1, level - 1]]
  else
    l = (Math.log10(item)+1).floor # finds the length of the number

    if l % 2 == 1
      h[[item * 2024, level - 1]]
    else
      # finds the first half of the number and the second half
      h[[item / 10 ** (l / 2), level - 1]] + h[[item % 10 ** (l / 2), level - 1]]
    end
  end
end

p line.sum { |item| @memory[[item, 75]] }

