require 'rails_helper'

RSpec.describe Idea, type: :model do

  describe "#vote_tally" do
    let!(:idea) { FactoryGirl.create(:idea) }

    it 'should return 0 if there are no votes' do
      expect(idea.vote_tally).to eq 0
    end

    it 'should return 1 if there is just one upvote' do
      upvoter = FactoryGirl.create(:user)
      idea.liked_by upvoter

      expect(idea.vote_tally).to eq 1
    end

    it 'should return -1 if there is just one downvote' do
      downvoter = FactoryGirl.create(:user)
      idea.disliked_by downvoter

      expect(idea.vote_tally).to eq -1
    end

    it 'should return 0 if there is an upvote and a downvote' do
      upvoter = FactoryGirl.create(:user)
      downvoter = FactoryGirl.create(:user)
      idea.liked_by upvoter
      idea.disliked_by downvoter

      expect(idea.vote_tally).to eq 0
    end

  end
end