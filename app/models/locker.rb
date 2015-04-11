class Locker < ActiveRecord::Base
  scope :unassigned, -> { where(assigned: false) }
  scope :large,      -> { where(size: "LARGE") }
  scope :medium,     -> { where(size: "MEDIUM") }
  scope :small,      -> { where(size: "SMALL") }

  belongs_to :reservation

  validates :number, presence: true, uniqueness: { case_sensitive: false }
  validates :size, presence: true
  validates :assigned, inclusion: { in: [true, false] }

  def self.lockers_left
    unassigned_lockers = Locker.unassigned
    large_left  = unassigned_lockers.large.count
    medium_left = unassigned_lockers.medium.count
    small_left  = unassigned_lockers.small.count
    
    { large: large_left, medium: medium_left, small: small_left }
  end

  def self.max_bags_allowed
    left = Locker.lockers_left

    { large: left[:large], medium: left[:large] + left[:medium], 
      small: left[:large] + left[:medium] + left[:small] }
  end
end
