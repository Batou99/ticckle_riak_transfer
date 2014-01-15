require File.join(File.dirname(__FILE__), 'conector_ar')

class Topic < ActiveRecord::Base

  has_many :videos, dependent: :destroy

  belongs_to :user

  #has_many :tracked_topics
  #has_many :watchers, :through => :tracked_topics, :source => :user


  #before_create :generate_permalink

  #def generate_permalink
    #self.permalink = discussion.to_s.parameterize.split("-").slice(0..4).join("-")
  #end

  def permalink
    discussion.to_s.parameterize.split("-").slice(0..4).join("-")
  end
  def similiar_topics(categories = [category])
    Topic.
      where(category_id: categories.map(&:id)).
      where('id <> ?', id).
      limit(8)
  end

  def name
    self.discussion ? self.discussion.truncate(30) : nil
  end

  def to_param
    "#{self.id}-#{self.name.to_s.parameterize}"
  end

  def serializable_hash(opts)
    {
      discussion: discussion,
      points: points,
      #tags: tags,
      views_count: views_count,
      permalink: permalink,
      updated_at: updated_at,
      created_at: created_at,
      videos: videos.map(&:as_json)
    }

  end

end

