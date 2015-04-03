require "spec_helper"

describe "The new page" do
  let(:user)              { FactoryGirl.create(:user) }
  let!(:new_idea_page)    { NewIdeaPage.new }
  let!(:form)             { IdeaForm.new }
  let!(:login_page)       { LoginPage.new }

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Access
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  it 'should redirect to the login page when not signed in' do
    new_idea_page.visit_page_as nil

    expect(page.title).to match login_page.title
  end

  describe 'the creation process' do
    before { new_idea_page.visit_page_as user }

    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% Creating with proper information
    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    describe "with proper information" do
      it 'should make a new idea' do
        form.fill_form_with FactoryGirl.attributes_for :idea 

        expect{ form.click_submit_button }.to change{ Idea.count }.by 1
      end

      it 'new idea should belong to owner' do
        form.fill_form_with FactoryGirl.attributes_for :idea 
        form.click_submit_button 

        expect(Idea.first.owner).to eq user
      end
    end


    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% Creating with improper information
    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    describe "with improper information" do
      it 'should not work without a title' do
        form.fill_form_with FactoryGirl.attributes_for :idea 
        form.fill_title_input_with nil
        form.click_submit_button

        expect(new_idea_page).to have_title_missing_error
      end
    end
  end
end
