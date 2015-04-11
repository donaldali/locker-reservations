require 'spec_helper'

describe "Concierge Services Pages" do
  subject { page }

  describe "index" do
    before { visit concierge_services_path }

    it { should have_text("Concierge Services") }
    it { should have_link("Receive Bag(s)", href: new_reservation_path) }
    it { should have_link("Return Bag(s)", href: search_reservations_path) }
  end
end

