# Locker Reservations

An app to manage locker reservations at a faux big Vegas hotel -- UT Hotel.

## Tests

Run the test suite with `rake` or `rspec spec/`.

## Set Up

To run the app locally, after the database migration, run `rake db:seed` to create faux `Locker` and `Customer` data.

_You may adjust the number of each type of `Locker` created from the `config/initializers/constants.rb` file; adjust how many `Customer`s are created from the top of the `db/seeds.rb` file_. Currently, the customers created include the `Doe` family (`Foo`, `Bar`, and `Baz`) in room number`4242`.


## Assumptions

- Customers can make multiple Locker Reservations, and each Locker Reservation can be for one or more bags.
- When a Locker Reservation is ended, all bags associated with that reservation are returned. _(To mitigate the possible inconvenience of this assumption, and following from the assumption above, a customer checking in multiple bags may break them up into multiple reservations if the customer anticipates needing the bags at different times. If for some unforseen circumstance a customer needs to check out part of the bags associated with a reservation, all bags must the checked out and a new Locker Reservation created for the bags the customer doesn't want yet. See the [Possible Improvement](#possible-improvement "Possible Improvement") section below for a possible solution to this assumption)_.
- Customers using the Locker Reservation service have been given a room number when they checked into the hotel.
- Each locker can contain only one bag (for example, a large locker can't hold two small bags).
- The concierge can always tell the smallest locker that can fit any bag (this smallest size is inputted to the app, but a larger locker may be assigned if that size is not available).
- Reservations may not be made in advance, ie, a customer must be present with their bag(s) to make a reservation.
- The concierge's work station is able to print to normal paper or to a Locker Reservation ticket.
- Concierge may verify the identity of a customer during bag check in or check out.

## Use

The app is written from the point of view of the concierge and has an easy to follow work flow.

#### Receive Bags

To receive bags for a Locker Reservation, search for the customer who wants to make the Locker Reservation by entering the customer's room number, then selecting the customer from the list that appears as you enter the room number. Enter the number of bags of each size and make the reservation.

Several client and server-side validations ensure that the request can be processed before reserving lockers. Continue on [Show Reservation](#show-reservation "Show Reservation").

#### Return Bags

To return bags, search for a Locker Reservation by entering the Reservation Number (which the customer should have on their ticket); you may select from the list of Reservation Numbers that appear as you enter the number.

Client and Server side validations ensure that the number entered is valid. Continue on [Show Reservation](#show-reservation "Show Reservation").

#### Show Reservation

This is used both to receive and return bags.

After a reservation is made, use `Print Ticket` to print just the Reservation Number for the customer.

(If a lot of lockers are assigned for a reservation, the concierge may use `Print Locker` to get a list of just the lockers for that reservation to assist him/her in storing or retrieving the bags).

After receiving and storing a customer's bags, use `Bag(s) Received` to end the bag check in process. For bag check out, use `Bag(s) Returned` to complete the process after retrieving and returning the customer's bags. _(If an incorrect Locker Reservation was made during bag check in, `Bag(s) Returned` may be used from here to cancel the reservation and start a new one)_.

## Possible Improvement

Instead of a customer having one or more reservations each with one or more bags, the system could be set up for a customer to have only one reservation; then as a customer checks in or checks out one or more bags, the customer's reservation is updated to reflect the change. This also prevents the customer from potentially having to carry around and account for multiple Locker Reservation tickets.
