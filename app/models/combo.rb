class Combo < ActiveRecord::Base
  belongs_to :tricker
  
  has_many :list_elements
  has_many :lists, :through => :list_elements

  has_many :elements, :dependent => :delete_all
  has_many :tricks, :through => :elements
  
  accepts_nested_attributes_for :tricks, :reject_if => lambda { |a| a[:content].blank? }
  attr_accessible :no_tricks, :combo_id, :tricks_attributes, :tricker_id
end
