# frozen_string_literal: true

require 'bs_trees/bst'

module BSTrees
  class AVL < BST
    class Node < BST::Node
      attr_accessor :height

      def initialize(*)
        super

        adjust_height
      end

      def balance = lheight - rheight

      def adjust_height
        self.height = 1 + [lheight, rheight].max
      end

      def restore_balance
        case balance
        when -1, 0, +1 then return false
        when -2
          right.balance <= 0 ? rotate_l : rotate_rl
        when +2
          left.balance >= 0 ? rotate_r : rotate_lr
        else
          raise format('abnormal balance factor: %+i', balance)
        end

        true
      end

      private

      def rotate_rl
        right.__send__ :rotate_r
        rotate_l
      end

      def rotate_lr
        left.__send__ :rotate_l
        rotate_r
      end

      def rotate_r # rubocop:disable Metrics/AbcSize
        self.object, left.object = left.object, object
        self.right, left.left = left.left, right
        left.left, left.right = left.right, left.left
        self.left, self.right = right, left

        right.adjust_height
        adjust_height
      end

      def rotate_l # rubocop:disable Metrics/AbcSize
        self.object, right.object = right.object, object
        self.left, right.right = right.right, left
        right.right, right.left = right.left, right.right
        self.right, self.left = left, right

        left.adjust_height
        adjust_height
      end
    end

    def insert(object)
      raise_frozen_error if frozen?

      inserted = find_avl_node(object) do |node, parent|
        if node
          node.object = object
        else
          node = add_node Node.new(object), parent
        end

        node
      end

      inserted.object
    end

    def delete(object)
      raise_frozen_error if frozen?

      deleted = find_avl_node(object) do |node, parent|
        next if node.nil?

        remove_node node, parent
      end

      return if deleted.nil?

      deleted.object
    end

    private

    def find_avl_node(object, # rubocop:disable Metrics/MethodLength
                      node = root,
                      parent = nil,
                      &)

      return yield node, parent if node.nil?

      case object <=> node.object
      when (..-1)
        result = find_avl_node(object,
                               node.left,
                               node,
                               &)
      when (+1..)
        result = find_avl_node(object,
                               node.right,
                               node,
                               &)
      when 0
        result = yield node, parent
      else
        raise ArgumentError,
              "comprasion of #{object.class} " \
              "with #{node.object.class} failed"
      end

      node.adjust_height
      node.restore_balance

      result
    end

    def shift_leftmost_node(node, parent)
      if node.left
        result = shift_leftmost_node(
          node.left, node
        )

        node.adjust_height
        node.restore_balance

        result
      else
        shift_node node, parent
      end
    end
  end
end
