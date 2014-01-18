class Tricker < ActiveRecord::Base
  has_one :tricking_style, :dependent => :delete_all
  has_many :lists, :dependent => :delete_all
  has_many :tricks, :dependent => :delete_all
  has_many :combos, :dependent => :delete_all
  has_many :videos, :dependent => :delete_all
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :sampler, :youtube, :facebook, :admin
  # attr_accessible :title, :body

  validates :name, :presence => true, :uniqueness => true, length: { minimum: 3, maximum: 20 }

  protected
  def confirmation_required?
    false
  end
end
