def make_reservation_for customer
  visit new_reservation_path
  fill_in "Bag's Owner", with: customer.identifier
  fill_in "Medium", with: 2
  click_button "Make Reservation"
end

def search_for_reservation_with reservation_number
  fill_in "Reservation Number", with: reservation_number
  click_button "Find Reservation"
end