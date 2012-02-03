FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| n }
    sequence(:username) { |n| "person#{n}" }
    sequence(:email) { |n| "person#{n}@email.com" }
    password "jjjjjj"
  end

  factory :admin_user, :parent => :user do
    roles { |r| [r.association(:admin_role)] }
  end
end
