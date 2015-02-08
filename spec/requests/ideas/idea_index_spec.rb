require "spec_helper"

describe "The idea index page" do
  let(:ideas_page)            { IdeaIndexPage.new() }
  let(:landing_page)          { LandingPage.new() }
  let(:new_idea_page)         { NewIdeaPage.new() }


  context 'when signed in' do
    let(:user) { FactoryGirl.create(:user) }
    before { ideas_page.visit_page_as user }

    it 'should have a sign out button' do
      ideas_page.click_sign_out_button

      expect(page.title).to match /^#{landing_page.title}$/
    end
  end

  context 'when not signed in' do
    before { ideas_page.visit_page_as nil }

    it 'should not have a sign out button' do
      expect(ideas_page).not_to have_sign_out_button
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The new idea button
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "the new idea button" do
    it 'should go to sign up page when not signed in' do
      ideas_page.visit_page_as nil
      ideas_page.click_new_idea_button

      expect(page.title).to match /^#{landing_page.title}$/
    end


    context 'when signed in' do
      let(:user) { FactoryGirl.create(:user) }
      before { ideas_page.visit_page_as user }


      it 'should go to the new idea page' do
        ideas_page.click_new_idea_button

        expect(page).to have_title new_idea_page.title
      end
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The upvote buttons
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'the upvote buttons' do
    let!(:some_owner) { FactoryGirl.create(:user) }
    let!(:someones_idea) { FactoryGirl.create(:idea, user: some_owner) }

    it 'should redirect to the landing page when signed out' do
      ideas_page.visit_page_as nil
      ideas_page.click_upvote_button_for someones_idea

      expect(page).to have_title "Sign in"
    end


    it 'should increment the ideas vote count by 1 when signed in' do
      user = FactoryGirl.create(:user)

      ideas_page.visit_page_as user

      expect{ideas_page.click_upvote_button_for someones_idea}
        .to change{someones_idea.get_upvotes.size}.by(1)
    end
  end
end
