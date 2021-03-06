class Chapter < ActiveRecord::Base
  PERMITTED_ATTRIBUTES = [:name]

  has_many :locations
  has_many :events, -> { published }, through: :locations
  has_many :external_events
  has_and_belongs_to_many :users
  has_many :leaders, through: :chapter_leaderships, source: :user
  has_many :chapter_leaderships, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name

  def has_leader?(user)
    return false unless user

    return true if user.admin?

    leaders.include?(user)
  end

  def editable_by?(user)
    user.admin? || has_leader?(user)
  end

  def destroyable?
    (locations_count + external_events_count) == 0
  end
end
