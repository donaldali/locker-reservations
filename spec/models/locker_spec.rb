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
end
