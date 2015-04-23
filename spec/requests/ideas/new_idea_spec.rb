require "spec_helper"

describe "The new page" do
  let(:user)              { FactoryGirl.create(:user) }
  let!(:idea)             { FactoryGirl.build(:idea) }
  let!(:new_idea_page)    { NewIdeaPage.new }
  let!(:form)             { IdeaForm.new }
  let!(:auth_page)        { AuthenticationPage.new }

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Access
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  it 'should redirect to the login page when not signed in' do
    new_idea_page.visit_page_as nil

    expect(page.title).to match auth_page.title
  end

  describe 'the creation process' do
    before { new_idea_page.visit_page_as user }

    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% Creating with proper information
    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    describe "with proper information" do
      it 'should make a new idea' do
        form.fill_form_with idea.attributes

        expect{ form.click_submit_button }.to change{ Idea.count }.by 1
      end

      it 'new idea should belong to owner' do
        form.fill_form_with idea.attributes
        form.click_submit_button 

        expect(Idea.first.owner).to eq user
      end

      it 'should send an email to the admins' do
        form.fill_form_with idea.attributes
        expect{ form.click_submit_button }
          .to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end


    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% Creating with a youtube video
    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    describe "with a youtube video" do
      it 'should have a video iframe after saving' do
        form.fill_form_with idea.attributes
        form.click_submit_button

        expect(IdeaShowPage.new(Idea.first))
          .to have_youtube_video_with_address idea.embed_link
      end
    end


    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% Creating with improper information
    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    describe "with improper information" do
      it 'should not work without a title' do
        form.fill_form_with idea.attributes
        form.fill_title_input_with nil
        form.click_submit_button

        expect(form).to have_title_missing_error
      end
    end
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Preferred Status for ideas
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "Preferred status" do
    it 'should work if user has gold status' do
      gold_user = FactoryGirl.create(:gold_user)
      new_idea_page.visit_page_as gold_user

      form.fill_form_with idea.attributes
      form.set_preferred_checkbox true
      form.click_submit_button

      expect(Idea.first.preferred).to eq true
    end


    it "should not be available if user doesn't have gold status" do
      new_idea_page.visit_page_as user

      expect(form).not_to have_preferred_checkbox
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Expiring gold status
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "Gold status" do
    it 'should turn to false on entering page if expired' do
      user = FactoryGirl.create(:gold_user)
      user.update_attributes gold_status_expiration: 1.hour.ago

      expect{ new_idea_page.visit_page_as user }
        .to change{ user.gold_status }.to false
    end
  end
end
