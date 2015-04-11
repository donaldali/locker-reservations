require 'spec_helper'

describe Locker do
  let(:locker) { create(:locker) }
  subject { locker }

  it { should be_valid }
  it { should respond_to(:number) }
  it { should respond_to(:size) }
  it { should respond_to(:assigned) }
  it { should respond_to(:reservation_id) }

  describe "validations" do
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:size) }
    it { should validate_uniqueness_of(:number).case_insensitive }
  end

  describe "associations" do 
    it { should belong_to(:reservation) }
  end

  context "remaining lockers" do
    let!(:lg_lockers) { create_list(:locker, 3, size: "LARGE") }
    let!(:md_lockers) { create_list(:locker, 3, size: "MEDIUM") }
    let!(:sm_lockers) { create_list(:locker, 3, size: "SMALL") }

    describe "#lockers_left" do
      it "gives number of free small lockers" do
        expect(Locker.lockers_left).to eq({large: 3, medium: 3, small: 3})
      end
      it "only counts unassigned small lockers" do
        Locker.first.update_attributes(assigned: true)
        Locker.fourth.update_attributes(assigned: true)
        Locker.last.update_attributes(assigned: true)
        expect(Locker.lockers_left).to eq({large: 2, medium: 2, small: 2})
      end
    end

    describe "#max_bags_allowed" do
      it "gives maximum bags allowed" do 
        expect(Locker.max_bags_allowed).to eq({large: 3, medium: 6, small: 9})
      end
      it "considers only unassigned lockers for bags" do
        Locker.first.update_attributes(assigned: true)
        Locker.fourth.update_attributes(assigned: true)
        Locker.last.update_attributes(assigned: true)
        expect(Locker.max_bags_allowed).to eq({large: 2, medium: 4, small: 6})
      end
    end
  end

end
