# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Customer.destroy_all
Locker.destroy_all

num_customers = 20

# Create customers
num_customers.times do
  Customer.create( first_name: Faker::Name.first_name, 
                   last_name:  Faker::Name.last_name,
                   room_number: "#{ Faker::Number.number(4) }",
                   checked_in: true )
end
Customer.create( first_name: "Foo", last_name:  "Bar",
                 room_number: "4242", checked_in: true )

# Create lockers
def create_lockers(num, size)
  num.times do |index|
    number = "#{ size[0] }-#{ (index + 1).to_s.rjust(4, '0') }"
    Locker.create( number: number, size: size, assigned: false )
  end
end

create_lockers(NUM_SM_LOCKERS, "SMALL")
create_lockers(NUM_MD_LOCKERS, "MEDIUM")
create_lockers(NUM_LG_LOCKERS, "LARGE")
