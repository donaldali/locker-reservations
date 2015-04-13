Customer.destroy_all
Locker.destroy_all

num_customers = 200

# Create customers
num_customers.times do
  Customer.create( first_name: Faker::Name.first_name, 
                   last_name:  Faker::Name.last_name,
                   room_number: "#{ Faker::Number.number(4) }",
                   checked_in: true )
end
Customer.create( first_name: "Foo", last_name:  "Doe",
                 room_number: "4242", checked_in: true )
Customer.create( first_name: "Bar", last_name:  "Doe",
                 room_number: "4242", checked_in: true )
Customer.create( first_name: "Baz", last_name:  "Doe",
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
