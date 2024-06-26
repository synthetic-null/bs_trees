# frozen_string_literal: true

RSpec.describe BSTrees::AVL do
  let(:objects) { %w[g d k b e i l a c f h j m] }
  let(:tree) { described_class.new }

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
end
