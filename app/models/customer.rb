class Customer < ActiveRecord::Base
  has_many :reservations, dependent: :destroy

  validates :first_name,  presence: true
  validates :last_name,   presence: true
  validates :room_number, presence: true
  validates :checked_in,  inclusion: { in: [true, false] }

  def full_name
    "#{first_name} #{last_name}"
  end
end
