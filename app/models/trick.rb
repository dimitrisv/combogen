class Trick < ActiveRecord::Base
	belongs_to :tricker
	has_many :elements, :dependent => :delete_all
	has_many :combos, :through => :elements
	attr_accessible :difficulty, :landed, :name, :setup, :tricker_id
	validates :name, :presence => true, :uniqueness => true

	scope :order_by_combo,
    	select("*, count(combos.id) AS no_combos").
    	joins(:combos).
    	group("tricks.id").
    	order("no_combos DESC")

end
