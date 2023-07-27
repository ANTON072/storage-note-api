require 'rails_helper'

RSpec.describe "V1::Stocks", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/v1/stocks/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/v1/stocks/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/v1/stocks/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/v1/stocks/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/v1/stocks/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
