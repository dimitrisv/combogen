class Combo < ActiveRecord::Base
  belongs_to :tricker
  
  has_many :list_elements
  has_many :lists, :through => :list_elements

  has_many :elements, :dependent => :delete_all
  has_many :tricks, :through => :elements

  has_one :execution, class_name: "Video"
  
  accepts_nested_attributes_for :tricks, :reject_if => lambda { |a| a[:content].blank? }
  attr_accessible :no_tricks, :combo_id, :tricks_attributes, :tricker_id, :sequence

  def render_sequence
    self.sequence = self.elements.where(:index => 1).first.trick.name
    index = 2
    (self.elements.count-1).times do
      self.sequence += " > " + self.elements.where(:index => index).first.trick.name
      index += 1
    end
    self.save
  end
end
