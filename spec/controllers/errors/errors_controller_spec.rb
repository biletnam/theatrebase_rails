require 'rails_helper'

describe ErrorsController, type: :controller do
  context '404 Error (Not Found) occurs' do
    it 'displays 404 Error display page' do
      get :error_404
      expect(response).to render_template :error_404
    end
  end

  context '422 Error (Unprocessable Entity) occurs' do
    it 'displays 422 Error display page' do
      get :error_422
      expect(response).to render_template :error_422
    end
  end

  context '500 Error (Internal Server Error) occurs' do
    it 'displays 500 Error display page' do
      get :error_500
      expect(response).to render_template :error_500
    end
  end
end
