class Trick < ActiveRecord::Base
	belongs_to :tricker
  has_and_belongs_to_many :tricking_styles
	has_many :elements, :dependent => :delete_all
	has_many :combos, :through => :elements
	attr_accessible :difficulty, :landed, :name, :trick_type, :tricker_id, :trick_type
	validates :name, :presence => true, :uniqueness => true

	scope :order_by_combo,
        select("*, count(combos.id) AS no_combos").joins(:combos).group("tricks.id").order("no_combos DESC")

end
