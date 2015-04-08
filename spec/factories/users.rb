FactoryGirl.define do
  factory :user do
    sequence(:email)          { |n| "person#{n}@example.com" }
    sequence(:username)       { |n| "username#{n}" }
    password                  "asdfasdf"
    password_confirmation     "asdfasdf"
  end
end
