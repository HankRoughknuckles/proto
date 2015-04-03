require "spec_helper"

describe "The idea index page" do
  let(:ideas_page)            { IdeaIndexPage.new() }
  let(:landing_page)          { LandingPage.new() }
  let(:login_page)            { LoginPage.new() }
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
      idea = FactoryGirl.create(:idea)
      ideas_page.visit_page_as nil
      ideas_page.click_upvote_button_for(idea)

      expect(page.title).to match /#{login_page.title}/
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
    let!(:someones_idea) { FactoryGirl.create(:idea, owner: some_owner) }
    let!(:user) { FactoryGirl.create(:user) }

    it 'should load on the page as selected if previously upvoted' do
      someones_idea.liked_by user

      ideas_page.visit_page_as user

      expect(ideas_page).to have_selected_upvote_button_for someones_idea
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The downvote buttons
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'the downvote buttons' do
    let!(:some_owner) { FactoryGirl.create(:user) }
    let!(:someones_idea) { FactoryGirl.create(:idea, owner: some_owner) }
    let!(:user) { FactoryGirl.create(:user) }

    it 'should redirect to the landing page when signed out' do
      ideas_page.visit_page_as nil
      ideas_page.click_downvote_button_for someones_idea

      expect(page).to have_title "Sign in"
    end


    it 'should load on the page as selected if previously upvoted' do
      user = FactoryGirl.create(:user)
      someones_idea.disliked_by user

      ideas_page.visit_page_as user

      expect(ideas_page).to have_selected_downvote_button_for someones_idea
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The category buttons
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # describe 'the category buttons' do
  #   let(:film_category) { FactoryGirl.create(:category, name: "Film") }
  #   let(:tech_category) { FactoryGirl.create(:category, name: "Technology") }
  #   let!(:film_idea)   { FactoryGirl.create(:idea, 
  #                                           category: film_category) }
  #   let!(:tech_idea)   { FactoryGirl.create(:idea, 
  #                                           category: tech_category)  }
  #
  #   describe "the 'all categories' button" do
  #     before :each do
  #       ideas_page.visit_page_as nil
  #       ideas_page.click_all_categories_button
  #     end
  #
  #     it 'should display the film idea' do
  #       expect(ideas_page).to have_detail_link_for film_idea
  #     end
  #
  #     it 'should display the tech idea' do
  #       expect(ideas_page).to have_detail_link_for tech_idea
  #     end
  #   end
  #
  #   describe "the 'film' category buton" do
  #     before :each do
  #       ideas_page.visit_page_as nil
  #       ideas_page.click_category_button film_category
  #     end
  #
  #     it 'should display the film idea' do
  #       expect(ideas_page).to have_detail_link_for film_idea
  #     end
  #
  #     it 'should display the tech idea' do
  #       expect(ideas_page).not_to have_detail_link_for tech_idea
  #     end
  #   end
  #
  #   describe "the 'tech' category buton" do
  #     before :each do
  #       ideas_page.visit_page_as nil
  #       ideas_page.click_category_button tech_category
  #     end
  #
  #     it 'should display the tech idea' do
  #       expect(ideas_page).to have_detail_link_for tech_idea
  #     end
  #
  #     it 'should display the film idea' do
  #       expect(ideas_page).not_to have_detail_link_for film_idea
  #     end
  #   end
  # end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The description
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "The description" do
    let!(:some_owner) { FactoryGirl.create(:user) }
    let!(:someones_idea) { FactoryGirl.create(:idea, owner: some_owner,
                                              summary: "Twitter for cats")
    }

    before {  ideas_page.visit_page_as nil }

    it 'should display the short summary' do
      expect(ideas_page).to have_text someones_idea.summary
    end

    it 'should not have the description' do
      expect(ideas_page).not_to have_text someones_idea.description
    end
  end
end
