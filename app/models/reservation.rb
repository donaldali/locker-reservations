class Reservation < ActiveRecord::Base
  belongs_to :customer

  validates :number, presence: true, uniqueness: { case_sensitive: false }
  validates :customer_id, presence: true
end
