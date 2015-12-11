class Combo < ActiveRecord::Base
  belongs_to :tricker

  has_many :list_elements
  has_many :lists, :through => :list_elements

  has_many :elements, :dependent => :delete_all
  has_many :tricks, :through => :elements

  has_one :execution, class_name: "Video"

  attr_accessible :no_tricks, :combo_id, :tricks_attributes, :tricker_id, :sequence, :execution

  self.per_page = 15
  TRANSITION_ARROW_MARKUP = " <span class='transition-mark'>></span> "

  def self.search(query, page)
    paginate :per_page => self.per_page, :page => page,
           :conditions => ['sequence like ?', "%#{query}%"],
           :order => 'sequence'
  end

  def cache_sequence
    self.sequence = self.elements.order(&:index).map(&:trick).map(&:name).join(TRANSITION_ARROW_MARKUP)
  end

  def create_elements(trick_ids)
    trick_ids.each_with_index do |trick_id, index|
      self.elements.create!(index: index, trick_id: trick_id)
    end
  end
end
