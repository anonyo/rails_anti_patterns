# Solution: extract into Modules
# Ruby modules are designed to centralize behavior among
# classes, and using them is possibly the simplest way of DRYing up your code. 
# A module is essentially the same as a Ruby class, except that it cannot be instantiated, 
# and it is intended to be included inside other classes or modules. 
# When a class includes a module via include ModuleName, all the methods on that module 
# become instance methods on the class. Although less commonly done, 
# a class can also choose to add a module’s methods as class-level methods by using extend instead of include: 
# extend ModuleName.

# Let’s consider a Ruby on Rails driving game in 
# which two models are defined: Car and Bicycle. Both of these models can accelerate, brake, 
# and turn, and the code for these methods is identical:


class Car << ActiveRecord::Base
  validates :direction, :presence => true validates :speed, :presence => true
  def turn(new_direction)
    self.direction = new_direction
  end

  def brake
    self.speed = 0
  end

  def accelerate
    self.speed = speed + 10
  end
  # Other, car-related activities...
end

class Bicycle << ActiveRecord::Base
  validates :direction, :presence => true validates :speed, :presence => true
  def turn(new_direction)
    self.direction = new_direction
  end

  def brake
    self.speed = 0
  end

  def accelerate
    self.speed = speed + 10
  end
  # Other, car-related activities...
end

# Clearly, this code is not DRY. There are a number of ways to extract and centralize these methods, but the most natural technique is to move them into a module that’s included by both classes:

# lib/drivable.rb

module Drivable
  extend ActiveSupport::Concern

  included do
    validates :direction, presence: true validates :speed, presence: true
  end

  def turn(new_direction)
    self.direction = new_direction
  end

  def brake
    self.speed = 0
  end

  def accelerate
    self.speed = speed + 10
  end
end

class Bicycle << ActiveRecord::Base
  include Drivable
  # other bicycle methods...
end

class Car << ActiveRecord::Base
  include Drivable
  # other car methods...
end

# Loading the modules under lib

#config/initializers/requires.rb
Dir[File.join(Rails.root, 'lib', '*.rb')].each do |f|
  require f
end

# pushing validtion to modules

#You can push the validation into the module as well, by making use of the ActiveSupport::Concern module. 
# This provides a method named included that will be run when the module is included in a Ruby class.
# This hook lets you make use of the Active Record validation macros, 
# which are not available for you to use when the module is defined. 
