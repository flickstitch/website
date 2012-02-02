# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    association(:user)
    sequence(:name) { |n| "video#{n}" }
    video_url "http://www.badurl.com"
  end
end
