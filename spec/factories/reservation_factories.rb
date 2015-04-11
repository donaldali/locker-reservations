FactoryGirl.define do
  factory :reservation do
    sequence(:number) { |n| "ABC123#{n}" }
    medium 1
    customer
  end
end
