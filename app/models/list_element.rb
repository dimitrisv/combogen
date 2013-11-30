class ListElement < ActiveRecord::Base
  attr_accessible :index, :combo_id, :list_id
  belongs_to :list
  belongs_to :combo
end
