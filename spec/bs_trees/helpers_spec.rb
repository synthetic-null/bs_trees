# frozen_string_literal: true

RSpec.describe BSTrees::Helpers do
  it 'contains module Freezeable' do
    module_ = described_class.const_get :Freezeable
    expect(module_).to be_an_instance_of(Module)
  end

  it 'contains module PrintMethods' do
    module_ = described_class.const_get :PrintMethods
    expect(module_).to be_an_instance_of(Module)
  end
end
