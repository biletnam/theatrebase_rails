require 'rails_helper'

ENTRIES_PER_PAGE = 30

feature 'User index page' do
  context 'logged in as admin: 30 < users exist' do
    scenario 'will paginate', js: true do
      create_logged_in_admin_user
      create_list(:list_users, ENTRIES_PER_PAGE)
      visit users_path
      expect(page).to have_css 'div.pagination'
      User.paginate(page: 1).each do |user|
        expect(page).to have_link("#{user.name}", href: user_path(user))
      end
    end
  end

  context 'logged in as admin: 30 >= users exist' do
    scenario 'will not paginate', js: true do
      create_logged_in_admin_user
      create_list(:list_users, ENTRIES_PER_PAGE-1)
      visit users_path
      expect(page).not_to have_css 'div.pagination'
      User.all.each do |user|
        expect(page).to have_link("#{user.name}", href: user_path(user))
      end
    end
  end

  context 'logged in as non-admin' do
    scenario 'redirect to home page', js: true do
      create_logged_in_user
      visit users_path
      expect(page).to have_css 'div.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'not logged in' do
    scenario 'redirect to login page', js: true do
      visit users_path
      expect(page).to have_css 'div.alert-error'
      expect(current_path).to eq login_path
    end
  end

  context 'friendly forwarding: logging in redirects to user index page (if permitted)' do
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'log in as admin; redirect to user index page', js: true do
      visit users_path
      login admin_user
      expect(current_path).to eq users_path
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
    end

    scenario 'log in as non-admin; redirect to home page (user index not permitted)', js: true do
      visit users_path
      login user
      expect(current_path).to eq root_path
      expect(page).to have_css 'div.alert-error'
      expect(page).not_to have_css 'div.alert-success'
    end
  end
end