class Trick < ActiveRecord::Base
  attr_accessible :difficulty, :landed, :name, :setup
  has_many :elements
  has_many :combos, :through => :elements
end
