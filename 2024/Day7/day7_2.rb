require 'debug'

lines = File.readlines('./2024/Day7/input')


total = 0
@memory = {}


def compare_concats(a, b, t)
  (a.to_s + b.to_s) == t.to_s
end

def deconcatable?(t, a)
  as = a.to_s
  
  t.to_s[-as.size..] == as
end

def deconcate(t, a)
  as = a.to_s
  
  t.to_s[...-as.size].to_i
end


def calibrated?(target, components)
  return @memory[[target, components]] if @memory[[target, components]]

  if components.size == 2
    division = components[0] * components[1] == target
    addition = components[0] + components[1] == target
    concat = compare_concats(components[0], components[1], target)
  else
    div, mod = target.divmod(components.last)

    division = mod == 0 ? calibrated?(div, components[0...-1]) : false
    addition = calibrated?(target - components.last, components[0...-1])
    concat = deconcatable?(target, components.last) && calibrated?(deconcate(target, components.last), components[0...-1])
  end

  @memory[[target, components]] = division || addition || concat

  return @memory[[target, components]]
end

lines.each_with_index do |line, idx|
  target, *components = line.split(/: | /).map(&:to_i)


  total += target if calibrated?(target, components)
end

puts total