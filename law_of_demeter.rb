class Address < ActiveRecord::Base
  belongs_to :customer
end

class Customer < ActiveRecord::Base
  has_one :address
  has_many :invoices
end

class Invoice < ActiveRecord::Base
  belongs_to :customer
end

#This code shows a simple invoice structure, with a customer who has a single address. The view code to display the address lines for the invoice would be as follows:

<%= @invoice.customer.name %>
<%= @invoice.customer.address.street %>
<%= @invoice.customer.address.city %>
<%= @invoice.customer.address.state %>
<%= @invoice.customer.address.zip_code %>

# To follow the Law of Demeter, you could add the following methods to your model:
#

class Address < ActiveRecord::Base
  belongs_to :customer
end
class Customer < ActiveRecord::Base
  has_one :address
  has_many :invoices

  def street
    address.street
  end

  def city
    address.city
  end

  def state
    address.state
  end

  def zip_code
    address.zip_code
  end
end

class Invoice < ActiveRecord::Base
  belongs_to :customer

  def customer_name
    customer.name
  end

  def customer_street
    customer.street
  end

  def customer_city
    customer.city
  end

  def customer_state
    customer.state
  end

  def customer_zip_code
    customer.zip_code
  end
end

#And you could change the view code to the following:
<%= @invoice.customer_name %>
<%= @invoice.customer_street %>
<%= @invoice.customer_city %>
<%= @invoice.customer_state %>
<%= @invoice.customer_zip_code %>

# Downsides to this approach
# * Model is littered with man small wrapper methods
# * If things were to change, all wrapper methods would likely require change.
# Solution: Use Ruby on Rails `delegate` method.
# Using this delegate method, you can rewrite your exam- ple like this:

class Address < ActiveRecord::Base
  belongs_to :customer
end

class Customer < ActiveRecord::Base
  has_one :address
  has_many :invoices
  delegate :street, :city, :state, :zip_code, :to => :address
end

class Invoice < ActiveRecord::Base
  belongs_to :customer

  delegate :name,
           :street,
           :city,
           :state,
           :zip_code,
           :to => :customer,
           :prefix => true
end

#In this situation, you don’t have to change your view code; the methods are exposed just as they were before:
<%= @invoice.customer_name %>
<%= @invoice.customer_street %>
<%= @invoice.customer_city %>
<%= @invoice.customer_state %>
<%= @invoice.customer_zip_code %>
