class Trick < ActiveRecord::Base
	belongs_to :tricker
  has_and_belongs_to_many :tricking_styles
	has_many :elements, :dependent => :delete_all
	has_many :combos, :through => :elements
  has_many :tutorials, class_name: "Video"

	attr_accessible :difficulty, :landed, :name, :trick_type, :tricker_id
	validates :name, :presence => true, :uniqueness => true


  # Filters a collection of combos using a given tricking style
  # Currently used for the trick list only
  def combos_in_tricking_style(tricker, style)
    # get all the combos using this trick
    combos = self.combos.uniq

    # remove my combos from this list
    combos.reject! { |c| c.tricker == tricker  }
    
    # get the ids of the tricks I can do
    included_tricks = style.tricks.map(&:id)

    # (style-combo).count == style.count - combo.count
    # this hits the database twice. is there a better way?
    combos.reject! { |c| ((included_tricks-c.tricks.map(&:id)).count != (included_tricks.count - c.tricks.uniq.map(&:id).count)) }

    combos or []
  end

  # Removes a trick that's being deleted from all the combos
  # that it belongs to.
  def remove_from_combos
    # Get all the combos associated with this trick
    self.combos.uniq.each do |combo|
      # Get the number of times the trick appears in this combo
      # and subtract from total num of tricks
      no_tricks = combo.no_tricks
      no_duplicates = combo.tricks.where(:name => @trick.name).length
      combo.no_tricks = no_tricks - no_duplicates
      
      # If a combo ends up with less than 2 tricks, delete it
      if (combo.no_tricks < 2)
        combo.destroy
      else
        # Update the indexes of the remaining tricks in the combo
        index = 1
        combo.elements.each do |elem|
          if elem.trick.name != self.name
            elem.index = index
            elem.save
            index += 1
          else
            elem.delete
          end
        end
      end
      combo.cache_sequence
    end
  end

end
