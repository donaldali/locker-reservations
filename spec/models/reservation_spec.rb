require 'spec_helper'

describe Reservation do
  let(:reservation) { create(:reservation) }
  subject { reservation }

  it { should be_valid }
  it { should respond_to(:number) }
  it { should respond_to(:customer_id) }

  describe "validation" do
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:customer_id) }
    it { should validate_uniqueness_of(:number).case_insensitive }
  end

  describe "associations" do
    it { should belong_to(:customer) }
    it { should have_many(:lockers) }
  end
end
