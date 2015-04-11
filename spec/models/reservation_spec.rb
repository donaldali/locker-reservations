require 'spec_helper'

describe Reservation do
  let(:reservation) { build(:reservation) }
  let!(:locker) { create(:locker) }
  subject { reservation }

  before { reservation.bags_owner = reservation.customer.identifier }

  it { should be_valid }
  it { should respond_to(:number) }
  it { should respond_to(:customer_id) }

  describe "validation" do
    it "detects when no lockers are available" do
      locker.update_attributes(assigned: true)
      reservation.valid?
      expect(reservation.errors[:base]).
        to include("THERE ARE CURRENTLY NO AVALIABLE LOCKERS.")
    end

    it "validates presence of bags owner" do 
      reservation.bags_owner = ""
      reservation.valid?
      expect(reservation.errors[:bags_owner]).
        to include("can't be blank. Please search from list provided.")
    end
    it "validates correctness of bags owner" do
      reservation.bags_owner = "foo bar"
      reservation.valid?
      expect(reservation.errors[:bags_owner]).
        to include("is invalid. Please search from list provided.")
    end
    it "validates at least one bag type" do
      reservation.medium = 0
      reservation.valid?
      expect(reservation.errors[:base]).
        to include("At least one bag type must be more than 0.")
    end
    it "validates combined bags of all types" do
      create(:locker, size: "LARGE")
      create(:locker, size: "LARGE")
      create(:locker, size: "SMALL")
      reservation.medium = 4
      reservation.valid?
      expect(reservation.errors[:base][0]).
        to match("Not enough free lockers for bags requested.")
    end
    it "validates number of large bags" do
      create(:locker, size: "LARGE")
      create(:locker, size: "LARGE")
      reservation.large = 3
      reservation.valid?
      expect(reservation.errors[:large]).
        to include("must be between 0 and 2.")
    end
    it "validates number of medium bags" do
      create(:locker, size: "MEDIUM")
      create(:locker, size: "MEDIUM")
      reservation.medium = 4
      reservation.valid?
      expect(reservation.errors[:medium]).
        to include("must be between 0 and 3.")
    end
    it "validates number of small bags" do
      create(:locker, size: "SMALL")
      create(:locker, size: "SMALL")
      reservation.small = 4
      reservation.valid?
      expect(reservation.errors[:small]).
        to include("must be between 0 and 3.")
    end
  end

  describe "associations" do
    it { should belong_to(:customer) }
    it { should have_many(:lockers) }
  end

  describe "save" do
    it "assigns the inputed owner as customer" do 
      customer = reservation.customer
      reservation.save
      expect(reservation.customer).to eq(customer)
    end
  end
  
end
