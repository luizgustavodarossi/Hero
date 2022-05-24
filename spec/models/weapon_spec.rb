require 'rails_helper'

RSpec.describe Weapon, type: :model do
  it 'is invalid if the name is not present' do
    weapon = build(:weapon, name: nil)

    expect(weapon).to be_invalid
  end

  it 'is invalid if the power_step is not greater than 0' do
    weapon = build(:weapon, power_step: -1)

    expect(weapon).to be_invalid
  end

  it 'is invalid if the power_base is not greater than 0' do
    weapon = build(:weapon, power_base: -1)

    expect(weapon).to be_invalid
  end

  it 'is invalid if the level is not between 1 and 99' do
    weapon = build(:weapon, level: FFaker::Random.rand(100..9999))

    expect(weapon).to be_invalid
  end

  it 'returns the correct weapon title' do
    weapon = build(:weapon)

    expect(weapon.title).to eq("#{weapon.name} ##{weapon.level}")
  end

  it 'returns the correct weapon power' do
    weapon = build(:weapon)

    expect(weapon.current_power).to eq(weapon.power_base + ((weapon.level - 1) * weapon.power_step))
  end
end
