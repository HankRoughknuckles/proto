require "spec_helper"

describe "User show page" do
  let!(:user)          { FactoryGirl.create(:user_with_gold_credit) }
  let!(:idea)          { FactoryGirl.create(:idea, owner: user) }
  let(:user_page)     { UserShowPage.new user }


  context 'when logged in as a different user' do
    let(:other_user) { FactoryGirl.create(:user) }

    before { user_page.visit_page_as other_user }


    it "should not have a link to the edit user page" do
      expect(user_page).not_to have_edit_user_link
    end


    it "should not have an activate gold status link" do
      expect(user_page).not_to have_activate_gold_status_link
    end

    it "should have the user's list of ideas"

    context 'when the user has no ideas' do
      it "should not have a link to create ideas"
    end
  end


  context 'when not logged in' do
    before { user_page.visit_page_as nil }

    it "should not have a link to the edit user page" do
      expect(user_page).not_to have_edit_user_link
    end

    it "should not have an activate gold status link" do
      expect(user_page).not_to have_activate_gold_status_link
    end

    it "should have the user's list of ideas"
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% When logged in as the proper user
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  context 'when logged in as the user' do
    before { user_page.visit_page_as user }


    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% Title
    ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    it 'should have the proper title' do
      expect(page.title).to match /#{user_page.title}/
    end


    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% Edit user settings link
    ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    it "should have a link to the edit user page" do
      edit_user_page = UserEditPage.new user

      user_page.click_edit_user_link

      expect(page.title).to match /#{edit_user_page.title}/
    end


    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% List of the user's ideas
    ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    context 'when the user has ideas' do
      it "should have the list of the user's ideas" do
        expect(user_page).to have_idea_link idea
      end
    end


    context 'when the user has no ideas' do
      before :each do
        user.ideas.delete_all
        user_page.visit_page_as user
      end 

      it 'should have a link to make one' do
        expect(user_page).to have_a_link_for_making_ideas
      end
    end


    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% Activate gold status link
    ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    describe "the activate gold status link" do
      it "should appear when the user has gold credit" do
        expect(user_page).to have_activate_gold_status_link
      end


      context 'when the user has no gold credit' do
        it 'should not appear' do
          user.update_attributes gold_credit: 0

          user_page.visit_page_as user

          expect(user_page).not_to have_activate_gold_status_link
        end
      end
    end
  end
end
