require 'debug'
require 'set'

class PushBoxGame
  ROBOT = '@'
  BOX_LEFT = '['
  BOX_RIGHT = ']'
  WALL = '#'
  EMPTY = '.'
  
  DIRECTIONS = {
    '<' => :left,
    '^' => :up,
    '>' => :right,
    'v' => :down
  }.freeze

  def initialize(input_file)
    @map = Map.new
    load_game(input_file)
  end

  def play
    puts "\nInitial map state:"
    @map.print_map

    @movements.each do |direction|
      @map.move(direction)
    end

    puts "\nFinal map state:"
    @map.print_map
    
    @map.sum_box_coordinates
  end

  private

  def load_game(input_file)
    lines = File.readlines(input_file).map(&:strip)
    input_lines = lines.take_while { |line| !line.empty? }
    @map.initialize_from_lines(input_lines)
    
    @movements = lines.drop(input_lines.size + 1)
      .flat_map(&:chars)
      .map { |char| DIRECTIONS[char] }
      .compact
  end
end

class Map
  ROBOT = '@'
  BOX_LEFT = '['
  BOX_RIGHT = ']'
  WALL = '#'
  EMPTY = '.'

  attr_reader :current_position, :map

  def initialize
    @map = []
    @current_position = nil
  end

  def initialize_from_lines(lines)
    @map = lines.map do |line|
      line.chars.flat_map do |char|
        case char
        when '#' then ['#', '#']
        when 'O' then ['[', ']']
        when '.' then ['.', '.']
        when '@' then ['@', '.']
        end
      end
    end

    find_robot_position
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

  def advance_robot(direction)
    next_pos = next_position(@current_position, direction)
    return false unless within_bounds?(next_pos)
    
    cell = get_position(next_pos)
    return false if cell == WALL
    
    if cell == EMPTY
      swap_contents(@current_position, next_pos)
      @current_position = next_pos
      return true
    end
    
    false
  end
  
  def move_boxes(boxes, direction)
    return false if boxes.empty? 

    boxes.reverse.each do |box_positions|
      left, right = box_positions

      if direction == :right || direction == :down
        next_right = next_position(right, direction)
        next_left = next_position(left, direction)
        swap_contents(right, next_right)
        swap_contents(left, next_left)

      else
        next_left = next_position(left, direction)
        next_right = next_position(right, direction)
        swap_contents(left, next_left)
        swap_contents(right, next_right)
      end
    end
  end
  
  def move(direction)
    next_pos = next_position(@current_position, direction)
    return false if is_wall?(next_pos)
    return advance_robot(direction) if is_empty?(next_pos)
    
    elements = elements_to_wall(direction)
    return false if elements.empty?
    
    # Group elements by depth
    elements_by_depth = elements.group_by { |e| e[:depth] }
    boxes = []
    
    # Process each depth level in order
    elements_by_depth.keys.sort.each do |depth|
      depth_elements = elements_by_depth[depth]
      
      break if depth_elements.any? { |e| e[:value] == WALL }
      break if depth_elements.none? { |e| e[:value] == BOX_LEFT || e[:value] == BOX_RIGHT }

      # Process elements in pairs at this depth
      depth_elements.reject { |e| e[:value] == EMPTY }.each_slice(2) do |left, right|    
        # WE might have a bug here as a space might come first
        next unless left && right # Skip if we don't have a complete pair
        
        if is_box_pair?(left[:position], right[:position])
          boxes << [left[:position], right[:position]]
        end
      end
    end
    
    move_boxes(boxes, direction)
    advance_robot(direction)
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
    visited = Set.new
    to_visit = [[next_position(@current_position, direction), 0]]
    
    while !to_visit.empty?
      pos, depth = to_visit.shift
      next if !within_bounds?(pos) || visited.include?(pos)
      visited << pos
      
      cell = get_position(pos)
      elements << { position: pos, value: cell, depth: depth }
      
      # Stop this path if we hit a wall
      next if cell == WALL
      
      row, col = pos
      neighbors = []
      
      if is_box?(pos)
        # Check the other part of the box
        if cell == BOX_LEFT && col + 1 < @map[0].size
          neighbors << [[row, col + 1], depth]
        elsif cell == BOX_RIGHT && col - 1 >= 0
          neighbors << [[row, col - 1], depth]
        end
        
        # TODO: don't add the the next box if it has spaces above it.
        # Check boxes that could be pushed by this box
        case direction
        when :up, :down
          # Check the next position in movement direction
          next_row = direction == :up ? row - 1 : row + 1
          if next_row >= 0 && next_row < @map.size
            neighbors << [[next_row, col], depth + 1]
          end
        when :left, :right
          # For horizontal movement, just check the next position
          next_col = direction == :left ? col - 1 : col + 1
          if next_col >= 0 && next_col < @map[0].size
            neighbors << [[row, next_col], depth + 1]
          end
        end
      end
      
      # Add unvisited neighbors to the queue, maintaining order by depth
      neighbors.each do |neighbor_pos, new_depth|
        next if visited.include?(neighbor_pos)
        insert_idx = to_visit.bsearch_index { |_, d| d > new_depth } || to_visit.size
        to_visit.insert(insert_idx, [neighbor_pos, new_depth])
      end
    end
    
    elements_wo_spaces = elements.sort_by { |e| e[:depth] }.group_by { |e| e[:depth] }.map { |_, v| v.all? { |e| e[:value] == EMPTY } ? nil : v }
    
    first_empty_row = elements_wo_spaces.index(nil)

    return [] if !first_empty_row

    elements_wo_spaces[0...first_empty_row].flatten.sort_by { |e| [e[:depth], e[:position]] }
  end

  def is_empty?(position)
    row, col = position
    @map[row][col] == EMPTY
  end

  def is_wall?(position)
    row, col = position
    @map[row][col] == WALL
  end

  def is_box?(position)
    row, col = position
    @map[row][col] == BOX_LEFT || @map[row][col] == BOX_RIGHT
  end

  def is_box_pair?(left_pos, right_pos)
    left_row, left_col = left_pos
    right_row, right_col = right_pos
    return false unless left_row == right_row && right_col == left_col + 1
    @map[left_row][left_col] == BOX_LEFT && @map[right_row][right_col] == BOX_RIGHT
  end

  def calculate_gps_coordinate(position)
    row, col = position
    # Convert wide coordinates back to original
    row * 100 + (col / 2)
  end

  def sum_box_coordinates
    total = 0
    @map.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        # Only count GPS for the left part of the box
        if cell == BOX_LEFT
          total += calculate_gps_coordinate([r, c])
        end
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

  def find_robot_position
    @map.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        @current_position = [r, c] if cell == ROBOT
      end
    end
  end
end