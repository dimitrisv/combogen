module CombosHelper
  def combo_input_value
    unless @combo.nil?
      @combo.sequence.split(' > ').join(',')
    else
      ''
    end
  end
end
