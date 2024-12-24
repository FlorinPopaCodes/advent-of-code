require 'debug'
require 'set'
require 'algorithms' 
require 'bigdecimal'

test = false

# Parse input values and connections
@lines = File.readlines('./2024/Day24/' + (test ? 'test_2' : 'input')).map(&:strip)

INPUTS = {}
CONNECTIONS = {}

# First parse the input values (lines without ->)
@lines.each do |line|
  next if line.include?('->')
  next if line.empty?
  
  var, value = line.split(': ')
  INPUTS[var] = value.to_i
end

# Then parse the connections (lines with ->)
@lines.each do |line|
  next unless line.include?('->')
  
  input_part, output = line.split(' -> ')
  inputs = input_part.split
  
  # Operation connection (AND, OR, XOR)
  CONNECTIONS[output] = {
    inputs: [inputs[0], inputs[2]],
    op: inputs[1]
  }
end

OUTPUTS = INPUTS.dup

CONNECTIONS.size.times do
  output_key, connection = CONNECTIONS.find do |output, value|
    !OUTPUTS.key?(output) && OUTPUTS.key?(value[:inputs][0]) && OUTPUTS.key?(value[:inputs][1]) 
  end

  input_a, input_b = connection[:inputs]
  op = connection[:op]

  OUTPUTS[output_key] = case op
  when 'AND'
    OUTPUTS[input_a] & OUTPUTS[input_b] 
  when 'OR'
    OUTPUTS[input_a] | OUTPUTS[input_b] 
  when 'XOR'
    OUTPUTS[input_a] ^ OUTPUTS[input_b]
  end
end

# Convert array of bits to decimal number
result = OUTPUTS.select { |k, v| k.start_with?('z') }
            .sort_by { |k, v| k }
            .reverse
            .to_h
            .values
            .join
            .to_i(2)

p result
