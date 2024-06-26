# frozen_string_literal: true

RSpec.describe BSTrees::BST do
  let(:objects) { %w[g d k b e i l a c f h j m] }
  let(:tree) { described_class.new }

  describe '::[]' do
    it 'returns an instance of self' do
      expect(described_class[]).to be_an_instance_of(described_class)
    end

    it 'returns tree that includes given objects' do
      expect(described_class[1, 2, 3]).to include(2)
    end
  end

  describe '#initialize' do
    it 'initializes an empty tree' do
      expect(tree).to be_empty
    end

    it 'initializes tree that includes objects from given enum' do
      enum = 1..10
      tree = described_class.new enum

      expect(enum.all?(&tree.method(:include?))).to be(true)
    end
  end

  describe '#initialize_copy' do
    it 'does not affect the original tree integrity' do
      tree.insert_each 1..10
      tree_copy = tree.dup
      tree_copy.delete_each 4..8

      expect(tree_copy.size).to eq(5)
    end
  end

  describe '#==' do
    it 'returns true if called with the same tree' do
      tree.insert_each ('a'..'n').to_a.shuffle

      expect(tree == described_class.new(('a'..'n').to_a.shuffle)).to be(true)
    end

    it 'returns false if called with any other object' do
      expect(tree == Object.new).to be(false)
    end

    it 'returns false if called with instance of superclass' do
      sc_tree = described_class.superclass.new
      expect(tree == sc_tree).to be(false)
    end
  end

  describe '#[]' do
    it 'returns an object from tree' do
      tree.insert 'z'

      expect(tree['z']).to eq('z')
    end
  end

  describe '#<<' do
    it 'inserts an object into tree' do
      tree << 'a'

      expect(tree).to include('a')
    end

    it 'returns itself' do
      expect(tree << 'a').to be(tree)
    end
  end

  describe '#include?' do
    before { tree.insert 'x' }

    it 'returns true if tree includes object' do
      expect(tree).to include('x')
    end

    it 'returns false if tree does not include object' do
      expect(tree).not_to include('y')
    end

    it 'does not raise an error' do
      expect(tree).not_to include(Object.new)
    end
  end

  describe '#empty?' do
    context 'when tree is not empty' do
      before { tree.insert 'a' }

      it 'returns false' do
        expect(tree.empty?).to be(false)
      end
    end
  end

  describe '#size' do
    context 'when tree is not empty' do
      before { tree.insert_each 1..100 }

      it 'returns correct size' do
        expect(tree.size).to eq(100)
      end
    end
  end

  describe '#height' do
    before { tree.insert_each [3, 2, 4, 1] }

    context 'when tree is not empty' do
      it 'returns correct height' do
        expect(tree.height).to eq(2)
      end
    end
  end

  describe '#each_inorder' do
    let(:tree) { described_class.new objects }

    it 'yields objects in correct order' do
      expect(tree.each_inorder.to_a).to eq(
        %w[a b c d e f g h i j k l m]
      )
    end
  end

  describe '#each_preorder' do
    let(:tree) { described_class.new objects }

    it 'yields objects in correct order' do
      expect(tree.each_preorder.to_a).to eq(
        %w[g d b a c e f k i h j l m]
      )
    end
  end

  describe '#each_postorder' do
    let(:tree) { described_class.new objects }

    it 'yields objects in correct order' do
      expect(tree.each_postorder.to_a).to eq(
        %w[a c b f e d h j i m l k g]
      )
    end
  end

  describe '#reverse_each_inorder' do
    let(:tree) { described_class.new objects }

    it 'yields objects in correct order' do
      expect(tree.reverse_each_inorder.to_a).to eq(
        %w[m l k j i h g f e d c b a]
      )
    end
  end

  describe '#clear' do
    it 'returns an empty tree' do
      expect(tree.clear).to be_empty
    end
  end

  describe '#insert_each' do
    it 'returns itself' do
      expect(tree.insert_each(1..4)).to be(tree)
    end

    it 'inserts all objects from enum' do
      tree.insert_each objects

      expect(objects.all?(&tree.method(:include?))).to be(true)
    end
  end

  describe '#delete_each' do
    before { tree.insert_each objects }

    it 'returns itself' do
      expect(tree.delete_each(%w[a z x])).to be(tree)
    end

    it 'deletes all objects from enum' do
      tree.delete_each objects

      expect(objects.none?(&tree.method(:include?))).to be(true)
    end
  end

  describe '#get' do
    before { tree.insert_each objects }

    let(:object) { objects.sample }

    it 'returns nil if object not found' do
      expect(tree.get('z')).to be_nil
    end

    it 'returns correct object' do
      expect(tree.get(object)).to eq(object)
    end

    it "raises #{ArgumentError} if failed to compare objects" do
      expect { tree.get(Object.new) }.to raise_error(ArgumentError)
    end
  end

  describe '#insert' do
    let(:object) { objects.sample }

    it 'returns correct object' do
      expect(tree.insert(object)).to eq(object)
    end

    it 'changes size if tree does not include object' do
      tree.insert object

      expect(tree.size).to eq(1)
    end

    it 'does not change size if tree includes object' do
      10.times { |_| tree.insert object }

      expect(tree.size).to eq(1)
    end

    it "raises #{ArgumentError} if failed to compare objects" do
      tree.insert object

      expect { tree.insert(Object.new) }.to raise_error(ArgumentError)
    end
  end

  describe '#delete' do
    before { tree.insert_each objects }

    let(:object) { objects.sample }

    it 'returns nil if object not found' do
      expect(tree.delete('z')).to be_nil
    end

    it 'returns correct object' do
      expect(tree.delete(object)).to eq(object)
    end

    it 'changes size if tree includes object' do
      tree.delete object

      expect(tree.size).to eq(objects.size - 1)
    end

    it 'does not change size if tree does not include object' do
      10.times { |_| tree.delete object }

      expect(tree.size).to eq(objects.size - 1)
    end

    it "raises #{ArgumentError} if failed to compare objects" do
      expect { tree.delete(Object.new) }.to raise_error(ArgumentError)
    end
  end

  describe '#replace' do
    let(:new_tree) { described_class.new objects }

    it 'returns itself' do
      expect(tree.replace(new_tree)).to be(tree)
    end

    it 'replaces itself correctly' do
      tree.replace new_tree

      expect(tree).to eq(new_tree)
    end
  end
end
