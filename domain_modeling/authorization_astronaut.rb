# you might have the follwing following user model:

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  validates_presence_of :name validates_uniqueness_of :name

  def name=(value)
    write_attribute("name", value.downcase)
  end

  def self.[](name
    # Get a role quickly by using: Role[:admin] self.find(:first, :conditions => ["name = ?", name.id2name])
  end

  def add_user(user)
    self.users << user
  end

  def delete_user(user)
    self.users.delete(user)
  end
end

# issues with this approach: User model hardcoding all the string user to identify the individula roles, if one or more were to change, you'd need to change them throughout the application. Overrridden getter for the roles to make it work like a hash is questionable.

# Solution: Simplify the simeple flags. Get rid of the role model entirely, you can give the user model admin, editor, and writer booleans.

# If you eventually need more roles, you can add a Role model back into the appli- cation, but without using a has_and_belongs_to_many. Instead, you would just add a has_many to the Role model with a denormalized role_type that stores the type of role the user has, as shown here:

class User < ActiveRecord::Base
  has_many :roles
end

class Role < ActiveRecord::Base
  TYPES = %w(admin editor writer guest)
  validates :name, :inclusion => { :in => TYPES }
  class << self
    TYPES.each do |role_type|
      define_method "#{role_type}?" do
        exists?(:name => role_type)
      end
    end
  end
end

# To facilitate the change from individual Booleans to a Role model, you use define_method to provide a query method for each role type that allows you to call user.roles.admin?. It is also possible to put these defined methods right on the User model itself, so that user.admin? can be called. That would look as follows:


class User < ActiveRecord::Base
  has_many :roles
  Role::TYPES.each do |role_type|
    define_method "#{role_type}?" do
      roles.exists?(:name => role_type)
    end
  end
end

class Role < ActiveRecord::Base
  TYPES = %w(admin editor writer guest)
  validates :name, :inclusion => {:in => TYPES}
end

# The following simple guidelines will stop you from over-engineering and help you provide simple interfaces that stand up in the face of both underdefined specifications and changes in an application:
# • Never build beyond the application requirements at the time you are writing the code.
# • If you do not have concrete requirements, don’t write any code.
# • Don’t jump to a model prematurely; there are often simple ways, such as using Booleans and denormalization, to avoid using adding additional models.
# • If there is no user interface for adding, removing, or managing data, there is no need for a model. A denormalized column populated by a hash or array of possi- ble values is fine.
