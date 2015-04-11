FactoryGirl.define do
  factory :locker do
    sequence(:number) { |n| "M#{n}" }
    size "MEDIUM"
    assigned false
  end
end
