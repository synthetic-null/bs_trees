# frozen_string_literal: true

require 'bs_trees/avl'
require 'forwardable'

class TreeSet
  extend Forwardable

  include Enumerable

  include BSTrees::Helpers::Freezeable
  include BSTrees::Helpers::PrintMethods

  def_delegators :@tree, :include?, :empty?, :size

  alias length size

  def initialize(enum = nil)
    @tree = BSTrees::AVL.new(enum)
  end

  def initialize_dup(orig)
    super

    @tree = orig.instance_variable_get(:@tree).dup
  end

  def initialize_clone(orig, **)
    super

    @tree = orig.instance_variable_get(:@tree).clone(**)
  end

  def freeze
    @tree.freeze

    super
  end

  def each(&)
    if block_given?
      @tree.each(&)

      self
    else
      enum_for(__method__) { size }
    end
  end

  def ==(other)
    other.is_a?(TreeSet) &&
      other.size == size &&
      other.all? { include?(_1) }
  end

  def subset?(other)
    check_type!(other)

    size <= other.size && all? { other.include?(_1) }
  end
  alias <= subset?

  def proper_subset?(other)
    check_type!(other)

    size < other.size && all? { other.include?(_1) }
  end
  alias < proper_subset?

  def superset?(other)
    check_type!(other)

    size >= other.size && other.all? { include?(_1) }
  end
  alias >= superset?

  def proper_superset?(other)
    check_type!(other)

    size > other.size && other.all? { include?(_1) }
  end
  alias > proper_superset?

  def &(other)
    check_type!(other)

    other.each_with_object(self.class.new) do |object, set|
      next unless include?(object)

      set.insert object
    end
  end

  def ^(other)
    check_type!(other)

    each_with_object(other.dup) do |object, set|
      if set.include?(object)
        set.delete object
      else
        set.insert object
      end
    end
  end

  def |(other) = dup.merge other
  alias + |

  def -(other) = dup.subtract other

  def merge(other)
    check_type!(other)

    other.each { |object| insert object }

    self
  end

  def subtract(other)
    check_type!(other)

    other.each { |object| delete object }

    self
  end

  def insert(object)
    raise_frozen_error if frozen?

    @tree.insert object

    self
  end
  alias << insert

  def delete(object)
    raise_frozen_error if frozen?

    @tree.delete object

    self
  end

  private

  def check_type!(object)
    return if object.is_a?(TreeSet)

    raise TypeError, "object must be an instance of #{TreeSet}"
  end
end
