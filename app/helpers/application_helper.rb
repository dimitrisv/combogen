module ApplicationHelper
  def current_tricker_can_edit_trick
    current_tricker.try(:admin?) || (!@trick.tricker.nil? && (@trick.tricker.id.equal? current_tricker.id))
  end
  def current_tricker_can_edit_combo
    current_tricker.try(:admin?) || (@combo.tricker.id.equal? current_tricker.id)
  end
  def current_tricker_can_edit_style
    current_tricker.try(:admin?) || (@tricking_style.tricker_id.equal? current_tricker.id)
  end
end
