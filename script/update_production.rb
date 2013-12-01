@trickers = Tricker.all.select { |t| t.tricking_style.nil? }

@trickers.each do |t|
  t.tricking_style = TrickingStyle.create(:tricker_id => resource.id, :name => "My Trick List", :description => "All the tricks I can do.")
  t.save
end