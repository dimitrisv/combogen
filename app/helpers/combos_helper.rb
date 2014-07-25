module CombosHelper
  def combo_input_value(combo)
    unless combo.nil?
      combo.sequence.split(' > ').join(',')
    else
      ''
    end
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
end
