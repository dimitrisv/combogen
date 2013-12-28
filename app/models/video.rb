class Video < ActiveRecord::Base
  belongs_to :tricker
  belongs_to :trick
  belongs_to :combo
  attr_accessible :url, :tricker_id, :combo_id, :trick_id

  # Currently assumes youtube video
  def get_video_id
    if url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end
    # later I can insert this directly as a data attribute
    # %Q{<iframe title="YouTube video player" width="640" height="390" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
  end

end
