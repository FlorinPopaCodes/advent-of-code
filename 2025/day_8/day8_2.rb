# Day 8: Playground

result = 0
lines = File.readlines('./2025/day_8/input').map(&:chomp)
boxes = lines.map { |line| line.split(',').map(&:to_i) }

def distance(box1, box2)
  Math.sqrt(
    (box1[0] - box2[0]) ** 2 +
    (box1[1] - box2[1]) ** 2 +
    (box1[2] - box2[2]) ** 2
  )

end

sorted_pairs = boxes.combination(2).map do |first_box, second_box|
  [first_box, second_box, distance(first_box, second_box)]
end.sort_by { _1[2] }

# Implementation from other day is wrong.
class WeightedQuickUnion
  attr_reader :count, :size

  def initialize(size)
    @ids = (0..size-1).to_a
    @size = Array.new(size, 1)
    @count = size
  end

  def find(index)
    @ids[index] == index ? index : find(@ids[index])
  end

  def connected?(p, q)
    find(p) == find(q)
  end

  def union(p, q)
    return if connected?(p, q)

    root_p, root_q = find(p), find(q)
    bigger?(root_p, root_q) ? join(root_q, root_p) : join(root_p, root_q)

    @count -= 1
  end

  private

  def bigger?(root_1, root_2)
    @size[root_1] > @size[root_2]
  end

  def join(root_1, root_2)
    @ids[root_1] = root_2
    @size[root_2] += @size[root_1]
  end
end


boxes_map = {}

boxes.each_with_index do |box, index|
  boxes_map[box] = index
end

uf = WeightedQuickUnion.new(boxes.size)

(sorted_pairs.size - 1).times do |i|
  box_one, box_two, _ = sorted_pairs[i]

  next if uf.connected?(boxes_map[box_one], boxes_map[box_two])

  uf.union(boxes_map[box_one], boxes_map[box_two])

  if uf.size.max == boxes.size
    p box_one[0] * box_two[0]
    break
  end
end
