require "spec_helper"

describe "The landing page" do
  let(:ui) { LandingPage.new() }

  context 'when logged in' do
    let(:user) { FactoryGirl.create(:user) }
    before { ui.visit_page_as user }

    it 'should redirect to the ideas index' do
      expect(page).to have_title "Ideas"
    end
  end

  context 'when not logged in' do
    before { ui.visit_page_as(nil) }

    it 'should have a signup form' do
      expect(ui).to have_signup_form
    end

    it 'should have proto for a title' do
      expect(ui).to have_proper_title
    end

    it 'should have a link to the login page'
  end

  describe "the signup form" do
    before { ui.visit_page_as nil }

    it 'should go to the Ideas index upon logging in'

    it 'should flash an error if the email is missing'

    it 'should flash an error if the password is missing'
  end
end
