Factory.define :user do |u|
  u.sequence(:id) { |n| n }
  u.sequence(:username) { |n| "person#{n}" }
  u.sequence(:email) { |n| "person#{n}@email.com" }
  u.password 'jjjjjj'
end
