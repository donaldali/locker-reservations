class Reservation < ActiveRecord::Base
  include ActiveModel::Validations

  attr_accessor :bags_owner, :small, :medium, :large

  scope :number_order, -> { order(:number) }

  belongs_to :customer
  has_many :lockers

  validates :number, presence: true, uniqueness: { case_sensitive: false }
  validates_with ReservationValidator

  before_validation :set_reservation_number, on: :create
  before_create :set_customer
  before_create :assign_lockers



  private



  def set_reservation_number
    caps = ('A'..'Z').to_a
    loop do
      self.number = "-#{Faker::Number.number(4)}"
      3.times { self.number = caps.sample + self.number }
      break unless Reservation.exists?(number: self.number)
    end
  end

  def set_customer
    self.customer = Customer.from_identifier(self.bags_owner)
  end

  def assign_lockers
    left = Locker.lockers_left
    assign_large(left)
    assign_medium(left)
    assign_small(left)
  end

  def assign_large left
    large_requested = self.large.to_i
    assigned = Locker.unassigned.large.limit(large_requested)
    add_assigned_lockers(assigned)
    left[:large] -= large_requested
  end

  def assign_medium left
    medium_requested = self.medium.to_i
    # If more medium lockers are requested than are available, assign
    # the extras to large lockers before continuing and assigning
    # all the medium lockers
    if medium_requested > left[:medium]
      self.large = medium_requested - left[:medium]
      medium_requested = left[:medium]
      assign_large(left)
    end
    assigned = Locker.unassigned.medium.limit(medium_requested)
    add_assigned_lockers(assigned)
    left[:medium] -= medium_requested
  end

  def assign_small left
    small_requested = self.small.to_i
    # If more small lockers are requested than are available, assign
    # the extras to medium lockers before continuing and assigning
    # all the small lockers (if the medium lockers are insufficient,
    # then large lockers will ultimately be assigned).
    if small_requested > left[:small]
      self.medium = small_requested - left[:small]
      small_requested = left[:small]
      assign_medium(left)
    end
    assigned = Locker.unassigned.small.limit(small_requested)
    add_assigned_lockers(assigned)
    left[:small] -= small_requested
  end

  def add_assigned_lockers assigned
    assigned.update_all(assigned: true)
    self.lockers << assigned
  end

end

