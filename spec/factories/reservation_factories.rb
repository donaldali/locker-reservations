FactoryGirl.define do
  factory :reservation do
    sequence(:number) { |n| "ABC123#{n}" }
    customer
  end
end
