require 'debug'

input_lines = File.readlines('./2024/Day5/input')


pages_input = false
order = Hash.new(0) # [a,b] => true, false b > a => true, default 0
pages = [] # Array of Array of ints

def sorted(a, o)
  a.sort { |p1, p2| p1 < p2 ? o[[p1 , p2]] : - o[[p2, p1]] }
end

input_lines.each_with_index do |row, i|
  if row == "\n"
    pages_input = true 
    next
  end

  if pages_input
    pages << row.split(',').map(&:to_i)
  else
    a, b = row.split('|').map(&:to_i)
    order[[a,b].sort] = b > a ? -1 : 1
  end
end

p "orders #{order.size}"
p "pages #{pages.size}"

# 47|26
#  order.select { |k, _| k[0] == 68 || k[1] == 47 }.select { |k, _| k[0] == 26 || k[1] == 26 }
# debugger

grouped_pages = pages.group_by do |page|
    p page
    p sorted(page, order)
    page == sorted(page, order) ? :correct : :incorrect
  end
  
# p "correct"
# p grouped_pages[:correct]
# p "incorrect"
# p grouped_pages[:incorrect]


p grouped_pages
p grouped_pages[:correct].sum { |page| page[page.size/2] }
p grouped_pages[:incorrect].sum { |page| page[page.size/2] }

# # result was too low.
# p mids.sum


