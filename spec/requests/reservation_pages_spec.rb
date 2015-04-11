require 'spec_helper'

describe "Reservation Pages" do 
  let(:customer) { create(:customer) }
  let!(:lockers) { create_list(:locker, 3, size: "MEDIUM") }
  subject { page }

  describe "new" do 
    before { visit new_reservation_path }

    it { should have_text("Receive Bag(s)") }
    it { should have_selector("input[type=search]") }
    it { should have_selector("#reservation_large") }
    it { should have_selector("#reservation_medium") }
    it { should have_selector("#reservation_small") }
    it { should have_submit("Make Reservation") }

    describe "making reservation" do 
      let!(:lg_lockers) { create_list(:locker, 3, size: "LARGE") }
      let!(:sm_lockers) { create_list(:locker, 3, size: "SMALL") }
      before do
        fill_in "Bag's Owner", with: customer.identifier
      end

      context "with one bag type less than locker type" do
        before { fill_in "Medium", with: 2 }

        it "creates reservation" do
          expect{ click_button "Make Reservation" }.
              to change{ Reservation.count }.by(1)
        end
        it "assignes one locker per bag" do
          click_button "Make Reservation"
          expect(Locker.unassigned.size).to eq(7)
        end
        it "uses only appropriate type" do
          click_button "Make Reservation"
          expect(Locker.unassigned.medium.size).to eq(1)
        end
        it "goes to the reservation's show page" do
          click_button "Make Reservation"
          expect(current_path).
              to eq(reservation_path(customer.reservations.first))
        end
      end

      context "with one bag type more than locker type" do
        before { fill_in "Medium", with: 4 }

        it "creates reservation" do
          expect{ click_button "Make Reservation" }.
              to change{ Reservation.count }.by(1)
        end
        it "assignes one locker per bag" do
          click_button "Make Reservation"
          expect(Locker.unassigned.size).to eq(5)
        end
        it "uses all appropriate type and next big type" do
          click_button "Make Reservation"
          expect(Locker.unassigned.medium.size).to be_zero
          expect(Locker.unassigned.large.size).to eq(2)
        end
      end

      context "with multiple bag types each less than locker type" do
        before do 
          fill_in "Small", with: 2
          fill_in "Large", with: 2
        end

        it "creates reservation" do
          expect{ click_button "Make Reservation" }.
              to change{ Reservation.count }.by(1)
        end
        it "assignes one locker per bag" do
          click_button "Make Reservation"
          expect(Locker.unassigned.size).to eq(5)
        end
        it "uses only appropriate type" do
          click_button "Make Reservation"
          expect(Locker.unassigned.small.size).to eq(1)
          expect(Locker.unassigned.large.size).to eq(1)
        end
      end

      context "with multiple bag types exceeding their locker type" do
        before do 
          fill_in "Small", with: 4
          fill_in "Medium", with: 4
        end

        it "creates reservation" do
          expect{ click_button "Make Reservation" }.
              to change{ Reservation.count }.by(1)
        end
        it "assignes one locker per bag" do
          click_button "Make Reservation"
          expect(Locker.unassigned.size).to eq(1)
        end
        it "uses all of appropriate type and next big type" do
          click_button "Make Reservation"
          expect(Locker.unassigned.small.size).to be_zero
          expect(Locker.unassigned.medium.size).to be_zero
          expect(Locker.unassigned.large.size).to eq(1)
        end
      end

      context "with as many bags as lockers" do
        context "all of one type" do
          before { fill_in "Small", with: 9 }

          it "creates reservation" do
            expect{ click_button "Make Reservation" }.
                to change{ Reservation.count }.by(1)
          end
          it "assignes all lockers" do
            click_button "Make Reservation"
            expect(Locker.unassigned.size).to be_zero
          end
        end

        context "of different types" do
          before do 
            fill_in "Small", with: 4
            fill_in "Medium", with: 4
            fill_in "Large", with: 1
          end

          it "creates reservation" do
            expect{ click_button "Make Reservation" }.
                to change{ Reservation.count }.by(1)
          end
          it "assignes all lockers" do
            click_button "Make Reservation"
            expect(Locker.unassigned.size).to be_zero
          end
        end
      end

      context "with more bags than lockers" do
        before do 
          fill_in "Small", with: 5
          fill_in "Medium", with: 5
        end

        it "does not create reservation" do
          expect{ click_button "Make Reservation" }.
              not_to change{ Reservation.count }
        end
        it "does not assign any locker" do
          click_button "Make Reservation"
          expect(Locker.unassigned.size).to eq(9)
        end
      end

      context "with large bags more than large lockers" do
        before do 
          fill_in "Large", with: 4
        end

        it "does not create reservation" do
          expect{ click_button "Make Reservation" }.
              not_to change{ Reservation.count }
        end
        it "does not assign any locker" do
          click_button "Make Reservation"
          expect(Locker.unassigned.size).to eq(9)
        end
      end

      context "with medium bags more than large and medium lockers" do
        before do 
          fill_in "Medium", with: 7
        end

        it "does not create reservation" do
          expect{ click_button "Make Reservation" }.
            not_to change{ Reservation.count }
        end
        it "does not assign any locker" do
          click_button "Make Reservation"
          expect(Locker.unassigned.size).to eq(9)
        end
      end

    end
  end


  describe "show" do
    before { make_reservation_for customer }
    let(:reservation) { customer.reservations.first }

    its(:current_path) { should eq(reservation_path(reservation)) }
    it { should have_text("#{ customer.full_name }") }
    it { should have_text("#{ reservation.number }") }
    it { should have_text("#{ reservation.lockers.first.number }") }
    it { should have_text("#{ reservation.lockers.last.number }") }
    it { should have_link("Print Ticket", 
          href: print_ticket_reservation_path(reservation)) }
    it { should have_link("Print Lockers", 
          href: print_lockers_reservation_path(reservation)) }
    it { should have_link("Bag(s) Received", href: root_path) }
    it { should have_link("Bag(s) Returned", 
          href: reservation_path(reservation)) }
  end

  describe "destroy reservation" do
    before { make_reservation_for customer }
    let(:reservation) { customer.reservations.first }

    it "destroys the reservation" do
      expect{ click_link("Bag(s) Returned") }.
          to change{ Reservation.count }.by(-1)
    end
    it "redirects to root path" do
      click_link("Bag(s) Returned")
      expect(current_path).to eq(root_path)
    end
    it "makes all the reservation's lockers unassigned" do
      locker1 = reservation.lockers.first
      locker2 = reservation.lockers.last

      expect(locker1.assigned).to be_true
      expect(locker2.assigned).to be_true
      click_link("Bag(s) Returned")
      expect(locker1.reload.assigned).to be_false
      expect(locker2.reload.assigned).to be_false
    end
    it "makes all the reservation's lockers belong to no reservation" do
      locker1 = reservation.lockers.first
      locker2 = reservation.lockers.last

      expect(locker1.reservation_id).not_to be_nil
      expect(locker2.reservation_id).not_to be_nil
      click_link("Bag(s) Returned")
      expect(locker1.reload.reservation_id).to be_nil
      expect(locker2.reload.reservation_id).to be_nil
    end
  end


  describe "search" do
    before do
      make_reservation_for customer
      visit search_reservations_path
    end
    let(:reservation) { customer.reservations.first }

    its(:current_path) { should eq(search_reservations_path) }
    it { should have_text("Return Bag(s)") }
    it { should have_text("Reservation Number") }
    it { should have_selector("#reservation_number") }
    it { should have_submit("Find Reservation") }

    context "with a valid reservation number" do
      before { search_for_reservation_with reservation.number }

      it "shows the reservation" do
        expect(page.current_path).to eq(reservation_path(reservation))
      end
      it "shows appropriate flash message" do
        expect(page).to have_css(".flash")
        expect(page).to have_text("return #{customer.first_name}'s bag(s).")
      end
    end

    context "with valid reservation number but wrong capitalization" do
      before { search_for_reservation_with reservation.number.swapcase }

      it "shows the reservation" do
        expect(page.current_path).to eq(reservation_path(reservation))
      end
      it "shows appropriate flash message" do
        expect(page).to have_css(".flash")
        expect(page).to have_text("return #{customer.first_name}'s bag(s).")
      end
    end

    context "with an invalid reservation number" do
      before { search_for_reservation_with "foo42" }

      it "does not show the reservation" do
        expect(page.current_path).not_to eq(reservation_path(reservation))
      end
      it "shows appropriate flash message" do
        expect(page).to have_css(".flash")
        expect(page).to have_text("No Reservation Found.")
      end
    end
  end

end
