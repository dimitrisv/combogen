module ApplicationHelper

  def current_tricker_can_edit_trick(trick)
    current_tricker.try(:admin?) || (!trick.tricker.nil? && (trick.tricker.id.equal? current_tricker.id))
  end

  def current_tricker_can_edit_combo(combo)
    current_tricker.try(:admin?) || (combo.tricker.id.equal? current_tricker.id)
  end

  def current_tricker_can_edit_style(tricking_style)
    current_tricker.try(:admin?) || (tricking_style.tricker_id.equal? current_tricker.id)
  end

  def get_trick_types
    [ "Kick", "Flip", "Twist", "EX", "Invert", "Groundmove", "Kick, Flip",
      "Flip, Twist", "Kick, Twist", "Kick, Flip, Twist" ]
  end

  def get_difficulty_classes
    [ "A", "B", "C", "D", "E", "F", "FND", "EX" ]
  end

end
