
string = "j'aime aller sur le bord de l'eau les jeudis ou les jours impairs"


class Node
  attr_accessor :weight, :symbol, :left, :right, :parent

  def initialize(params = {})
    @weight   = params[:weight]  || 0
    @symbol   = params[:symbol]  || ''
    @left     = params[:left]    || nil
    @right    = params[:right]   || nil
    @parent   = params[:parent]  || nil
  end

  def walk(&block)
    walk_node('', &block)
  end

  def walk_node(code, &block)
    yield(self, code)
    @left.walk_node(code + '0', &block) unless @left.nil?
    @right.walk_node(code + '1', &block) unless @right.nil?
  end

  def leaf?
    @symbol != ''
  end

  def internal?
    @symbol == ''
  end

  def root?
    internal? and @parent.nil?
  end

  def to_s(nesting = 1)
    string = ''
    nesting.times { string += '-' }
    string += @symbol.to_s + " (#{@weight})\n"
    nesting += 1
    string+= left.to_s(nesting) unless left.nil?
    string+= right.to_s(nesting) unless right.nil?
    string
  end
end

class NodeQueue
  attr_accessor :nodes

  def weights
    weights = {}
    nodes.each do |node|
      weights[node.symbol] = node.weight
    end
    weights
  end

  def self.from_string(string)
    queue = self.new
    frequencies = {}
    string.each_char do |c|
      frequencies[c] ||= 0
      frequencies[c] += 1
    end
    queue.nodes = []
    frequencies.each do |c, w|
      queue.nodes << Node.new(:symbol => c, :weight => w)
    end
    queue
  end

  def merge_nodes(node1, node2)
    left = node1.weight > node2.weight ? node2 : node1
    right = left == node1 ? node2 : node1
    node = Node.new(:weight => left.weight + right.weight, :left => left, :right => right)
    left.parent = right.parent = node
    node
  end

  def generate_tree
    while @nodes.size > 1
      sorted = @nodes.sort { |a,b| a.weight <=> b.weight }
      to_merge = []
      2.times { to_merge << sorted.shift }
      sorted << merge_nodes(to_merge[0], to_merge[1])
      @nodes = sorted
    end
    HuffmanTree.new(@nodes.first)
  end

end

class HuffmanTree
  attr_accessor :root, :lookup
  def initialize(root)
    @root = root
  end

  def lookup
    return @lookup if @lookup
    @lookup = {}
    @root.walk do |node, code|
      @lookup[code] = node.symbol if node.leaf?
    end
    @lookup
  end

  def encode(char)
    self.lookup.invert[char]
  end

  def decode(code)
    self.lookup[code]
  end

  def encode_string(string)
    code = ''
    string.each_char do |c|
      code += encode(c) 
    end
    code
  end

  def decode_string(code)
    string = ''
    subcode = ''
    code.each_char do |bit|
      subcode += bit
      unless decode(subcode).nil?
        string += decode(subcode)
        subcode = ''
      end
    end
    string
  end
end

queue = NodeQueue.from_string(string)
tree = queue.generate_tree
puts tree.encode_string(string)
puts tree.decode_string(tree.encode_string(string))
