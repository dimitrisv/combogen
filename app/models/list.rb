class List < ActiveRecord::Base
  belongs_to :tricker
  has_many :list_elements, :dependent => :delete_all
  has_many :combos, :through => :list_elements
  attr_accessible :description, :name, :visibility, :tricker_id
  validates :name, :presence => true, length: { minimum: 3, maximum: 20 }
  validates :description, length: { maximum: 255 }

  def to_s
    "#{name} (#{combos.count})"
  end

end
