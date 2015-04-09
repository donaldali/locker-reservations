require 'spec_helper'

describe Customer do 
  let(:customer) { create(:customer) }
  subject { customer }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:number) }
  it { should respond_to(:checked_in) }
  it { should respond_to(:full_name) }

  describe "validations" do 
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number).case_insensitive }
  end
  describe "#full_name" do
    it "combines first and last names" do
      expect(customer.full_name).to eq("John Doe")
    end
  end

end
