require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

@lines = File.readlines('./2024/Day23/' + (test ? 'test' : 'input')).map(&:strip).map { |line| line.split('-') }

NODES = Hash.new { |h, k| h[k] = Set.new }
SETS = Set.new

@lines.each do |node_a, node_b|
  NODES[node_a].add(node_b)
  NODES[node_b].add(node_a)


  common = NODES[node_a] & NODES[node_b]

  common.each do |node|
    tripple = [node_a, node, node_b].sort
    SETS.add(tripple) if tripple.any? { |node| node.start_with?('t') }
  end
end

# p NODES
p SETS.size