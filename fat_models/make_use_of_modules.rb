#Let’s take another look at the Order object model, this time using Ruby modules to slim it down:

# app/models/order.rb

class Order < ActiveRecord::Base

  def self.find_purchased
  end

  def self.find_waiting_for_review
  end

  def self.find_waiting_for_sign_off
  end

  def self.advanced_search(fields, options = {})
  end

  def self.simple_search(terms)
  end
end

# Modules allow you to extract behavior into separate files. This improves readabil- ity by leaving the Order model file with just the most important Order-related code. Modules also serve to group related information into labeled namespaces. The methods can be grouped into modules that share behavior.

# lib/order_state_finders.rb

module OrderStateFinders
  def find_purchased
  end

  def find_waiting_for_review
  end

  def find_waiting_for_sign_off
  end
end

# lib/order_searchers.rb module OrderSearchers

module OrderSearchers
  def advanced_search(fields, options = {})
  end

  def simple_search(terms)
  end
end

# The new order class would look like:
#
class Order < ActiveRecord::Base
  extend OrderStateFinders
  include OrderSearchers
end

#There is a difference between include and extend in this Order object model: include puts the module’s methods on the calling class as instance methods, and extend makes them into class methods.

