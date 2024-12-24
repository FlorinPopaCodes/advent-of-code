require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false
size = test ? 6 : 45

# Parse input values and connections
@lines = File.readlines('./2024/Day24/' + (test ? 'test_3' : 'input')).map(&:strip)

INPUTS = {}
FORWARD_CONNECTIONS = {}
BACKWARD_CONNECTIONS = {}

# First parse the input values (lines without ->)
@lines.each do |line|
  next if line.include?('->')
  next if line.empty?
  
  var, value = line.split(': ')
  INPUTS[var] = value.to_i
end

def input_key(inputs:, op:)
  inputs.sort + [op]
end

# Then parse the connections (lines with ->)
@lines.each do |line|
  next unless line.include?('->')
  
  input_part, output = line.split(' -> ')
  input_a, op, input_b = input_part.split
  
  # Operation connection (AND, OR, XOR)
  FORWARD_CONNECTIONS[input_key(inputs: [input_a, input_b].sort, op: op)] = output

  BACKWARD_CONNECTIONS[output] = {inputs: [input_a, input_b].sort, op: op}
end

def bor(a, b)
  {inputs: [a, b], op: 'OR'}
end

# Return [result, carry]
def half_adder(a, b)
  [{inputs: [a, b], op: 'XOR'}, {inputs: [a, b], op: 'AND'}]
end

PAIRS = []

def update_backward_connections(output_key_a, output_key_b)
  BACKWARD_CONNECTIONS[output_key_a], BACKWARD_CONNECTIONS[output_key_b] = BACKWARD_CONNECTIONS[output_key_b], BACKWARD_CONNECTIONS[output_key_a]
end

def flip_connections(input_key_a, input_key_b)
  update_backward_connections(FORWARD_CONNECTIONS[input_key_b], FORWARD_CONNECTIONS[input_key_a])
  FORWARD_CONNECTIONS[input_key_a], FORWARD_CONNECTIONS[input_key_b] = FORWARD_CONNECTIONS[input_key_b], FORWARD_CONNECTIONS[input_key_a]
end

def ack_and_flip_pairs(input_key_a, input_key_b)
  PAIRS << [forward(input_key_a), forward(input_key_b)]

  flip_connections(input_key(**input_key_a), input_key(**input_key_b))
end

def compare_ops(a, b)
  a[:inputs].sort == b[:inputs].sort && a[:op] == b[:op]
end

def forward(key)
  FORWARD_CONNECTIONS[input_key(**key)]
end

carry = nil
# ONLY THE OUTPUTS ARE FLIPPED
# BY trial end error, with lots of debugging statements
size.times do |i|
  if i == 0
    result, carry = half_adder("x%.2d" % i, "y%.2d" % i)
    
    # expect result to be "z%.2d" % i
    if forward(result) != "z%.2d" % i
      debugger
    end

    if forward(carry).nil?
      debugger
    end 
  else
    psum, c1 = half_adder("x%.2d" % i, "y%.2d" % i) # XOR, AND
    result, c2 = half_adder(forward(psum), forward(carry)) # XOR, AND

    if forward(c1).start_with?("z")
      ack_and_flip_pairs(c1, result)
    end

    debugger if result[:inputs].any?(&:nil?) || c2[:inputs].any?(&:nil?)
    if forward(result).nil? && forward(c2).nil?
      ack_and_flip_pairs(psum, c1) 
      result, c2 = half_adder(forward(psum), forward(carry)) # XOR, AND
    end

    unless forward(result).start_with?("z")
      ack_and_flip_pairs(result, BACKWARD_CONNECTIONS["z%.2d" % i])
    end

    carry = bor(forward(c1), forward(c2)) # OR
  end
end

p PAIRS.flatten.sort.join(',')

