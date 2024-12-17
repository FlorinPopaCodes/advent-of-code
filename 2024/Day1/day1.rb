input_lines = File.readlines('./2024/Day1/input')



row1 = []
row2 = []

input_lines.each do |line|
  x, y = line.split("   ").map(&:to_i)
  row1 << x
  row2 << y
end

row1.sort!
row2.sort!

p row1.zip(row2).sum { (_1[0] - _1[1]).abs }



right_tally = row2.tally

p right_tally

p row1.sum { _1 * right_tally.fetch(_1, 0) }