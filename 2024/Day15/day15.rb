require 'debug'
# require 'set'
# require 'algorithms'
# include Containers 
require 'bigdecimal'
@lines = File.readlines('./2024/Day15/input').map(&:strip)


@directions = {
  '<' => :left,
  '^' => :up,
  '>' => :right,
  'v' => :down
}

class Map
  ROBOT = '@'
  BOX = 'O'
  WALL = '#'
  EMPTY = '.'

  attr_reader :current_position, :map

  def initialize
    @map = []
    @current_position = nil
  end

  def initialize_from_lines(lines)
    @map = lines.map(&:chars)
    # Find the robot position
    @map.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        @current_position = [r, c] if cell == ROBOT
      end
    end
  end

  def set_start_position(position)
    row, col = position
    @current_position = position
    @map[row][col] = ROBOT
  end

  def add_obstacle(position)
    row, col = position
    @map[row][col] = WALL
  end

  def set_position(position, char)
    row, col = position
    ensure_map_size(row, col)
    @map[row][col] = char
  end

  def move(direction)
    next_pos = next_position(@current_position, direction)
    return false if !within_bounds?(next_pos)
    return false if is_wall?(next_pos)

    if is_box?(next_pos)
      # Get all elements from the box to the wall
      elements = elements_to_wall(direction)
      
      # Count boxes and find first empty space
      boxes = []
      first_empty = nil
      
      elements.each do |element|
        if element[:value] == BOX
          boxes << element[:position]
        elsif element[:value] == EMPTY && first_empty.nil?
          first_empty = element[:position]
          break
        elsif element[:value] == WALL
          break
        end
      end
      
      # If we found boxes and an empty space to move them to
      if !boxes.empty? && first_empty
        # Move all boxes one position towards the empty space
        boxes.reverse.each do |box_pos|
          next_box_pos = next_position(box_pos, direction)
          swap_contents(box_pos, next_box_pos)
        end
      else
        return false
      end
    end

    # Move the robot
    swap_contents(@current_position, next_pos)
    @current_position = next_pos
    true
  end

  def next_position(pos, direction)
    row, col = pos
    case direction
    when :up then [row - 1, col]
    when :down then [row + 1, col]
    when :left then [row, col - 1]
    when :right then [row, col + 1]
    end
  end

  def elements_to_wall(direction)
    elements = []
    current_pos = @current_position
    
    loop do
      current_pos = next_position(current_pos, direction)
      break unless within_bounds?(current_pos)
      
      cell = get_position(current_pos)
      elements << { position: current_pos, value: cell }
      break if cell == WALL
    end
    
    elements
  end

  def is_wall?(position)
    row, col = position
    @map[row][col] == WALL
  end

  def is_box?(position)
    row, col = position
    @map[row][col] == BOX
  end

  def calculate_gps_coordinate(position)
    row, col = position
    row * 100 + col
  end

  def sum_box_coordinates
    total = 0
    @map.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        total += calculate_gps_coordinate([r, c]) if cell == BOX
      end
    end
    total
  end

  def position_empty?(position)
    row, col = position
    @map[row][col] == EMPTY
  end

  def get_position(position)
    row, col = position
    @map[row][col]
  end

  def within_bounds?(position)
    row, col = position
    row >= 0 && row < @map.size && col >= 0 && col < @map[0].size
  end

  def print_map
    return puts "Map is empty" if @map.empty?

    # Print column numbers header
    print "   " # Offset for row numbers
    (0...@map[0].size).each { |c| print (c % 10).to_s }
    puts

    # Print the map with row numbers
    @map.each_with_index do |row, r|
      print format("%2d ", r)
      puts row.join
    end
    puts
  end

  private

  def set_cell(position, value)
    row, col = position
    @map[row][col] = value
  end

  def swap_contents(from_pos, to_pos)
    from_content = get_position(from_pos)
    to_content = get_position(to_pos)
    set_cell(to_pos, from_content)
    set_cell(from_pos, to_content)
  end

  def ensure_map_size(row, col)
    # Ensure we have enough rows
    while @map.size <= row
      @map << []
    end
    
    # Ensure each row has enough columns
    @map.each do |map_row|
      while map_row.size <= col
        map_row << EMPTY
      end
    end
  end
end

@map = Map.new

# Read the input into lines first
input_lines = []
@lines.each do |line|
  break if line.empty?
  input_lines << line
end

# Initialize the map with the lines
@map.initialize_from_lines(input_lines)

# Process movements from the remaining lines
@movements = []
@lines.drop(input_lines.size + 1).each do |line|
  line.chars.each do |char|
    @movements << @directions[char]
  end
end

puts "\nInitial map state:"
@map.print_map

# Process all movements
@movements.each do |direction|
  next unless direction # Skip invalid movements
  @map.move(direction)
end

puts "\nFinal map state:"
@map.print_map

puts "\nSum of box GPS coordinates: #{@map.sum_box_coordinates}"