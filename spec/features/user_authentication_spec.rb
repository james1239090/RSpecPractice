require "rails_helper"

RSpec.feature 'User authentication' do
  before(:each) do
    User.create(:email => "user@example.com", :password => "password")
  end

  scenario 'exsit user signs in' do
    new_session_page.sign_in "user@example.com", "password"
    expect(page).to have_content "user@example.com"
  end

  scenario 'user sign out' do
    new_session_page.sign_in "user@example.com", "password"
    navbar.sign_out "user@example.com"

    expect(page).not_to have_content "user@example.com"
  end

  private
  def new_session_page
    home_page.go
    navbar.sign_in
  end

  def home_page
    PageObjects::Pages::Home.new
  end

  def navbar
    PageObjects::Application::Navbar.new
  end
end
