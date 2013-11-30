class List < ActiveRecord::Base
  belongs_to :tricker
  has_many :list_elements, :dependent => :delete_all
  has_many :combos, :through => :list_elements
  attr_accessible :description, :name, :visibility, :tricker_id
end
