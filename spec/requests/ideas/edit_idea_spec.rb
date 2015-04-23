require "spec_helper"

describe "The idea edit page" do
  let!(:owner)           { FactoryGirl.create(:user) }
  let!(:non_owner)       { FactoryGirl.create(:user) }
  let!(:idea)            { FactoryGirl.create(:idea_with_image, 
                                              owner: owner) }

  let(:edit_page)       { EditIdeaPage.new(idea) }
  let(:form)            { IdeaForm.new }

  context 'when not logged in' do
    it "should redirect to the landing page" do
      authentication_page = AuthenticationPage.new

      edit_page.visit_page_as nil
      
      expect(page.title).to match /#{authentication_page.title}/
    end
  end

  context 'when logged in as a non-owner' do
    it 'should redirect to the home page' do
      ideas_page = IdeaIndexPage.new

      edit_page.visit_page_as non_owner
      
      expect(page.title).to match /#{ideas_page.title}/
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% When logged in as the owner
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  context 'when logged on as the owner' do
    before { edit_page.visit_page_as owner }

    it { expect(form).to have_image_for idea }


    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #%% The editing process
    ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    describe 'the editing process' do
      it 'should edit title properly' do
        form.fill_title_input_with "something different"
        form.click_submit_button

        expect(Idea.first.title).to eq "something different"
      end


      it 'should not edit title if blank' do
        form.fill_title_input_with ""

        expect { form.click_submit_button }
          .not_to change { Idea.first.title }
      end


      it 'should edit summary properly' do
        form.fill_summary_input_with "something different"
        form.click_submit_button

        expect(Idea.first.summary).to eq "something different"
      end


      it 'should edit description properly' do
        form.fill_description_input_with "something different"
        form.click_submit_button

        expect(Idea.first.description).to eq "something different"
      end


      it 'should edit youtube_link properly'

      # it 'should edit youtube_link properly' do
      #   url = "https://www.youtube.com/watch?v=MNyG-xu-7SQ"
      #   form.fill_youtube_link_with url
      #
      #   expect { form.click_submit_button }
      #     .to change { Idea.first.youtube_link }
      # end
    end
  end
end
