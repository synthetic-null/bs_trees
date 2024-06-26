# frozen_string_literal: true

RSpec.describe BSTrees::Helpers::PrintMethods do
  let(:object) do
    Object.new.tap do |object|
      object.extend described_class
    end
  end

  describe '#to_s' do
    it 'is public method' do
      expect(object).to respond_to(:to_s)
    end
  end

  describe '#inspect' do
    it 'is public method' do
      expect(object).to respond_to(:inspect)
    end
  end

  describe '#pretty_print' do
    it 'is public method' do
      expect(object).to respond_to(:pretty_print)
    end
  end

  describe '#pretty_print_cycle' do
    it 'is public method' do
      expect(object).to respond_to(:pretty_print_cycle)
    end
  end
end
