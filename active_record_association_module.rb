# All the association declarations allow you to specify a module via the :extend option, which will be mixed into the association. Any meth- ods on that module will then become methods on the association, much as with the block format. You add :extend to the association definition, as shown in the follow- ing module and class definitions:

module ToyAssocationMethods
  def cute
    where(cute: true)
  end
end

class Pet < ActiveRecord::Base
  has_many :toys, extend: ToyAssocationMethods
end

class Owner < ActiveRecord::Base
  has_many :toys, extend: ToyAssocationMethods
end

#you can call: @pet.toys.cute or @owner.toys.cute
