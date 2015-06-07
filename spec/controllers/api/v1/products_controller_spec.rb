require 'spec_helper'

describe Api::V1::ProductsController do
	describe 'GET #show' do
		before(:each) do
			@product = FactoryGirl.create(:product)
			get :show, id: @product.id
		end

		it 'returns the information about a reporter on hash' do
			product_response = json_response
			expect(product_response[:title]).to eql @product.title
		end

		it { should respond_with 200 }
	end

	describe 'GET #index' do
		before(:each) do
			4.times { FactoryGirl.create(:product) }
			get :index
		end

		it 'returns 4 records from database' do
			product_response = json_response
			expect(product_response[:products]).to have(4).items
		end

		it { should respond_with 200 }
	end

	describe 'POST #create' do
		context 'when is sucessfully created' do
			before(:each) do
				user = FactoryGirl.create(:user)
				@product_attributes = FactoryGirl.attributes_for :product
				api_authorization_header user.auth_token
				post :create, { user_id: user.id, product: @product_attributes }
			end

			it 'renders the json represenation for the product record just created' do
				product_response = json_response
				expect(product_response[:title]).to eql @product_attributes[:title]
			end

			it { should respond_with 201 }
		end

		context 'when is not created' do
			before(:each) do
				user = FactoryGirl.create(:user)
				@invalid_product_attributes = { title: 'Smart TV', price: 'Twelve dollars' }
				api_authorization_header user.auth_token
				post :create, {user_id: user.id, product: @invalid_product_attributes }
			end

			it 'renders an errors in json' do
				product_response = json_response
				expect(product_response).to have_key(:errors)
			end

			it 'renders the json errors on why product could not be created' do
				product_response = json_response
				expect(product_response[:errors][:price]).to include 'is not a number'
			end

			it { should respond_with 422 }
		end
	end

	describe 'PUT/PATCH #update' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@product = FactoryGirl.create(:product, :user => @user)
			api_authorization_header @user.auth_token
		end

		context 'when is sucessfully updated' do
			before(:each) do
				patch :update, { user_id: @user.id, id: @product.id, product: { title: 'An expensive TV'}}
			end

			it 'renders the json representation for the updated user' do
				product_response = json_response
				expect(product_response[:title]).to eql 'An expensive TV'
			end 

			it { should respond_with 200 }
		end

		context 'when is not updated' do
			before(:each) do
				patch :update, { user_id: @user.id, id: @product.id, product: {price: 'two blah'}}
			end

			it 'renders an errors in json' do
				product_response = json_response
				expect(product_response).to have_key(:errors)
			end

			it 'renders the json errors on why thy product could not be updated' do
				product_response = json_response
				expect(product_response[:errors][:price]).to include 'is not a number'
			end

			it { should respond_with 422 }
		end
	end

	describe 'DELETE #destroy' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@product = FactoryGirl.create(:product, user: @user)
			api_authorization_header @user.auth_token
			delete :destroy, { user_id: @user.id, id: @product.id }
		end

		it { should respond_with 204 }
	end
end
























