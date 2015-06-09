#Here is the Order model for this online store application:

# app/models/order.rb
class Order < ActiveRecord::Base
  def self.find_purchased
  end

  def self.find_waiting_for_review
  end

  def self.find_waiting_for_sign_off
  end
  def self.find_waiting_for_sign_off
  end

  def self.advanced_search(fields, options = {})
  end

  def self.simple_search(terms) # ...
  end

  # conversion methods

  def to_xml
  end

  def to_json
  end

  def to_csv
  end

  def to_pdf
  end
end

#model obesity tends to creep up on new Ruby on Rails developers. The maintenance and readability issues created by these obese classes quickly become apparent.


# Solution: Delegate Responsibility to New Classes
# Looking at the conversion methods, they clearly don't belong there and should be extracted to its own class. This is an application of the Single Responsibility Principle. While the spirit of this principle has always existed as part of object-oriented design, the term was first coined by Robert Cecil Martin, in his paper “SRP: The Single Responsibility Principle.

class Order < ActiveRecord::Base
  def converter
    OrderConverter.new(self)
  end
end
# app/models/order_converter.rb
class OrderConverter
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def to_xml
  end

  def to_json
  end

  def to_csv
  end

  def to_pdf
  end
end

# In this way, you give the conversion methods their own home, inside a separate and easily testable class. Exporting the PDF version of an order is now just a matter of call- ing the following:

@order.converter.to_pdf

#Although the chaining introduced in the preceding section upholds the Single Responsibility Principle, it violates the Law of Demeter. You can fix this by making use of Ruby on Rails delegation support:

# app/models/order.rb

class Order < ActiveRecord::Base
  delegate :to_xml, :to_json, :to_csv, :to_pdf, :to => :converter

  def converter
    OrderConverter.new(self)
  end
end

#Now you can retain your @order.to_pdf
