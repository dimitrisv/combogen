class Combo < ActiveRecord::Base
  attr_accessible :landed, :no_tricks
  has_many :elements
  has_many :tricks, :through => :elements
end
