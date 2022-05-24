require 'rails_helper'
require 'ffaker'

RSpec.describe User, type: :model do
  it 'is invalid if the level is not between 1 and 99' do
    user = build(:user, level: FFaker::Random.rand(100..9999))

    expect(user).to be_invalid
  end

  it 'returns the correct hero title' do
    user = build(:user)

    expect(user.title).to eq("#{user.kind} #{user.nickname} ##{user.level}")
  end
end
