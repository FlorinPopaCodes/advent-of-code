require 'debug'

lines = File.readlines('./2024/Day7/input')


total = 0
@memory = {}

def calibrated?(target, components)
  return @memory[[target, components]] if @memory[[target, components]]

  if components.size == 2
    if components[0] + components[1] == target || components[0] * components[1] == target  
      @memory[[target, components]] = true

    end
  else
    div, mod = target.divmod(components.last)

    @memory[[target, components]] = if mod == 0
      calibrated?(div, components[0...-1]) || calibrated?(target - components.last, components[0...-1])
    else
      calibrated?(target - components.last, components[0...-1])
    end
  end

  return @memory[[target, components]]
end

lines.each_with_index do |line, idx|
  target, *components = line.split(/: | /).map(&:to_i)

  total += target if calibrated?(target, components)
end

puts total