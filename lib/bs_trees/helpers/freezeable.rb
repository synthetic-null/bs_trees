# frozen_string_literal: true

module BSTrees
  module Helpers
    module Freezeable
      private

      def raise_frozen_error(receiver = self)
        raise FrozenError.new(
          "can't modify frozen #{receiver.class}",
          receiver:
        )
      end
    end
  end
end
