# frozen_string_literal: true

RSpec.describe BSTrees::Base do
  let(:tree) { described_class.new }

  describe BSTrees::Base::Node do
    let(:node) do
      described_class.new(nil).tap do |node|
        node.left = described_class.new(nil)
        node.left.left = described_class.new(nil)
        node.right = described_class.new(nil)
      end
    end

    it 'has reader :object' do
      expect(node).to respond_to(:object)
    end

    it 'has writer :object=' do
      expect(node).to respond_to(:object=)
    end

    it 'has reader :left' do
      expect(node).to respond_to(:left)
    end

    it 'has writer :left=' do
      expect(node).to respond_to(:left=)
    end

    it 'has reader :right' do
      expect(node).to respond_to(:right)
    end

    it 'has writer :right=' do
      expect(node).to respond_to(:right=)
    end

    it 'must be initialized with object' do
      object = Object.new
      node = described_class.new(object)

      expect(node.instance_variable_get(:@object)).to eq(object)
    end

    describe '#height' do
      context 'when has no children' do
        let(:node) { described_class.new(nil) }

        it 'returns 0' do
          expect(node.height).to eq(0)
        end
      end

      context 'when have children' do
        it 'returns correct height' do
          expect(node.height).to eq(2)
        end
      end
    end

    describe '#lheight' do
      context 'when it has not left child' do
        it 'returns -1' do
          node.left = nil
          expect(node.lheight).to eq(-1)
        end
      end

      context 'when it has left child' do
        it 'returns correct height' do
          expect(node.lheight).to eq(1)
        end
      end
    end

    describe '#rheight' do
      context 'when it has not right child' do
        it 'returns -1' do
          node.right = nil
          expect(node.rheight).to eq(-1)
        end
      end

      context 'when it has right child' do
        it 'returns correct height' do
          expect(node.rheight).to eq(0)
        end
      end
    end
  end

  it "includes #{Enumerable} module" do
    expect(described_class).to include(Enumerable)
  end

  describe '#initialize' do
    it 'initializes an empty tree' do
      expect(tree).to be_empty
    end
  end

  describe '#==' do
    it 'returns true if called with the same tree' do
      expect(tree == described_class.new).to be(true)
    end

    it 'returns false if called with any other object' do
      expect(tree == Object.new).to be(false)
    end
  end

  describe '#empty?' do
    context 'when tree is empty' do
      it 'returns true' do
        expect(tree.empty?).to be(true)
      end
    end
  end

  describe '#size' do
    context 'when tree is empty' do
      it 'returns 0' do
        expect(tree.size).to eq(0)
      end
    end

    it 'cannot be assigned' do
      expect(tree).not_to respond_to(:size=)
    end

    it 'has an alias #length' do
      expect(tree).to respond_to(:length)
    end
  end

  describe '#height' do
    context 'when tree is empty' do
      it 'returns 0' do
        expect(tree.height).to eq(0)
      end
    end
  end

  describe '#each_inorder' do
    context 'when called with block' do
      it 'returns itself' do
        expect(tree.each_inorder { nil }).to be(tree)
      end
    end

    context 'when called without block' do
      it "returns an instance of #{Enumerator}" do
        expect(tree.each_inorder).to be_an_instance_of(Enumerator)
      end
    end

    it 'has an alias #each' do
      expect(tree).to respond_to(:each)
    end
  end

  describe '#each_preorder' do
    context 'when called with block' do
      it 'returns itself' do
        expect(tree.each_preorder { nil }).to be(tree)
      end
    end

    context 'when called without block' do
      it "returns an instance of #{Enumerator}" do
        expect(tree.each_preorder).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe '#each_postorder' do
    context 'when called with block' do
      it 'returns itself' do
        expect(tree.each_postorder { nil }).to be(tree)
      end
    end

    context 'when called without block' do
      it "returns an instance of #{Enumerator}" do
        expect(tree.each_postorder).to be_an_instance_of(Enumerator)
      end
    end
  end

  describe '#reverse_each_inorder' do
    context 'when called with block' do
      it 'returns itself' do
        expect(tree.reverse_each_inorder { nil }).to be(tree)
      end
    end

    context 'when called without block' do
      it "returns an instance of #{Enumerator}" do
        expect(tree.reverse_each_inorder).to be_an_instance_of(Enumerator)
      end
    end

    it 'has an alias #reverse_each' do
      expect(tree).to respond_to(:reverse_each)
    end
  end

  describe '#clear' do
    context 'when tree is frozen' do
      it 'raises an error' do
        expect { tree.freeze.clear }.to raise_error(FrozenError)
      end
    end

    it 'returns itself' do
      expect(tree.clear).to be(tree)
    end
  end
end
