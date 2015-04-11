class Customer < ActiveRecord::Base
  scope :checked_in, -> { where(checked_in: true) }
  scope :room_order, -> { order(:room_number) }

  has_many :reservations, dependent: :destroy

  validates :first_name,  presence: true
  validates :last_name,   presence: true
  validates :room_number, presence: true
  validates :checked_in,  inclusion: { in: [true, false] }

  def self.from_identifier identifier
    id = identifier.split("|").last.to_i
    Customer.find_by(id: id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def identifier
    "#{room_number}, #{full_name} | #{id}"
  end
end
