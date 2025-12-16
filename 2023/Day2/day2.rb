input_lines = IO.readlines('Day2/input')

# The Elf would first like to know which games would have been possible
# if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
possible_game = {
  red: 12,
  green: 13,
  blue: 14
}
# first star
# sum_possible_game_ids = 0
# input_lines.each do |line|
#   game_info, draws = line.split(': ')
#   _, game_id = game_info.split(' ')
#   blue_draws = draws.scan(/[0-9]+ blue/).map { |draw| draw.scan(/[0-9]+/)[0].to_i }.flatten
#   red_draws = draws.scan(/[0-9]+ red/).map { |draw| draw.scan(/[0-9]+/)[0].to_i }.flatten
#   green_draws = draws.scan(/[0-9]+ green/).map { |draw| draw.scan(/[0-9]+/)[0].to_i }.flatten
#
#   next if blue_draws.any? { |draw| draw > possible_game[:blue]  }
#   next if red_draws.any? { |draw| draw > possible_game[:red]  }
#   next if green_draws.any? { |draw| draw > possible_game[:green]  }
#
#   sum_possible_game_ids += game_id.to_i
# end
#
# p sum_possible_game_ids

sum_of_powers = 0
input_lines.each do |line|
  game_info, draws = line.split(': ')
  _, game_id = game_info.split(' ')
  blue_draws = draws.scan(/[0-9]+ blue/).map { |draw| draw.scan(/[0-9]+/)[0].to_i }.flatten
  red_draws = draws.scan(/[0-9]+ red/).map { |draw| draw.scan(/[0-9]+/)[0].to_i }.flatten
  green_draws = draws.scan(/[0-9]+ green/).map { |draw| draw.scan(/[0-9]+/)[0].to_i }.flatten


  sum_of_powers += [
    blue_draws,
    red_draws,
    green_draws
  ].map(&:max).reduce(:*)
end

p sum_of_powers