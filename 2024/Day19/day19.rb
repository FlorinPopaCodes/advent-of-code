require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

@lines = File.readlines('./2024/Day19/' + (test ? 'test' : 'input')).map(&:strip)

@stripes = @lines[0].split(', ')
@towels = @lines[2..]

PATTERN = /^#{Regexp.union(*@stripes)}+$/

def possible?(pattern)
  pattern =~ PATTERN
end

p @towels.count { |towel| possible?(towel) }
