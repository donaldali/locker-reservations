class ReservationValidator < ActiveModel::Validator
  def validate record
    allowed = Locker.max_bags_allowed
    return unless lockers_avaliable?(record, allowed)
    validate_owner(record)
    validate_all_sizes(record, allowed)
    validate_individual_sizes(record, allowed)
  end


  private


  def lockers_avaliable?(record, allowed)
    if allowed[:small].zero?
      record.errors[:base] << "THERE ARE CURRENTLY NO AVALIABLE LOCKERS."
      return false
    end
    true
  end

  def validate_owner record
    if record.bags_owner.blank?
      record.errors[:bags_owner] << "can't be blank. Please search from list provided."
    elsif Customer.from_identifier(record.bags_owner).nil?
      record.errors[:bags_owner] << "is invalid. Please search from list provided."
    end
  end

  def validate_all_sizes(record, allowed)
    large_requested  = record.large.to_i
    medium_requested = record.medium.to_i
    small_requested  = record.small.to_i

    if large_requested <= 0 && medium_requested <= 0 && small_requested <= 0
      record.errors[:base] << "At least one bag type must be more than 0."
    end

    if (large_requested + medium_requested) > allowed[:medium] ||
       (large_requested + medium_requested + small_requested) > allowed[:small]
      left = Locker.lockers_left
      record.errors[:base] << "Not enough free lockers for bags requested. " \
                              "Lockers available - Large: #{left[:large]}; " \
                              "Medium: #{left[:medium]}; Small: #{left[:small]}."
    end
  end

  def validate_individual_sizes(record, allowed)
    validate_large(record, allowed[:large])
    validate_medium(record, allowed[:medium])
    validate_small(record, allowed[:small])
  end

  def validate_large(record, max_size)
    if record.large.to_i > max_size
      record.errors[:large] << "must be between 0 and #{max_size}."
    end
  end

  def validate_medium(record, max_size)
    if record.medium.to_i > max_size
      record.errors[:medium] << "must be between 0 and #{max_size}."
    end
  end

  def validate_small(record, max_size)
    if record.small.to_i > max_size
      record.errors[:small] << "must be between 0 and #{max_size}."
    end
  end
end
