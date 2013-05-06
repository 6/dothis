class Task < ActiveRecord::Base
  attr_accessible :title, :completed_at

  belongs_to :user, :inverse_of => :tasks

  validates :title, :length => {:minimum => 1}

  def as_json(options = {})
    {
      id: id,
      title: title,
      completed: !!completed_at,
    }
  end

  def update_from_backbone_params(params)
    completed_at = params[:completed] ? Time.now : nil
    update_attributes!(title: params[:title], completed_at: completed_at)
  end
end
