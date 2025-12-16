require 'debug'

input_lines = File.readlines('./2024/Day4/input')


input_lines = [" " * input_lines[0].size] * 3 + input_lines + [" " * input_lines[0].size] * 3

input_lines = input_lines.map do |line|
  "   " + line + "   "
end

r = 0

input_lines.each_with_index do |row, i|
  row.each_char.with_index do |cell, j|
    # only start at the center with X
    next unless cell == 'X'
    # look forward
    r += 1 if input_lines[i][j + 1, 3] == 'MAS'

    # backward
    r += 1 if input_lines[i][(j-3)..(j - 1)] == 'SAM'

    # up
    r += 1 if input_lines[i + 1][j] == 'M' && input_lines[i + 2][j] == 'A' && input_lines[i + 3][j] == 'S'

    # down
    r += 1 if input_lines[i - 1][j] == 'M' && input_lines[i - 2][j] == 'A' && input_lines[i - 3][j] == 'S'

    # top-right
    r += 1 if input_lines[i - 1][j + 1] == 'M' && input_lines[i - 2][j + 2] == 'A' && input_lines[i - 3][j + 3] == 'S'

    # bot-right
    r += 1 if input_lines[i + 1][j + 1] == 'M' && input_lines[i + 2][j + 2] == 'A' && input_lines[i + 3][j + 3] == 'S'

    # top-left
    r += 1 if input_lines[i - 1][j - 1] == 'M' && input_lines[i - 2][j - 2] == 'A' && input_lines[i - 3][j - 3] == 'S'

    # bot-left
    r += 1 if input_lines[i + 1][j - 1] == 'M' && input_lines[i + 2][j - 2] == 'A' && input_lines[i + 3][j - 3] == 'S'
  end

end

p r