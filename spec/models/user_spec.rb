require 'rails_helper'

RSpec.describe User, type: :model do

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
