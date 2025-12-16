require 'debug'

input_lines = File.readlines('./2024/Day4/input')


input_lines = [" " * input_lines[0].size]  + input_lines + [" " * input_lines[0].size]

input_lines = input_lines.map do |line|
  " " + line + " "
end

r = 0

input_lines.each_with_index do |row, i|
  row.each_char.with_index do |cell, j|
    # only start at the center with X
    next unless cell == 'A'

    corners = input_lines[i - 1][j - 1] + input_lines[i - 1][j + 1] + ' ' + input_lines[i + 1][j - 1] + input_lines[i + 1][j + 1] 

    case corners
    when "MM SS"
      r += 1
    when "MS MS"
      r += 1
    when "SS MM"
      r += 1
    when "SM SM"
      r += 1
    else
      p corners
    end
  end

end

p r