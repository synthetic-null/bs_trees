# frozen_string_literal: true

module BSTrees
  module Helpers
    module PrintMethods
      def inspect
        "#<#{self.class}: {#{to_a.inspect[1..-2]}}>"
      end
      alias to_s inspect

      def pretty_print(pp) # :nodoc:
        pp.group(1, "#<#{self.class}:", '>') do
          pp.breakable

          pp.group(1, '{', '}') do
            pp.seplist(self) do |object|
              pp.pp object
            end
          end
        end
      end

      def pretty_print_cycle(pp) # :nodoc:
        pp.text "#<#{self.class}: {#{'...' unless empty?}}>"
      end
    end
  end
end
