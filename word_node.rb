class WordNode

  attr_accessor :word, :parent, :children

  def initialize(word, parent = nil)
    @word = word
    @parent = parent
    @children = []
  end

  def add_child(node)
    children << node
    node.parent = self
  end

  def inspect
    word
  end

  def to_s
    "#{word}"
  end

end
