# frozen_string_literal: true

require 'bs_trees/base'

module BSTrees
  class BST < Base # rubocop:disable Metrics/ClassLength
    def self.[](*objects)
      instance = new

      objects.each do |object|
        instance.insert object
      end

      instance
    end

    def initialize(enum = nil)
      super()

      insert_each enum
    end

    def initialize_copy(other)
      raise_frozen_error if frozen?

      unless other.is_a? BST
        raise TypeError,
              "argument must be a kind of #{BST}"
      end

      safe_initialize_copy!(other)
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

    def replace(other)
      initialize_copy other

      self
    end

    private

    def safe_initialize_copy!(other)
      old_root = root
      old_size = size

      clear

      other.each_preorder { |object| insert object }
    rescue StandardError
      self.root = old_root
      self.size = old_size
    else
      self
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
