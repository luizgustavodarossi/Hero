require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    it 'returns success status' do
      get users_path
      expect(response).to have_http_status(:success)
    end

    it 'the user\'s title is present' do
      users = create_list(:user, FFaker::Random.rand(1..10))
      get users_path
      users.each do |user|
        expect(response.body).to include(user.title)
      end
    end

    context 'when it has valid parameters' do
      it 'creates the user with correct atributes' do
        user_attributes = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_attributes }
        expect(User.last).to have_attributes(user_attributes)
      end
    end

    context 'when it has invalid parameters' do
      it 'does not create the user' do
        expect do
          post users_path, params: { user: { kind: '', name: '', level: '' } }
        end.to_not change(User, :count)
      end
    end
  end
end
