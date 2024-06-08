# frozen_string_literal: true

require 'bs_trees/helpers/freezeable'

module BSTrees
  class BST # rubocop:disable Metrics/ClassLength
    class Node
      attr_accessor :object,
                    :left,
                    :right

      def initialize(object,
                     left = nil,
                     right = nil)

        self.object = object
        self.left = left
        self.right = right
      end

      def height
        1 + [lheight, rheight].max
      end

      def lheight
        left.nil? ? -1 : left.height
      end

      def rheight
        right.nil? ? -1 : right.height
      end
    end

    include Enumerable

    include Helpers::Freezeable

    def self.[](*objects)
      instance = new

      objects.each do |object|
        instance.insert object
      end

      instance
    end

    attr_reader :size
    alias length size

    def initialize(enum = nil)
      self.root = nil
      self.size = 0

      insert_each enum
    end

    def initialize_copy(other)
      raise_frozen_error if frozen?

      unless other.is_a? BST
        raise TypeError,
              "argument must be a kind of #{BST}"
      end

      unless other.equal? self
        clear

        other.each_preorder { |object| insert object }
      end

      self
    end
    alias replace initialize_copy
    public :replace

    def ==(other)
      other.instance_of?(self.class) &&
        other.size == size &&
        other.all? { |object| include? object }
    end

    def [](object) = get object

    def <<(object)
      insert object

      self
    end

    def include?(object)
      node, = find_node object
    rescue ArgumentError
      false
    else
      !node.nil?
    end

    def empty? = root.nil?

    def height
      root.nil? ? 0 : root.height
    end

    def each_inorder(&)
      if block_given?
        _each_inorder(root, &)

        self
      else
        enum_for(__method__) { size }
      end
    end
    alias each each_inorder

    def each_preorder(&)
      if block_given?
        _each_preorder(root, &)

        self
      else
        enum_for(__method__) { size }
      end
    end

    def each_postorder(&)
      if block_given?
        _each_postorder(root, &)

        self
      else
        enum_for(__method__) { size }
      end
    end

    def reverse_each_inorder(&)
      if block_given?
        _reverse_each_inorder(root, &)

        self
      else
        enum_for(__method__) { size }
      end
    end
    alias reverse_each reverse_each_inorder

    def insert_each(enum)
      traverse(enum) { |object| insert object }

      self
    end

    def delete_each(enum)
      traverse(enum) { |object| delete object }

      self
    end

    def get(object)
      node, = find_node object

      return if node.nil?

      node.object
    end

    def insert(object)
      raise_frozen_error if frozen?

      node, parent = find_node object

      if node
        node.object = object
      else
        node = add_node Node.new(object), parent
      end

      node.object
    end

    def delete(object)
      raise_frozen_error if frozen?

      node, parent = find_node object

      return if node.nil?

      node = remove_node node, parent

      node.object
    end

    def clear
      raise_frozen_error if frozen?

      self.root = nil
      self.size = 0

      self
    end

    def to_s
      "#<#{self.class}: {#{to_a.join(', ')}}>"
    end
    alias inspect to_s

    def pretty_print(pp) # :nodoc:
      pp.group(1, "#<#{self.class}:", '>') do
        pp.breakable

        pp.group(1, '{', '}') do
          pp.seplist(self) do |object|
            pp.pp object
          end
        end
      end
    end

    def pretty_print_cycle(pp) # :nodoc:
      pp.text "#<#{self.class}: {#{'...' unless empty?}}>"
    end

    private

    attr_accessor :root

    attr_writer :size

    def _each_inorder(node, &)
      return if node.nil?

      _each_inorder(node.left, &)
      yield node.object
      _each_inorder(node.right, &)
    end

    def _each_preorder(node, &)
      return if node.nil?

      yield node.object
      _each_preorder(node.left, &)
      _each_preorder(node.right, &)
    end

    def _each_postorder(node, &)
      return if node.nil?

      _each_postorder(node.left, &)
      _each_postorder(node.right, &)
      yield node.object
    end

    def _reverse_each_inorder(node, &)
      return if node.nil?

      _reverse_each_inorder(node.right, &)
      yield node.object
      _reverse_each_inorder(node.left, &)
    end

    def traverse(enum, &)
      return if enum.nil?

      unless enum.respond_to? :each
        raise ArgumentError,
              'argument must be enumerable'
      end

      enum.each(&) if block_given?

      enum
    end

    def find_node(object) # rubocop:disable Metrics/MethodLength
      node = root
      parent = nil

      while node
        case object <=> node.object
        when (..-1)
          parent = node
          node = node.left
        when (+1..)
          parent = node
          node = node.right
        when 0
          break
        else
          raise ArgumentError,
                "comprasion of #{object.class} " \
                "with #{node.object.class} failed"
        end
      end

      [node, parent]
    end

    def add_node(node, parent)
      if parent
        case node.object <=> parent.object
        when (..-1) then parent.left = node
        when (+1..) then parent.right = node
        end
      else
        self.root = node
      end

      self.size += 1

      node
    end

    def remove_node(node, parent)
      if node.left && node.right
        succ = shift_leftmost_node(
          node.right, node
        )

        node.object, succ.object =
          succ.object, node.object

        succ
      else
        shift_node node, parent
      end
    end

    def shift_leftmost_node(node, parent)
      while node.left
        parent = node
        node = node.left
      end

      shift_node node, parent
    end

    def shift_node(node, parent)
      succ = node.right || node.left

      if parent.nil?
        self.root = succ
      elsif node.equal? parent.left
        parent.left = succ
      elsif node.equal? parent.right
        parent.right = succ
      end

      self.size -= 1

      node
    end
  end
end
