class Tricker < ActiveRecord::Base
  has_one :tricking_style
  has_many :lists, :dependent => :delete_all
  has_many :tricks
  has_many :combos
  validates :name, :presence => true, :uniqueness => true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :sampler, :youtube, :facebook, :admin
  # attr_accessible :title, :body

  protected
  def confirmation_required?
    false
  end
end
