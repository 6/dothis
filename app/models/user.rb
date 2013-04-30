class User < ActiveRecord::Base
  attr_accessible :email, :username, :password
  has_secure_password

  has_many :tasks, :inverse_of => :user

  before_create :generate_auth_token

  validates_uniqueness_of :auth_token
  validates_uniqueness_of :email, :case_sensitive => false
  validates_uniqueness_of :username, :case_sensitive => false
  validates :email, :format => {:with => /^[^@]+@[^@]+\.[^@]+$/}
  validates :username, :format => {:with => /^[-_a-zA-Z0-9]+$/}, :length => {:minimum => 1, :maximum => 30}
  validates :password, :length => {:minimum => 6}

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64(180)
  end
end
