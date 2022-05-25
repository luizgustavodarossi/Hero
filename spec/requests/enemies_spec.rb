require 'rails_helper'

RSpec.describe 'Enemies', type: :request do
  describe '#index' do
    let(:enemies) { create_list(:enemy, FFaker::Random.rand(1..10)) }
    before(:each) { get enemies_path }

    it 'returns with status 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all correct attributes' do
      json.size.times do |index|
        expect(json[index]).to eq(enemies[index].as_json)
      end
    end
  end

  describe '#show' do
    context 'when exists' do
      let(:enemy) { create(:enemy) }
      before(:each) { get enemy_path enemy }

      it 'returns with status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all correct attributes' do
        expect(json).to eq(enemy.as_json)
      end
    end

    context 'when does not exist' do
      before(:each) { get '/enemies/0' }

      it 'returns with status 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    context 'with valid params' do
      let(:valid_params) { attributes_for(:enemy) }
      before(:each) { post enemies_path, params: valid_params }

      it 'returns with status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns with correct attributes' do
        expect(json).to eq(Enemy.last.as_json)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { attributes_for(:enemy, name: nil) }
      before(:each) { post enemies_path, params: invalid_params }

      it 'returns with status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#update' do
    context 'when exist' do
      let(:enemy) { create(:enemy) }

      context 'with valid params' do
        let(:valid_params) { attributes_for(:enemy) }
        before(:each) { put enemy_path enemy, params: valid_params }

        it 'returns with status 200' do
          expect(response).to have_http_status(:success)
        end

        it 'returns with correct attributes' do
          expect(json).to eq(enemy.reload.as_json)
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { attributes_for(:enemy, name: '') }
        before(:each) { put enemy_path enemy, params: invalid_params }

        it 'returns with status 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns message error' do
          expect(json['errors']['name']).to include("can't be blank")
        end
      end
    end

    context 'when does not exist' do
      let(:params) { attributes_for(:enemy) }
      before(:each) { put '/enemies/0', params: { enemy: params } }

      it 'returns with status 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns message error' do
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end

  describe '#destroy' do
    context 'when exist' do
      let(:enemy) { create(:enemy) }
      before(:each) { delete enemy_path enemy }

      it 'returns with status 204' do
        expect(response).to have_http_status(204)
      end

      it 'checks if enemy was deleted' do
        expect(Enemy.find_by(id: enemy.id)).to be_nil
      end
    end

    context 'when does not exist' do
      before(:each) { delete '/enemies/0' }

      it 'returns with status 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end
end
