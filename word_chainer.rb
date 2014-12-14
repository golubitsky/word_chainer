require 'set'
require_relative 'word_node.rb'

class WordChainer
  attr_accessor :dictionary

  def initialize(dictionary_file_name = 'dictionary.txt')
    @dictionary = File.readlines(dictionary_file_name).map(&:strip)
    nil
  end

  def adjacent_words(parent)
    same_length_words = dictionary.select {|word| word.length == parent.length}
    children = []
    generate_regexes(parent).each do |regex|
      same_length_words.select{ |word| word =~ regex }.each do |match|
        children << match
      end
    end
    children
  end

  def run(source, target)
    @all_seen_words = []
    @source = WordNode.new(source)
    adjacent_words(@source.word).map do |word|
      child_node = WordNode.new(word)
      @source.add_child(child_node)
    end
    queue = @source.children
    until queue.empty?
      current_node = queue.shift
      break if current_node.word == target
      adjacent_words(current_node.word).map do |word|
        unless @all_seen_words.include?(word)
          @all_seen_words << word
          child_node = WordNode.new(word)
          current_node.add_child(child_node)
        end
      end
      # p current_node
      current_node.children.each do |child_node|
        queue << child_node
      end
    end
    trace_path_back(current_node, @source)
  end

  def trace_path_back(node, source) #traces back from target to source
    path = [node.word]
    while node.parent
      path << node.parent.word
      node = node.parent
    end
    path.reverse.join('-')
  end
  # private

  def generate_regexes(word)
    regexes = []
    (0..(word.length - 1)).each do |n|
      regex = ''
      regex << word[0...n].to_s
      regex << '.'
      regex << word[(n + 1)..-1].to_s
      regexes << /#{regex}/
    end
    regexes
  end
end

a = WordChainer.new
# p a.adjacent_words("test")
p a.run("test", "love")
