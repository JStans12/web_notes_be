FactoryGirl.define do

  sequence :name do |n|
    "user#{n}"
  end

  sequence :email do |n|
    "user#{n}@hotmail.com"
  end

  factory :user do
    name
    email
    password "p"
    role 0
  end
end
