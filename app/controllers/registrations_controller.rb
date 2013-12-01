class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.tricking_style = TrickingStyle.create(:tricker_id => resource.id, :name => "My Trick List", :description => "All the tricks I can do.")
    resource.save
    resource.lists << List.create(:tricker_id => resource.id, :name => "Favorites",   :visibility => "Public" )
    resource.lists << List.create(:tricker_id => resource.id, :name => "Working on",  :visibility => "Public" )
    resource.lists << List.create(:tricker_id => resource.id, :name => "Landed",      :visibility => "Public" )
  end
end
