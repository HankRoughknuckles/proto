require "spec_helper"

describe "The landing page" do
  let(:landing_page) { LandingPage.new() }
  let(:login) { LoginPage.new() }
  let(:ideas) { IdeaIndexPage.new() }

  context 'when logged in' do
    let(:user) { FactoryGirl.create(:user) }
    before { landing_page.visit_page_as user }

    it 'should redirect to the ideas index' do
      expect(page).to have_title ideas.title
    end
  end

  context 'when not logged in' do
    before { landing_page.visit_page_as(nil) }

    it 'should redirect to the authentication page' do
      auth_page = AuthenticationPage.new
      expect(page).to have_title auth_page.title
    end
  end
end
