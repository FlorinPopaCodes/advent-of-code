lines = File.readlines(%(Day4/input))

cards = {}

lines.each do |line|
  card_number, numbers_before_pipe, numbers_after_pipe = line.split(/:|\|/).map { |b| b.scan(/\d+/).map(&:to_i) }

  cards[card_number.first] = (numbers_after_pipe & numbers_before_pipe).count
end

# result = 0
#
# cards.each do |_card_number, winning_numbers|
#   result += (2**(winning_numbers - 1)).to_i
# end
#
# p result

copies = Hash.new(1)
cards.each do |k, v|
  v.times do |i|
    copies[k + i + 1] += copies[k]
  end
end

sum = 0
cards.each do |k, _v|
  sum += copies[k]
end
p cards, copies, sum
