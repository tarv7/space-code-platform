# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PlanetsController, type: :controller do
  let!(:planet_1) { create(:planet, name: 'planet 1', created_at: Date.today.ago(3.year)) }
  let!(:planet_2) { create(:planet, name: 'planet 2', created_at: Date.today.ago(2.year)) }
  let!(:planet_3) { create(:planet, name: 'planet 3', created_at: Date.today.ago(1.year)) }

  let(:expected) do
    [
      {
        'id' => planet_1.id,
        'name' => planet_1.name
      },
      {
        'id' => planet_2.id,
        'name' => planet_2.name
      },
      {
        'id' => planet_3.id,
        'name' => planet_3.name
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
