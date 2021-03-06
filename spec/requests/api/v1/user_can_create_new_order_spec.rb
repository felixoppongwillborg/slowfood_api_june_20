RSpec.describe 'POST /api/v1/orders', type: :request do
  let!(:product) { create(:product, name: 'Pokebowl', price: 30) }
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:user_headers) { { HTTP_ACCEPT: 'application/json'}.merge!(credentials) }

  describe 'successfully' do
	  before do
      post '/api/v1/orders', 
      params: { product_id: product.id },
      headers: user_headers
    end
    
    it ' responds with 200 status' do
      expect(response.status).to eq 200
    end

    it 'responds with success message' do
      expect(response_json['message']).to eq 'The product has been added to your order'
    end

    it 'responds with order_id ' do 
      expect(response_json['order']['id']).to eq Order.last.id
    end

    it "responds with the right amount of products currently in the order" do
      expect(response_json['order']['products'].count).to eq 1
    end

    it "responds with current order total" do
      expect(response_json['order']['total']).to eq 30
    end
  end
end  