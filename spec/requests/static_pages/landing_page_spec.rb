require "spec_helper"

describe "The landing page" do
  let(:ui) { LandingPage.new() }

  context 'when logged in' do
    let(:user) { FactoryGirl.create(:user) }

    it 'should redirect to the ideas index' do
      expect(page).to have_title "hey"
    end
  end
end
