require 'rails_helper'

RSpec.describe Category, type: :model do
  it { expect(Category.new).to respond_to :ideas }
end
