class Combo < ActiveRecord::Base
  belongs_to :tricker
  
  has_many :list_elements
  has_many :lists, :through => :list_elements

  has_many :elements, :dependent => :delete_all
  has_many :tricks, :through => :elements

  has_one :execution, class_name: "Video"
  
  attr_accessible :no_tricks, :combo_id, :tricks_attributes, :tricker_id, :sequence, :execution

  self.per_page = 15



  def self.search(query, page)
    paginate :per_page => self.per_page, :page => page,
           :conditions => ['sequence like ?', "%#{query}%"],
           :order => 'sequence'
  end

  def render_sequence
    self.sequence = self.elements.map(&:trick).map(&:name).join(' > ')
  end

  def create_elements(trick_ids)
    trick_ids.each_with_index do |trick_id, index|
      self.elements.create!(index: index, trick_id: trick_id)
    end
  end
end
