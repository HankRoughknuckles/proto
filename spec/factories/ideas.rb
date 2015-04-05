FactoryGirl.define do
  factory :idea do
    sequence(:title)        { |n| "Great idea ##{n}" }
    description             "This is the best thing ever, trust me"
    summary                 "It's really good"
    youtube_link            "https://www.youtube.com/watch?v=n6zA-P8cTrI"
    association :owner,     factory: :user
    category
  end
end
