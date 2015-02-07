require "spec_helper"

describe "The landing page" do
  let(:ui) { LandingPage.new() }

  context 'when logged in' do
    it 'should redirect to the ideas index' do
      pending
      expect(page).to have_title "hey"
    end
  end

  context 'when not logged in' do
    it 'should have a signup form' do
      expect(ui).to have_signup_form
    end
  end
end
