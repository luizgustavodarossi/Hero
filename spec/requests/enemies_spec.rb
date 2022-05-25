require 'rails_helper'

RSpec.describe 'Enemies', type: :request do
  describe 'GET /enemies' do
    it 'returns the correct attributes' do
      enemies = create_list(:enemy, FFaker::Random.rand(1..10))
      get enemies_path

      result = json.first.except('created_at', 'updated_at')
      expected = enemies.first.attributes.except('created_at', 'updated_at')
      expect(result).to eq(expected)
    end
  end

  describe 'GET /enemies/:id' do
    context 'when the enemy exists' do
      it 'returns the correct attributes' do
        enemy = create(:enemy)
        get enemy_path(enemy)

        result = json.except('created_at', 'updated_at')
        expected = enemy.attributes.except('created_at', 'updated_at')
        expect(result).to eq(expected)
      end
    end

    context 'when the enemy does not exist' do
      it 'returns a not found message' do
        get '/enemies/0'

        expect(json).to match('message' => "Couldn't find Enemy with 'id'=0")
      end
    end
  end

  describe 'POST /enemies' do
    context 'with valid params' do
      it 'creates a new enemy' do
        enemy_attributes = attributes_for(:enemy)
        post enemies_path, params: enemy_attributes

        expect(Enemy.find(json['id'])).to have_attributes(enemy_attributes)
      end
    end

    context 'with invalid params' do
      it 'does not create a new enemy' do
        post enemies_path, params: { kind: '', name: '', level: '', power_base: '', power_step: 100 }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /enemies' do
    context 'when the enemy exist' do
      let(:enemy) { create(:enemy) }
      let(:enemy_attributes) { attributes_for(:enemy) }

      before(:each) { put "/enemies/#{enemy.id}", params: enemy_attributes }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the enemy' do
        expect(enemy.reload).to have_attributes(enemy_attributes)
      end

      it 'returns the updated enemy' do
        expect(enemy.reload).to have_attributes(json.except('created_at', 'updated_at'))
      end
    end

    context 'when the enemy does not exist' do
      before(:each) { put '/enemies/0', params: { enemy: attributes_for(:enemy) } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end

  describe 'DELETE /enemies' do
    context 'when the enemy exist' do
      let(:enemy) { create(:enemy) }
      before(:each) { delete "/enemies/#{enemy.id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'destroy the enemy' do
        expect { enemy.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when the enemy does not exist' do
      before(:each) { delete '/enemies/0' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end
end
