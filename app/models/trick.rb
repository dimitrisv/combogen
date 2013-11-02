class Trick < ActiveRecord::Base
	has_many :elements, :dependent => :delete_all
	has_many :combos, :through => :elements
	attr_accessible :difficulty, :landed, :name, :setup
	validates :name, :presence => true, :uniqueness => true
end
