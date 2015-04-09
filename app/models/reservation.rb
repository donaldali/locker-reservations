class Reservation < ActiveRecord::Base
  belongs_to :customer
  has_many :lockers

  validates :number, presence: true, uniqueness: { case_sensitive: false }
  validates :customer_id, presence: true
end
