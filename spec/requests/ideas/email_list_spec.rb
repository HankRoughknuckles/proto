require "spec_helper"

describe "The email list page" do
  let!(:idea_owner)   { FactoryGirl.create(:user) }
  let!(:non_owner)    { FactoryGirl.create(:user) }
  let(:subscriber)    { FactoryGirl.create(:user) }
  let!(:idea)         { FactoryGirl.create(:idea_with_image, 
                                           owner: idea_owner,
                                           subscribers: [subscriber]
                                          ) }

  let(:email_list_page)   { EmailListPage.new(idea) }
  let(:ideas_page)        { IdeaIndexPage.new }
  let(:login_page)        { LoginPage.new }


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Access
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'authorization' do
    it 'should redirect to the login page when not logged in' do
      email_list_page.visit_page_as nil

      expect(page.title).to match login_page.title
    end

    it 'should redirect to the login page when logged in as non-owner' do
      email_list_page.visit_page_as non_owner

      expect(page.title).to match ideas_page.title
    end
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The List
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "the list" do
    before { email_list_page.visit_page_as idea_owner }

    it 'should have the number of subscribers on screen' do
      expect(email_list_page).to have_number_of_subscribers_as 1
    end

    it 'should contain the email addresses of those who have subscribed' do
      expect(email_list_page).to have_subscriber subscriber
    end
  end
end
