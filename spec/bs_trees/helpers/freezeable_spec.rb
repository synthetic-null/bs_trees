# frozen_string_literal: true

RSpec.describe BSTrees::Helpers::Freezeable do
  let(:object) do
    Object.new.tap do |object|
      object.extend described_class
    end
  end

  describe '#raise_frozen_error' do
    it 'is private' do
      expect(object).not_to respond_to(:raise_frozen_error)
    end

    it "raises #{FrozenError}" do
      expect { object.__send__(:raise_frozen_error) }.to(
        raise_error(FrozenError)
      )
    end

    it 'sets exception receiver to itself by default' do
      object.__send__(:raise_frozen_error)
    rescue FrozenError => e
      expect(e.receiver).to be(object)
    end

    it 'sets exception receiver to given object' do
      receiver = Object.new
      object.__send__(:raise_frozen_error, receiver)
    rescue FrozenError => e
      expect(e.receiver).to be(receiver)
    end
  end
end
