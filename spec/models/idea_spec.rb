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
  #%% Validations
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  it 'Should not be valid if summary is longer than 50 characters' do
    idea = FactoryGirl.build(:idea, summary: "a" * 51)
    expect(idea).not_to be_valid
  end

  it 'should not be valid if the title is not present' do
    idea = FactoryGirl.build(:idea, title: "")
    expect(idea).not_to be_valid
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Idea#belongs_to?
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "#belongs_to?" do
    let(:owner) { FactoryGirl.create(:user) }
    let(:idea) { FactoryGirl.create(:idea, owner: owner ) }

    it "should return false when passed a non user" do
      inputs = [
        nil,
        "a string",
        4,
        Idea.new
      ]

      inputs.each do |input|
        expect(idea.belongs_to? input).to eq false
      end
    end

    it "should return false when the passed user is not the owner" do
      expect(idea.belongs_to? User.new).to eq false
    end

    it "should return true when the passed user is the owner" do
      expect(idea.belongs_to? owner).to eq true
    end
  end
end
