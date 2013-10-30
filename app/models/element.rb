class Element < ActiveRecord::Base
  belongs_to :combo
  belongs_to :trick
  attr_accessible :index, :combo_id, :trick_id
end
