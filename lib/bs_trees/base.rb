# frozen_string_literal: true

require 'bs_trees/helpers/freezeable'
require 'bs_trees/helpers/print_methods'

module BSTrees
  class Base
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
    include Helpers::PrintMethods

    attr_reader :size
    alias length size

    def initialize
      self.root = nil
      self.size = 0
    end

    def ==(other)
      other.instance_of?(self.class) &&
        other.size == size &&
        other.all? { |object| include? object }
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

    def clear
      raise_frozen_error if frozen?

      self.root = nil
      self.size = 0

      self
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
  end
end
