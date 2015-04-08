require 'rails_helper'

RSpec.describe User, type: :model do

  it 'should have a unique email' do
    first = FactoryGirl.create(:user, email: "tester@example.com")
    second = FactoryGirl.build(:user, email: "tester@example.com")

    expect(second).not_to be_valid
  end

  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Username
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "username" do
    it 'should be required' do
      user = FactoryGirl.build(:user, username: "")

      expect(user).not_to be_valid
    end

    it 'should be unique' do
      user = FactoryGirl.create(:user, username: "taken")
      user2 = FactoryGirl.build(:user, username: "Taken")

      expect(user2).not_to be_valid
    end

    it 'should be less than 30 characters' do
      user = FactoryGirl.build(:user, username: "a" * 31)

      expect(user).not_to be_valid
    end
  end


  describe "#voted_for?" do
    let(:user) { FactoryGirl.create(:user) }
    let(:idea) { FactoryGirl.create(:idea) }

    it 'should return true if the user upvoted' do
      idea.liked_by user
      expect(user.voted_for?(idea)).to eq true
    end

    it 'should return true if the user downvoted' do
      idea.disliked_by user
      expect(user.voted_for?(idea)).to eq true
    end

    it 'should return false if the user has not voted' do
      expect(user.voted_for?(idea)).to eq false
    end
  end


  describe "#upvoted?" do
    let(:user) { FactoryGirl.create(:user) }
    let(:idea) { FactoryGirl.create(:idea) }

    it 'should return true if the user upvoted' do
      idea.liked_by user
      expect(user.upvoted?(idea)).to eq true
    end

    it 'should return false if the user downvoted' do
      idea.disliked_by user
      expect(user.upvoted?(idea)).to eq false
    end

    it 'should return false if the user has not voted' do
      expect(user.upvoted?(idea)).to eq false
    end
  end


  describe "#downvoted?" do
    let(:user) { FactoryGirl.create(:user) }
    let(:idea) { FactoryGirl.create(:idea) }

    it 'should return false if the user upvoted' do
      idea.liked_by user
      expect(user.downvoted?(idea)).to eq false
    end

    it 'should return true if the user downvoted' do
      idea.disliked_by user
      expect(user.downvoted?(idea)).to eq true
    end

    it 'should return false if the user has not voted' do
      expect(user.downvoted?(idea)).to eq false
    end
  end
end
