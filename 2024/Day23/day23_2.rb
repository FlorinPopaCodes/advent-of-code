require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

@lines = File.readlines('./2024/Day23/' + (test ? 'test' : 'input')).map(&:strip).map { |line| line.split('-') }

NODES = Hash.new { |h, k| h[k] = Set.new }

@lines.each do |node_a, node_b|
  NODES[node_a].add(node_b)
  NODES[node_b].add(node_a)
end

def key(a, b, common)
  ([a] + [b] + common.to_a).sort.join(',')
end

CONNECTED = Hash.new { |h, k| h[k] = 0 }

NODES.keys.sort.combination(2).map { |a, b| [a, b, NODES[a] & NODES[b]] }.select { |set| set[2].size > 1 }.each do |a, b, common|
  CONNECTED[key(a, b, common)] += 1
end

p CONNECTED.max_by { |k, v| v }.first
