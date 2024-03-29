class User < ActiveRecord::Base
  # thumbs_up gem
  acts_as_voter

  has_many :videos

  has_many :assignments
  has_many :roles, :through => :assignments

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  validates :username, :presence => true
  validates :username, :uniqueness => true
  validates :username, :format => { :with => /^[a-zA-Z0-9_]{3,20}$/, 
    :message => "must be combination of numbers and/or letters between 3 to 20 characters long" }

  # roles are :admin, :manager
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

end
