class Tricker < ActiveRecord::Base
  has_one :tricking_style, :dependent => :delete
  has_many :lists, :dependent => :delete_all
  has_many :tricks, :dependent => :delete_all
  has_many :combos, :dependent => :delete_all
  has_many :videos, :dependent => :delete_all
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :sampler, :youtube, :facebook, :admin

  validates :name, :presence => true, :uniqueness => true, length: { minimum: 3, maximum: 20 }

end
