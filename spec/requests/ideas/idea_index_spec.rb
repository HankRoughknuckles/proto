require "spec_helper"

describe "The idea index page" do
  let(:ideas_page) { IdeaIndexPage.new() }
  let(:landing_page) { LandingPage.new() }


  context 'when signed in' do
    let(:user) { FactoryGirl.create(:user) }
    before { ideas_page.visit_page_as user }

    it 'should have a sign out button' do
      ideas_page.click_sign_out_button

      expect(page.title).to match /^#{landing_page.title}$/
    end
  end
end
