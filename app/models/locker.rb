class Locker < ActiveRecord::Base
  belongs_to :reservation

  validates :number, presence: true, uniqueness: { case_sensitive: false }
  validates :size, presence: true
  validates :reservation_id, presence: true
  validates :assigned, inclusion: { in: [true, false] }
end
