# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :manager_role, :class => Role do
    name "manager"
  end
end

FactoryGirl.define do
  factory :admin_role, :class => Role do
    name "admin"
  end
end
