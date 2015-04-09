FactoryGirl.define do
  factory :customer do
    first_name "John"
    last_name  "Doe"
    sequence(:number) { |n| "1234567CA#{n}" }
    checked_in true
  end
end
