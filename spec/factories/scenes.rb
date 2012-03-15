# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scene do
    name "scene name"
    desc "scene desc"
    start_date "2012-03-14"
    end_date "2012-03-18"
    project
  end
end
