require 'rails_helper'

RSpec.describe Api::V1::Contracts::OpenedsController, type: :controller do
  let!(:openeds) { create_list(:contract, 3, :opened) }
  let!(:processings) { create_list(:contract, 4, :processing) }
  let!(:finisheds) { create_list(:contract, 5, :finished) }

  describe "GET #index" do
    subject { get :index }

    it "returns http success" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it 'returns only opened contracts' do
      subject

      body = JSON.parse(response.body).map(&:deep_symbolize_keys)

      response_ids = body.map{ |contract| contract[:id] }
      expect(response_ids).to match_array(openeds.map(&:id))
    end
  end
end
