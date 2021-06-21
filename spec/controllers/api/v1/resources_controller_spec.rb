# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ResourcesController, type: :controller do
  let!(:resource_1) { create(:resource, name: 'food') }
  let!(:resource_2) { create(:resource, name: 'minerals') }
  let!(:resource_3) { create(:resource, name: 'water') }

  let(:expected) do
    [
      {
        'id' => resource_1.id,
        'name' => resource_1.name
      },
      {
        'id' => resource_2.id,
        'name' => resource_2.name
      },
      {
        'id' => resource_3.id,
        'name' => resource_3.name
      }
    ]
  end

  describe 'GET #index' do
    subject { get :index }

    shared_examples 'returns http success' do
      it do
        subject

        expect(response).to have_http_status(:ok)
      end
    end

    it 'returns response expected' do
      subject

      expect(body).to match_array(expected)
    end
  end
end
