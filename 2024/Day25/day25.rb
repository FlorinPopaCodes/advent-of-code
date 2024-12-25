require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

LINES = File.readlines('./2024/Day25/' + (test ? 'test' : 'input')).map(&:strip)

LOCKS = []
KEYS = []

def parse_chunk(chunk)
  key = chunk[0] == '#####' ? false : true

  signature = chunk[1..-2].map(&:chars).transpose.map { |c| c.count { _1 == '#' } }

  # store_signature(key, signature)

  key ? KEYS << signature : LOCKS << signature
end

LINES.chunk { |l| l.empty? }.reject { |state, _| state }.each { |chunk| parse_chunk(chunk[1]) }

r = 0
LOCKS.each do |lock|
  KEYS.each do |key|
    r += 1 if lock.zip(key).none? { |a, b| a + b > 5 }
  end
end

p r