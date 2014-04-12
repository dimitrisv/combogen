# NOTE: Currently supports YouTube videos only!
class Video < ActiveRecord::Base
  belongs_to :tricker
  belongs_to :trick
  belongs_to :combo
  attr_accessible :url, :uid, :tricker_id, :combo_id, :trick_id, :start_time, :end_time

  before_create :extract_uid

  YT_LINK_FORMAT = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

  private

  def extract_uid
    uid = url.match(YT_LINK_FORMAT)
    self.uid = uid[2] if uid && uid[2]
   
    if self.uid.to_s.length != 11
      self.errors.add(:url, 'is invalid.')
      false
    end
  end

end
