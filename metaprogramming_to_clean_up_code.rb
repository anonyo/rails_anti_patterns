# Metaprogramming is commonly defined as “code that pro- duces code,”
# Following model has some code repetition.

class Purchase < ActiveRecord::Base
  validates_presence_of :status validates_inclusion_of :status,
                                                       :in => %w(in_progress submitted approved shipped received canceled)

# Status Finders
  def self.all_in_progress
    where(:status => "in_progress")
  end
  def self.all_submitted
    where(:status => "submitted")
  end
  def self.all_approved
    where(:status => "approved")
  end
  def self.all_shipped
    where(:status => "shipped")
  end
  def self.all_received
    where(:status => "received")
  end
  def self.all_canceled
    where(:status => "canceled")
  end

  # Status Accessors
  def in_progress?
  status == "in_progress"
  end
  def submitted?
  status == "submitted"
  end
  def approved?
  status == "approved"
  end
  def shipped?
  status == "shipped"
  end
  def received?
  status == "received"
  end
  def canceled?
  status == "canceled"
  end
end

# It’s immediately obvious that this is a code maintenance issue in the making. For now you can ignore the fact that this is a very large amount of code for this feature (more on that in a bit) because the real issue is that the code isn’t DRY.

# What happens when a client says to you three months down the road that she needs Purchase objects to go through “partially shipped” and “fully shipped” statuses instead of just “shipped”? You now have to edit the states in three distinct places: the validation, the finders, and the accessors. DRY encourages you to hold that type of information in a single, authoritative place. You can accomplish this with a bit of metaprogramming:


class Purchase < ActiveRecord::Base
  STATUSES = %w(in_progress submitted approved shipped received)
  validates_presence_of :status validates_inclusion_of :status, :in => STATUSES
  # Status Finders
  class << self
    STATUSES.each do |status_name|
      define_method "all_#{status_name}"
        where(:status => status_name)
      end
    end
  end

  # Status Accessors
  STATUSES.each do |status_name|
    define_method "#{status_name}?"
      status == status_name
    end
  end
end
# Few issues with this approach: reduces code readability, increases complexity, possible solution: extract the loops into a macro.


# lib/extensions/statuses.rb
class ActiveRecord::Base
  def self.has_statuses(*status_names)
    validates :status,
              :presence => true,
              :inclusion => { :in => status_names }

    # Status Finders
    status_names.each do |status_name|
      scope "all_#{status_name}", where(:status => status_name)
    end

    # Status Accessors
    status_names.each do |status_name|
      define_method "#{status_name}?" do
        status
      end
    end
  end
end

class Purchase < ActiveRecord::Base
  has_statuses :in_progress, :submitted,
               :approved, :shipped, :received
  # combines statuses
  scope :all_not_shipped, where(:status => ["partially_shipped", "fully_shipped"]

  def not_shipped?
    !(partially_shipped? or fully_shipped?)
  end
end
