input_lines = File.readlines('./Day1/input')

replacement_map = {
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9
}


clean_lines = input_lines.map do |line|
  last_index = line.rindex(/one|two|three|four|five|six|seven|eight|nine/)
  last_numer_index = line.rindex(/[0-9]/)
  last_index = [last_index || -1, last_numer_index || -1 ].max

  line[last_index..] = line[last_index..].sub(/one|two|three|four|five|six|seven|eight|nine/, replacement_map)
  line.sub(/one|two|three|four|five|six|seven|eight|nine/, replacement_map)
end

p clean_lines.map { |line| line.scan(/[0-9]/) }
  .map { |nums| nums[0] + nums[-1]}
  .map { |number| number.to_i }
  .sum

# Issues
# * didn't know how to read from file IO.readlines
# * didn't understand where a file was read Dir.pwd
# * didn't use test file to figure out the problem from the start and edge cases