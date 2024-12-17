require 'debug'
# require 'set'
# require 'algorithms'
# include Containers 
require 'bigdecimal'
@lines = File.readlines('./2024/Day17/input').map(&:strip)

lines = @lines.join("\n")

reg_a = lines.scan(/Register A: (\d+)/).first.first.to_i
reg_b = lines.scan(/Register B: (\d+)/).first.first.to_i
reg_c = lines.scan(/Register C: (\d+)/).first.first.to_i

program = lines.scan(/Program: ([\d,]+)/).first.first.split(',').map(&:to_i)

puts "Registers: A=#{reg_a}, B=#{reg_b}, C=#{reg_c}"
puts "Program: #{program.inspect}"


def combo_operand(operand:, reg_a:, reg_b:, reg_c:)
  case operand
  in 0..3
    operand
  in 4
    reg_a
  in 5
    reg_b
  in 6
    reg_c
  in 7
    raise 'invalid operand'
  end
end

def jump(opcode, operand, reg_a) # jnz
  @ins_p ||= 0
  @ins_jump ||= 2

  if opcode == 3 && reg_a != 0
    @ins_p = operand
  else
    @ins_p += @ins_jump
  end

  @ins_p
end

def run(opcode, operand, reg_a, reg_b, reg_c, output)

end

pdx = 0
output = []

begin 
  p "#{pdx} #{program[pdx]} #{program[pdx + 1]}"
  p "Registers: A=#{reg_a}, B=#{reg_b}, C=#{reg_c}"
  opcode = program[pdx]
  operand = program[pdx + 1]
  co = combo_operand(operand:, reg_a:, reg_b:, reg_c:)

  case opcode
  when 0 # adv
    reg_a = reg_a / 2 ** co
  when 1 # bxl
    reg_b = reg_b ^ operand
  when 2 # bst
    reg_b = co % 8
  when 3 # jnz
  when 4 # bxc
    reg_b = reg_b ^ reg_c
  when 5 # out
    output << co % 8
  when 6 # bdv
    reg_b = reg_a / 2 ** co
  when 7 # cdv
    reg_c = reg_a / 2 ** co
  end

  pdx = jump(opcode, operand, reg_a)
  
end while pdx < program.size

p output.join(',')


