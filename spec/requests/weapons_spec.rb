require 'rails_helper'

RSpec.describe 'Weapons', type: :request do
  describe 'GET /weapons' do
    it 'the weapon\'s name is present' do
      weapons = create_list(:weapon, FFaker::Random.rand(1..10))
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include(weapon.name)
      end
    end

    it 'checks if the weapon has the correct link' do
      weapons = create_list(:weapon, FFaker::Random.rand(1..10))
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include(weapon_path(weapon))
      end
    end

    it 'the weapon\'s title is present' do
      weapons = create_list(:weapon, FFaker::Random.rand(1..10))
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include(weapon.title)
      end
    end

    it 'the weapon\'s current power is present' do
      weapons = create_list(:weapon, FFaker::Random.rand(1..10))
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include(weapon.current_power.to_s)
      end
    end
  end

  describe 'GET /weapons/:id' do
    it 'returns all data for a weapon' do
      weapon = create(:weapon)
      get weapon_path(weapon)

      expect(response.body).to include(weapon.name)
      expect(response.body).to include(weapon.description)
      expect(response.body).to include(weapon.level.to_s)
      expect(response.body).to include(weapon.power_base.to_s)
      expect(response.body).to include(weapon.power_step.to_s)
      expect(response.body).to include(weapon.current_power.to_s)
      expect(response.body).to include(weapon.title)
    end
  end

  describe 'POST /weapons' do
    context 'when it has valid parameters' do
      it 'creates the weapon with correct atributes' do
        weapon_attributes = FactoryBot.attributes_for(:weapon)
        post weapons_path, params: { weapon: weapon_attributes }
        expect(Weapon.last).to have_attributes(weapon_attributes)
      end
    end

    context 'when it has invalid parameters' do
      it 'does not create the weapon' do
        expect do
          post weapons_path, params: { weapon: { name: '', power_base: nil, power_step: nil, level: nil } }
        end.to_not change(Weapon, :count)
      end
    end
  end

  describe 'DELETE /weapons/:id' do
    it 'delete a weapon' do
      weapon = create(:weapon)
      expect do
        delete weapon_path(weapon)
      end.to change(Weapon, :count).by(-1)
    end

    it 'delete a weapon and redirect to the index' do
      weapon = create(:weapon)
      delete weapon_path(weapon)
      expect(response).to redirect_to weapons_path
    end
  end
end
