FactoryGirl.define do
  factory :user do
    sequence(:email)            { |n| "person#{n}@example.com" }
    sequence(:username)         { |n| "username#{n}" }
    password                    "asdfasdf"
    password_confirmation       "asdfasdf"
    gold_status                 false
    gold_status_expiration      nil

    factory :gold_user do
      gold_status               true
      gold_status_expiration    User.gold_expiration_time
    end

    factory :user_with_gold_credit do
      gold_credit               1
    end
  end
end
