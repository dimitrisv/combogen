module CombosHelper
  def combo_input_value(combo)
    unless combo.nil?
      combo.sequence.split(' > ').join(',')
    else
      ''
    end
  end

  def new_combo_anchor(trick_name)
    "new/#{@trick.name.gsub(' ', '_')}"
  end

  def available_styles_options
    styles = { "The Database" => "database" }
    if current_tricker.tricking_style.tricks.count > 0
      styles["My Trick List"] = "list"
    end
    styles
  end
  
  def my_tricks_for_selectize
    tricks = []
    current_tricker.tricking_style.tricks.each do |t|
      tricks << { name: t.name, type: 'list' }
    end
    tricks.to_json
    # current_tricker.tricking_style.tricks.map(&:name).join(',')
  end

  def db_tricks_for_selectize
    tricks = []
    (Trick.all - current_tricker.tricking_style.tricks).each do |t|
      tricks << { name: t.name, type: 'database' }
    end
    tricks.to_json
  end

  def my_lists_for_selectize
    lists = []
    current_tricker.lists.each do |list|
      lists << {name: list.name}
    end
    lists.to_json
  end
end
