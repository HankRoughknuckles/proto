require 'spec_helper'

describe IdeasController, type: :controller do

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% DELETE #destroy
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'DELETE #destroy' do
    let!(:owner) { FactoryGirl.create(:user) }
    let!(:idea) { FactoryGirl.create(:idea, owner: owner) }

    it "should allow the owner to delete his/her idea" do
      sign_in owner

      expect{ delete :destroy, id: idea.id }.to change{ Idea.count }.by -1
    end


    it "should not allow a non-owner to delete someone's idea" do
      non_owner = FactoryGirl.create(:user)

      sign_in non_owner

      expect{ delete :destroy, id: idea.id }.to change{ Idea.count }.by 0
    end
  end
end
