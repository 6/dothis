class Task < ActiveRecord::Base
  attr_accessible :title, :completed_at

  belongs_to :user, :inverse_of => :tasks

  validates :title, :length => {:minimum => 1}
end
