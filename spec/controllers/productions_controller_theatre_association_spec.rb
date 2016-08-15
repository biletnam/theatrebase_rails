require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:add_production) { attributes_for :add_production }
  let(:add_theatre) { attributes_for :add_theatre }
  let(:theatre) { attributes_for :theatre }
  let!(:production) { create :production }

  let(:production_params) {
    {
      title: add_production[:title],
      first_date: add_production[:first_date],
      last_date: add_production[:last_date],
      press_date_wording: '',
      dates_tbc_note: '',
      dates_note: ''
    }
  }

  let(:non_existing_theatre) {
    { name: add_theatre[:name] }
  }

  let(:existing_theatre) {
    { name: theatre[:name] }
  }

  before(:each) do
    session[:user_id] = user.id
  end

  context 'creating production with associated theatre' do
    it 'theatre does not exist: new theatre is created and used for association' do
      production_params[:theatre_attributes] = non_existing_theatre
      expect { post :create, production: production_params }.to change { Theatre.count }.by 1
      production = Production.last
      theatre = Theatre.last
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end

    it 'theatre exists: existing theatre is used for association' do
      production_params[:theatre_attributes] = existing_theatre
      expect { post :create, production: production_params }.to change { Theatre.count }.by 0
      production = Production.last
      theatre = Theatre.first
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end
  end

  context 'setting creator and updater associations of theatre when production is created' do
    it 'theatre does not exist: theatre associates current user as creator and updater' do
      production_params[:theatre_attributes] = non_existing_theatre
      post :create, production: production_params
      theatre = Theatre.last
      expect(theatre.creator).to eq user
      expect(theatre.updater).to eq user
      expect(user.created_theatres).to include theatre
      expect(user.updated_theatres).to include theatre
    end

    it 'theatre exists: theatre retains its existing associated creator and updater' do
      theatre = Theatre.first
      creator = theatre.creator
      updater = theatre.updater
      production_params[:theatre_attributes] = existing_theatre
      post :create, production: production_params
      theatre.reload
      expect(theatre.creator).to eq creator
      expect(theatre.creator).not_to eq user
      expect(theatre.updater).to eq updater
      expect(theatre.updater).not_to eq user
      expect(creator.created_theatres).to include theatre
      expect(user.created_theatres).not_to include theatre
      expect(updater.updated_theatres).to include theatre
      expect(user.updated_theatres).not_to include theatre
    end
  end

  context 'updating production with associated theatre' do
    it 'theatre does not exist: new theatre is created and used for association' do
      production_params[:theatre_attributes] = non_existing_theatre
      expect { patch :update, id: production.id, url: production.url, production: production_params }
        .to change { Theatre.count }.by 1
      theatre = Theatre.last
      production.reload
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end

    it 'theatre exists: existing theatre is used for association' do
      production_params[:theatre_attributes] = existing_theatre
      expect { patch :update, id: production.id, url: production.url, production: production_params }
        .to change { Theatre.count }.by 0
      theatre = Theatre.first
      production.reload
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end
  end

  context 'setting creator and updater associations of theatre when production is updated' do
    it 'theatre does not exist: theatre associates current user as creator and updater' do
      production_params[:theatre_attributes] = non_existing_theatre
      patch :update, id: production.id, url: production.url, production: production_params
      theatre = Theatre.last
      expect(theatre.creator).to eq user
      expect(theatre.updater).to eq user
      expect(user.created_theatres).to include theatre
      expect(user.updated_theatres).to include theatre
    end

    it 'theatre exists: theatre retains its existing associated creator and updater' do
      theatre = Theatre.first
      creator = theatre.creator
      updater = theatre.updater
      production_params[:theatre_attributes] = existing_theatre
      patch :update, id: production.id, url: production.url, production: production_params
      theatre.reload
      expect(theatre.creator).to eq creator
      expect(theatre.creator).not_to eq user
      expect(theatre.updater).to eq updater
      expect(theatre.updater).not_to eq user
      expect(creator.created_theatres).to include theatre
      expect(user.created_theatres).not_to include theatre
      expect(updater.updated_theatres).to include theatre
      expect(user.updated_theatres).not_to include theatre
    end
  end
end