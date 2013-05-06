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

  def tasks_completed_by_day_as_json
    by_day = tasks_completed_by_day
    (1.year.ago.to_date..Date.today).map do |date|
      date_string = date.strftime("%Y-%m-%d")
      {
        date: date_string,
        count: by_day[date_string] || 0,
      }
    end
  end

  def as_json
    {
      id: id,
      username: username,
    }
  end

  private

  def tasks_completed_by_day
    # TODO - fix groupdate gem so it can use user.tasks
    by_day = {}
    Task
      .where(:user_id => id)
      .where('completed_at IS NOT NULL')
      .where('completed_at > ?', 1.year.ago)
      .group_by_day(:completed_at)
      .order('day ASC')
      .count.each do |date, count|
        by_day[Date.parse(date).strftime("%Y-%m-%d")] = count
      end
    by_day
  end

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64(180)
  end
end
