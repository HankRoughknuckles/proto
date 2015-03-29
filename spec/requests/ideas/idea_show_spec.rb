require "spec_helper"

describe "The idea show page" do
  let(:idea_owner)    { FactoryGirl.create(:user) }
  let(:some_user)     { FactoryGirl.create(:user) }
  let(:idea)          { FactoryGirl.create(:idea, user: idea_owner,
                                           main_image_file_name: "img.png"
                                          ) }
  let(:idea_page)     { IdeaShowPage.new(idea) }
  let(:login_page)    { LoginPage.new }

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Static page elements
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'static elements' do
    context 'when signed in' do
      before { idea_page.visit_page_as some_user }

      it { expect(page).to          have_text idea.title }
      it { expect(page).to          have_text idea.description }
      it { expect(idea_page).to     have_main_image }
      it { expect(idea_page).to     have_vote_tally }
    end


    context 'when not signed in' do
      before { idea_page.visit_page_as nil }

      it { expect(page).to          have_text idea.title }
      it { expect(page).to          have_text idea.description }
      it { expect(idea_page).to     have_main_image }
      it { expect(idea_page).to     have_vote_tally }
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The upvote button
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'the upvote button' do
    context 'when not signed in' do
      it 'should go to sign in page when not signed in' do
        idea_page.visit_page_as nil
        idea_page.click_upvote_button

        expect(page.title).to match /#{login_page.title}/
      end
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The downvote button
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'the downvote button' do
    context 'when not signed in' do
      it 'should go to sign in page when not signed in' do
        idea_page.visit_page_as nil
        idea_page.click_downvote_button

        expect(page.title).to match /#{login_page.title}/
      end
    end
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The email button
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "the add email button" do
    context 'when signed in' do
      it "should add the current user to the contact list" do
        idea_page.visit_page_as some_user
        expect{ idea_page.click_add_email_button }
          .to change{idea.subscribers.count}.by 1
      end
    end

    context 'when not signed in' do
      it "should take the user to the sign in page" do
        idea_page.visit_page_as nil
        idea_page.click_add_email_button

        expect(page.title).to match /#{login_page.title}/
      end
    end
  end
end
