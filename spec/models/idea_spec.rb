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


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Idea#embed_link
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "#embed_link" do
    let(:idea) { FactoryGirl.create(:idea) }

    it 'should return nil if passed a non-youtube link' do
      inputs = [
        "http://google.com",
        nil,
        "",
        3,
        "ww.youtub.com/watch?v=x9ECN-R428A",
      ]

      inputs.each do |input|
        idea.youtube_link = input

        expect(idea.embed_link).to eq nil
      end
    end


    it 'should return the proper embed link when there is no http' do
      idea = FactoryGirl.create(:idea, youtube_link: 
                                "www.youtube.com/watch?v=x9ECN-R428A")

      expect(idea.embed_link)
        .to eq "#{Idea::YOUTUBE_EMBED_PREFIX}x9ECN-R428A?rel=0"
    end


    it 'should return the proper embed link when http is present' do
      idea = FactoryGirl.create(:idea, youtube_link: 
        "http://www.youtube.com/watch?v=x9ECN-R428A")

      expect(idea.embed_link)
        .to eq "#{Idea::YOUTUBE_EMBED_PREFIX}x9ECN-R428A?rel=0"
    end


    it 'should return the proper embed link when www is missing' do
      idea = FactoryGirl.create(:idea, youtube_link: 
        "youtube.com/watch?v=x9ECN-R428A")

      expect(idea.embed_link)
        .to eq "#{Idea::YOUTUBE_EMBED_PREFIX}x9ECN-R428A?rel=0"
    end


    it 'should work when the youtube link is shortened' do
      idea = FactoryGirl.create(
        :idea, youtube_link: "http://youtu.be/t-ZRX8984sc")

      expect(idea.embed_link)
        .to eq "#{Idea::YOUTUBE_EMBED_PREFIX}t-ZRX8984sc?rel=0"
    end
  end
end
