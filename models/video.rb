require File.join(File.dirname(__FILE__), 'conector_ar')

class Video < ActiveRecord::Base
  belongs_to :origin_opinion, :class_name => "Video", :foreign_key => :origin_opinion_id
  belongs_to :reply_to_opinion, :class_name => "Video", :foreign_key => :reply_to_opinion_id

  belongs_to :user
  belongs_to :topic
  #validates :topic_id, presence: true

  has_many :ticckles, dependent: :destroy
  #has_many :viewings, dependent: :destroy, as: :viewable


  #def ticckles_count
    #ticckles ? ticckles.select { |t| t.active==true }.count : 0 
  #end

  def serializable_hash(opts)
    update_attribute 'uuid', SecureRandom.hex if uuid.blank?
    {
      uuid: uuid,
      title: title,
      tags: tags,
      points: points,
      length: length,
      guid: guid,
      s3_key: s3_key,
      state: state,
      user: user.as_json
    }
  end

end
