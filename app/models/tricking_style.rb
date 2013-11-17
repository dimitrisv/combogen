class TrickingStyle < ActiveRecord::Base
  belongs_to :tricker
  has_and_belongs_to_many :tricks
  attr_accessible :description, :name
end
