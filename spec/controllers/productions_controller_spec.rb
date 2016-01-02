require 'rails_helper'

describe ProductionsController, type: :controller do
  let!(:user) { create :user }
  let(:production) { attributes_for :production }
  let!(:second_production) { create :second_production }

  context 'attempt add new production' do
    it 'when logged in: render new production form' do
      session[:user_id] = user.id
      get :new
      expect(response).to render_template(:new)
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :new
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create new production' do
    it 'when logged in: succeed and redirect to production page' do
      session[:user_id] = user.id
      expect { post :create, production: { title: production[:title] } }.to change { Production.count }.by 1
      expect(response).to redirect_to production_path(Production.last)
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { post :create, production: { title: production[:title] } }.to change { Production.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt edit production' do
    it 'when logged in: succeed and redirect to production edit page' do
      session[:user_id] = user.id
      get :edit, id: second_production
      expect(response).to render_template(:edit)
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :edit, id: second_production
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update production' do
    it 'when logged in: succeed and redirect to production page' do
      session[:user_id] = user.id
      get :edit, id: second_production
      expect(response).to render_template(:edit)
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :edit, id: second_production
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt delete production' do
    it 'when logged in: succeed and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, id: second_production }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :edit, id: second_production
      expect { delete :destroy, id: second_production }.to change { Production.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end
end
