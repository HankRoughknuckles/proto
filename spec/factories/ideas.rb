FactoryGirl.define do
  factory :idea do
    sequence(:title)            { |n| "Great idea ##{n}" }
    description                 "This is the best thing ever, trust me"
    summary                     "It's really good"
    association :owner,         factory: :user
    category
  end
end
