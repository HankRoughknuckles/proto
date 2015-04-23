require 'rails_helper'

RSpec.describe User, type: :model do

  it 'should have a unique email' do
    first = FactoryGirl.create(:user, email: "tester@example.com")
    second = FactoryGirl.build(:user, email: "tester@example.com")

    expect(second).not_to be_valid
  end

  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% username
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


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% User#voted_for?
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% User#upvoted?
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% User#downvoted?
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% User.give_free_gold_status_to
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe ".give_free_gold_status_to" do
    let(:user) { FactoryGirl.create(:user, {gold_status: false, 
                                            gold_status_expiration: nil})}

    before { User.give_free_gold_status_to user }

    it { expect(user.gold_status).to eq true }
    it { expect(user.gold_status_expiration)
      .to eq User.gold_expiration_time }
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% User.remove_gold_status_from
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe ".take_gold_status_from" do
    let(:user) { FactoryGirl.create(:gold_user) }

    before { User.take_gold_status_from user }

    it { expect(user.gold_status).to eq false }
    it { expect(user.gold_status_expiration).to eq nil }
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% User's ideas
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe "ideas" do
    it "should be deleted when user is deleted" do
      user = FactoryGirl.create(:user)
      idea = FactoryGirl.create(:idea, owner: user)

      expect{ user.destroy }.to change { Idea.count }.by -1
    end
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% User's followed ideas
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  describe 'followed idea' do
    it 'should be deleted when the idea is deleted' do
      idea =      FactoryGirl.create(:idea)
      user =      FactoryGirl.create(:user)
      idea.add_subscriber! user

      expect{ idea.destroy }.to change { user.followed_ideas.count }.by -1
    end
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Gold status at creation
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  it 'new users should automatically have 1 gold credit'
  # it 'new users should automatically have 1 gold credit' do
  #   user = FactoryGirl.build(:user, gold_credit: 0)
  #
  #   expect{ user.save }.to change{ user.gold_credit }.by 1
  # end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Profile picture
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  it 'should be assigned if not provided by the user' do
    image_url = "original/default_profile_pic.png"
    user = FactoryGirl.create(:user)

    expect(user.profile_picture.url).to eq image_url
  end
end
