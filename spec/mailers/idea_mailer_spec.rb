require "rails_helper"

RSpec.describe IdeaMailer, type: :mailer do
  describe "#invitation_for_existing_user" do
    let!(:owner)    { FactoryGirl.create(:user) }
    let!(:idea)     { FactoryGirl.create(:idea, owner: owner) }
    let!(:mail)     { IdeaMailer.new_idea_email(idea) }

    it 'says the owners username in the email' do
      expect(mail.body.encoded).to match /#{owner.username}/
    end
  end
end
