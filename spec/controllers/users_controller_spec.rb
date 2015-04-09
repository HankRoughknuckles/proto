require 'spec_helper'

describe UsersController, type: :controller do

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% PUT #add_gold_status 
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'PUT #add_gold_status' do

    context 'when the user is not gold but has credit' do
      let(:user) { FactoryGirl.create(:user) }
      before :each do
        user.update_attributes({ gold_status: false, 
                                 gold_credit: 1 })
        sign_in user
      end


      it 'should add gold status to the user' do
        expect{ put :add_gold_status }
          .to change{ User.first.gold_status }.to true
      end


      it "should decrement gold_credit" do
        expect{ put :add_gold_status }
          .to change{ User.first.gold_credit }.by -1
      end


      it 'should flash a notice' do
        put :add_gold_status
        expect(flash[:notice]).to be_present
      end 
    end


    context 'when the user has no gold credit' do
      let!(:user) { FactoryGirl.create(:user) }
      before :each do
        user.update_attributes gold_credit: 0
        sign_in user
      end


      it 'should not add gold status' do
        expect{ put :add_gold_status }
          .not_to change{ User.first.gold_status }
      end


      it 'should flash the proper alert' do
        put :add_gold_status

        expect(flash[:alert])
          .to eq "More gold credit is needed to do that"
      end
    end


    context 'when no user is signed in' do
      it "should flash an error" do
        put :add_gold_status

        expect(flash[:alert]).to eq "You must be logged in to do that"
      end
    end

    
    context 'when the user already has gold status' do
      let!(:user) { FactoryGirl.create(:gold_user) }
      before :each do
        sign_in user
        user.update_attributes gold_credit: 1 
      end


      it "should not change gold status" do
        expect{ put :add_gold_status }
          .not_to change{ User.first.gold_status }
      end


      it "should not decrement gold_credit" do
        expect{ put :add_gold_status }
          .not_to change{ User.first.gold_credit }
      end

      
      it 'should have the proper flash alert' do
        put :add_gold_status

        expect(flash[:alert])
          .to eq "You already have gold status activated"
      end
    end
  end
end
