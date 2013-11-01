class Trick < ActiveRecord::Base
  attr_accessible :difficulty, :landed, :name, :setup
  has_many :elements, :dependent => :delete_all
  has_many :combos, :through => :elements
end
