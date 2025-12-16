require 'debug'

input_lines = File.readlines('./2024/Day2/input')

def check_row(row)
  row.each_cons(2).each_with_object([nil, nil]) do |pair, acc| 
    status, last_order = acc
    break acc if status == :unsafe

    x, y = pair

    current_order = x - y > 0 ? :desc : :asc
    current_order = :same if x == y

    if x == y || (x - y).abs > 3
      acc[0] = :unsafe
      acc[1] = current_order
      break acc
    elsif last_order && last_order != current_order
      acc[0] = :unsafe
      acc[1] = current_order
      break acc
    else
      acc[0] = :safe
      acc[1] = current_order
    end
  end
end


safe = 0

input_lines.each do |line|
  row = line.split(" ").map(&:to_i)
 
  result = check_row(row)

  if result[0] == :safe
    safe += 1 
  else
    row.size.times do |i|
      result = check_row(row[0...i] + row[(i+1)..])

      if result[0] == :safe
        safe += 1; 
        break
      end
    end
  end
end

p safe


