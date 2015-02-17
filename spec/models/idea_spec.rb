require 'rails_helper'

RSpec.describe Idea, type: :model do

  it { expect(Idea.new).to respond_to :category }


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Idea#vote_tally
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Idea.get_string_for_category
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe ".get_string_for_category" do
    it 'should work with Technology' do
      category = Idea::TECHNOLOGY
      expect(Idea.get_string_for_category(category)).to eq "Technology"
    end

    it 'should work with Film' do
      category = Idea::FILM
      expect(Idea.get_string_for_category(category)).to eq "Film"
    end

    it 'should work with Education' do
      category = Idea::EDUCATION
      expect(Idea.get_string_for_category(category)).to eq "Education"
    end
  end
end
