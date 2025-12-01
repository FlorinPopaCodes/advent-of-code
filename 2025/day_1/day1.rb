input_lines = File.readlines('./2025/day_1/input')


password = 0
current = 50

input_lines.each do |line|
  l = line.chomp

  direction = l[0]
  steps = l[1..].to_i
  
  if direction == "L"
    current -= steps
  else
    current += steps
  end

  current %= 100 if current < 0 || current > 99
    
  password += 1 if current == 0
end

p password