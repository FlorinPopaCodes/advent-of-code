require 'debug'
# require 'set'
# require 'algorithms'
# include Containers 

# From: https://www.leighhalliday.com/weighted-quick-union-find-algorithm-in-ruby
class UnionFind

  attr_accessor :nodes, :sizes

  def initialize(num)
    self.nodes = []
    self.sizes = []

    num.times do |n|
      self.nodes[n] = n
      self.sizes[n] = 1
    end
  end

  def root(i)
    # Loop up the chain until reaching root
    while nodes[i] != i do
      # path compression for future lookups
      nodes[i] = nodes[nodes[i]]
      i = nodes[i]
    end
    i
  end

  def union(i, j)
    rooti = root i
    rootj = root j

    # already connected
    return if rooti == rootj

    # root smaller to root of larger
    if sizes[i] < sizes[j]
      nodes[rooti] = rootj
      sizes[rootj] += sizes[rooti]
    else
      nodes[rootj] = rooti
      sizes[rooti] += sizes[rootj]
    end
  end

  def connected?(i, j)
    root(i) == root(j)
  end

  def size(i)
    sizes[root(i)]
  end
end

@lines = File.readlines('./2024/Day12/input').map(&:strip)
uf = UnionFind.new(@lines.size * @lines[0].size)

def coord_to_index(y, x)
  y * @lines[0].size + x
end

edges = Array.new(@lines.size) { Array.new(@lines[0].size, false) }

field = @lines.map(&:chars)

field.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    edges[y][x] ||= true if x == 0 || y == 0
    edges[y][x] ||= true if x == @lines[0].size - 1 || y == @lines.size - 1
  end
end

def check_left(field, y, x, uf, edges)
  if field[y][x] == field[y][x+1]
    uf.union(coord_to_index(y, x), coord_to_index(y, x+1))
  else
    edges[y][x] ||= true
    edges[y][x+1] ||= true
  end
end

def check_down(field,y, x, uf, edges)
  if field[y][x] == field[y+1][x]
    uf.union(coord_to_index(y, x), coord_to_index(y+1, x))
  else
    edges[y][x] ||= true
    edges[y+1][x] ||= true
  end
end

field.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    check_left(field, y, x, uf, edges) if x < field[0].size - 1
    check_down(field, y, x, uf, edges) if y < field.size - 1
  end
end

# Edge map
# puts edges.map { |row| row.map { |cell| cell ? 'X' : '.' }.join }.join("\n")

groups = {}
field.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    c = coord_to_index(y, x)
    key = uf.root(c)
    groups[key] ||= { area: uf.size(c), edges: [], legend: field[y][x], perimeter: 0 }
    groups[key][:edges] << [y, x] if edges[y][x]
  end
end

def count_sides(perimeter_edges, edges_map, field_map)
  sides = 0
  perimeter_edges.each do |edge|
    y, x = edge
    sides += 1 if x == 0
    sides += 1 if x == edges_map[0].size - 1
    sides += 1 if y == 0
    sides += 1 if y == edges_map.size - 1

    sides += 1 if x > 0 && field_map[y][x-1] != field_map[y][x]
    sides += 1 if x < edges_map[0].size - 1 && field_map[y][x+1] != field_map[y][x]
    sides += 1 if y > 0 && field_map[y-1][x] != field_map[y][x]
    sides += 1 if y < edges_map.size - 1 && field_map[y+1][x] != field_map[y][x]
  end
  sides
end

groups.each do |_, group|
  group[:perimeter] = count_sides(group[:edges], edges, field)
end

fencing_price = 0 
groups.each do |_, group|
  # p "#{group[:legend]}: #{group[:area]} * #{group[:perimeter]} = #{group[:area] * group[:perimeter]}"
  fencing_price += group[:area] * group[:perimeter]
end
puts "Total fencing price: #{fencing_price}"

