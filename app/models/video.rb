class Video < ActiveRecord::Base
  
  # NOTE: Currently supports YouTube video only!

  belongs_to :tricker
  belongs_to :trick
  belongs_to :combo
  attr_accessible :url, :uid, :tricker_id, :combo_id, :trick_id, :start_time, :end_time

  before_save :extract_uid



  private

  def extract_uid   
    if url[/youtu\.be\/([^\?]*)/]
      self.uid = $1
    else
      # Regex from
      # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      self.uid = $5
    end
    # later I can insert this directly as a data attribute
    # %Q{<iframe title="YouTube video player" width="640" height="390" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
  end

end
