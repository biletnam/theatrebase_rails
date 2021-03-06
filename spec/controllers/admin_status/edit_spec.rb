require 'rails_helper'

describe AdminStatusController, type: :controller do
  let(:super_admin_user) { create :super_admin_user }
  let(:second_super_admin_user) { create :second_super_admin_user }
  let(:admin_user) { create :admin_user }
  let(:second_admin_user) { create :second_admin_user }
  let(:user) { create :user }
  let(:second_user) { create :user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:second_suspended_super_admin_user) { create :second_suspended_super_admin_user }
  let(:second_suspended_admin_user) { create :second_suspended_admin_user }
  let(:second_suspended_user) { create :second_suspended_user }

  context 'attempt admin status edit as super-admin user' do
    it 'edit admin status of unsuspended user types: various responses' do
      [
        { user: super_admin_user, type: 'super_admin_user', response: redirect_to(root_path) },
        { user: second_super_admin_user, type: 'second_super_admin_user', response: redirect_to(root_path) },
        { user: admin_user, type: 'admin_user', response: render_template(:edit) },
        { user: user, type: 'user', response: render_template(:edit) }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end

    it 'edit admin status of suspended user types: various responses' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user', response: redirect_to(root_path) },
        { user: suspended_admin_user, type: 'suspended_admin_user', response: render_template(:edit) },
        { user: suspended_user, type: 'suspended_user', response: render_template(:edit) }
      ].each do |u|
        session[:user_id] = super_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to u[:response], "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status edit as suspended super-admin user' do
    it 'edit admin status of unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: second_suspended_super_admin_user, type: 'second_suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_super_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status edit as admin user' do
    it 'edit admin status of unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: second_admin_user, type: 'second_admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status edit as suspended admin user' do
    it 'edit admin status of unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: second_suspended_admin_user, type: 'second_suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_admin_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status edit as non-admin user' do
    it 'edit admin status of unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' },
        { user: second_user, type: 'second_user' }
      ].each do |u|
        session[:user_id] = user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' }
      ].each do |u|
        session[:user_id] = user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status edit as suspended non-admin user' do
    it 'edit admin status of unsuspended user types: fail and redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end

    it 'edit admin status of suspended user types: fail and redirect to home page' do
      [
        { user: suspended_super_admin_user, type: 'suspended_super_admin_user' },
        { user: suspended_admin_user, type: 'suspended_admin_user' },
        { user: suspended_user, type: 'suspended_user' },
        { user: second_suspended_user, type: 'second_suspended_user' }
      ].each do |u|
        session[:user_id] = suspended_user.id
        get :edit, user_id: u[:user]
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end

  context 'attempt admin status edit when not logged in' do
    it 'fail and redirect to log in page' do
      get :edit, user_id: user
      expect(response).to redirect_to log_in_path
    end
  end
end
