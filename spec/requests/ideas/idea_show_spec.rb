require "spec_helper"

describe "The idea show page" do
  let!(:idea_owner)   { FactoryGirl.create(:user) }
  let!(:non_owner)    { FactoryGirl.create(:user) }
  let!(:idea)         { FactoryGirl.create(:idea, owner: idea_owner,
                                           main_image_file_name: "img.png"
                                          ) }
  let(:idea_page)         { IdeaShowPage.new(idea) }
  let(:email_list_page)   { EmailListPage.new(idea) }
  let(:auth_page)         { AuthenticationPage.new }


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Static page elements
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'static elements' do
    context 'when signed in as someone other than the owner' do
      before { idea_page.visit_page_as non_owner }

      it { expect(page).to          have_text idea.title }
      it { expect(page).to          have_text idea.description }
      it { expect(idea_page).to     have_main_image }
      it { expect(idea_page).to     have_vote_tally }
      it { expect(idea_page).to     have_text idea.summary }
      it { expect(idea_page).to     have_youtube_video_with_address idea.embed_link }
      it { expect(idea_page).not_to have_edit_idea_link }
      it { expect(idea_page).not_to have_delete_idea_link }
    end

    context 'when signed in as the owner' do
      before { idea_page.visit_page_as idea_owner }

      it { expect(idea_page).to have_edit_idea_link }

      #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      #%% The "Delete Idea" button
      #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      describe "the delete link" do
        it 'should be present' do
          expect(idea_page).to have_delete_idea_link
        end

        it 'should delete the idea' do
          expect{ idea_page.click_delete_idea_link }
            .to change { Idea.count }.by -1
        end
      end
    end

    context 'when not signed in' do
      before { idea_page.visit_page_as nil }

      it { expect(page).to          have_text idea.title }
      it { expect(page).to          have_text idea.description }
      it { expect(idea_page).to     have_main_image }
      it { expect(idea_page).to     have_vote_tally }
      it { expect(idea_page).to     have_text idea.summary }
      it { expect(idea_page).to     have_youtube_video_with_address idea.embed_link }
      it { expect(idea_page).not_to have_edit_idea_link }
      it { expect(idea_page).not_to have_delete_idea_link }
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

        expect(page.title).to match /#{auth_page.title}/
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

        expect(page.title).to match /#{auth_page.title}/
      end
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The email button
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "the add email button" do
    context 'when signed in as someone who is not the idea owner' do
      it "should add the current user to the contact list" do
        idea_page.visit_page_as non_owner
        expect{ idea_page.click_subscribe_button }
          .to change{ idea.subscribers.count }.by 1
      end
    end

    context 'when signed in as the idea owner' do
      before { idea_page.visit_page_as idea_owner }

      it 'should not be present' do
        expect(idea_page).not_to have_subscribe_button
      end

      it 'should be replaced by the email list link' do
        expect(idea_page).to have_email_list_button
      end
    end

    context 'when not signed in' do
      it "should take the user to the sign in page" do
        idea_page.visit_page_as nil
        idea_page.click_subscribe_button

        expect(page.title).to match /#{auth_page.title}/
      end
    end
  end

  it 'the email list button should take you to the email list page' do
    idea_page.visit_page_as idea_owner
    idea_page.click_email_list_button

    expect(page.title).to match /#{email_list_page.title}/
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Posting Comments
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "posting comments" do
    it "should not be possible when not logged in" do
      idea_page.visit_page_as nil

      expect(idea_page).not_to have_add_comment_button
    end


    context 'when logged in' do
      before { idea_page.visit_page_as non_owner }

      it 'should be accesible through the "leave a comment" button' do
        expect(idea_page).to have_add_comment_button
      end

      it "should have a comment form" do
        expect(idea_page).to have_a_comment_form
      end
    end

    describe 'the comment making process' do
      before { idea_page.visit_page_as non_owner }

      it 'should show a new comment on screen when created' do
        idea_page.fill_comment_form_with "asdf"
        idea_page.click_submit_comment_button

        expect(idea_page).to have_a_comment_with_text "asdf"
      end

      it "should add a new comment to the model" do 
        idea_page.fill_comment_form_with "asdf"

        expect{ idea_page.click_submit_comment_button }
          .to change { idea.comment_threads.count }.by 1
      end
    end
  end
end
