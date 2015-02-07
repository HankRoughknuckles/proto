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

    it 'should have an icon image link' do
      landing_page.click_icon_link

      expect(page).to have_title landing_page.title
    end

    it 'should have a signup form' do
      expect(landing_page).to have_signup_form
    end

    it 'should have proto for a title' do
      expect(landing_page).to have_proper_title
    end

    it 'should have a link to the sign in page' do
      landing_page.click_sign_in_link

      expect(page).to have_title login.title
    end
  end

  describe "the signup form" do
    before { landing_page.visit_page_as nil }

    it 'should go to the Ideas index upon logging in' do
      attrs = FactoryGirl.attributes_for(:user)

      landing_page.sign_up_using attrs

      expect(page).to have_title ideas.title
    end

    it 'should flash an error if the email is missing' do
      attrs = {
        :password =>                "asdfasdfasdf",
        :password_confirmation =>   "asdfasdfasdf"
      }

      landing_page.sign_up_using attrs

      expect(landing_page).to have_email_error
    end

    it 'should flash an error if the password is missing' do
      attrs = {
        :email =>                   "asdfasdf@asdf.com"
      }

      landing_page.sign_up_using attrs

      expect(landing_page).to have_password_error
    end
  end
end
