class AddConfirmableToUsers < ActiveRecord::Migration
	 # Note: You can't use change, as User.update_all with fail in the down migration
  def self.up
    add_column :trickers, :confirmation_token, :string
    add_column :trickers, :confirmed_at, :datetime
    add_column :trickers, :confirmation_sent_at, :datetime
    add_column :trickers, :unconfirmed_email, :string
    add_index :trickers, :confirmation_token, :unique => true
    # Update all existing trickers as confirmed
    Tricker.update_all(:confirmed_at => Time.now)
  end

  def self.down
    remove_index :trickers, :confirmation_token
    remove_columns :trickers, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
  end
end
