FactoryGirl.define do
  factory :idea do
    sequence(:title)            { |n| "Great idea ##{n}" }
    description                 "This is the best thing ever, trust me"
    category                    Idea::MISCELLANEOUS
    user
  end
end
