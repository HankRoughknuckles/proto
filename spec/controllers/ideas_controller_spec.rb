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


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% POST #create
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'POST #create' do
    context 'when user does not have gold status' do
      it 'should not let a preferred idea get made' do
        non_gold = FactoryGirl.create(:user)

        sign_in non_gold
        post :create, { idea: FactoryGirl.attributes_for(:preferred_idea) }

        expect(Idea.first.preferred).to eq false
      end
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% PATCH/PUT #update
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'PATCH/PUT #update' do
    it 'works when title is present' do
      user = FactoryGirl.create(:user)
      idea = FactoryGirl.create(:idea, owner: user, title: "one thing")

      sign_in user
      patch :update, { id: idea.id,
                      idea: FactoryGirl.attributes_for(:idea, title: "other") }

      expect(Idea.first.title).to eq "other"
    end


    context 'when user does not have gold status' do
      it 'should not let an idea become preferred' do
        idea =        FactoryGirl.create(:idea)
        non_gold =    FactoryGirl.create(:user)

        sign_in non_gold
        patch :update, {id:    idea.id, 
                        idea:  FactoryGirl.attributes_for(:preferred_idea) 
        }

        expect(Idea.first.preferred).to eq false
      end
    end
  end
end
