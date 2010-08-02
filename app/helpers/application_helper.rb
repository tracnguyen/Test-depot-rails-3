module ApplicationHelper
  CharColorMapping = {
    '#000000' => '#FFFFFF', 
    '#993300' => '#FFFFFF',
    '#333300' => '#FFFFFF', 
    '#000080' => '#FFFFFF', 
    '#333399' => '#FFFFFF', 
    '#333333' => '#FFFFFF', 
    '#800000' => '#FFFFFF', 
    '#FF6600' => '#FFFFFF', 
    '#808000' => '#FFFFFF', 
    '#008000' => '#FFFFFF', 
    '#008080' => '#FFFFFF', 
    '#0000FF' => '#FFFFFF', 
    '#666699' => '#FFFFFF', 
    '#808080' => '#FFFFFF', 
    '#FF0000' => '#FFFFFF', 
    '#FF9900' => '#FFFFFF', 
    '#99CC00' => '#FFFFFF', 
    '#339966' => '#FFFFFF', 
    '#33CCCC' => '#FFFFFF', 
    '#3366FF' => '#FFFFFF', 
    '#800080' => '#FFFFFF', 
    '#999999' => '#FFFFFF', 
    '#FF00FF' => '#FFFFFF', 
    '#FFCC00' => '#000000', 
    '#FFFF00' => '#000000', 
    '#00FF00' => '#000000', 
    '#00FFFF' => '#000000', 
    '#00CCFF' => '#000000', 
    '#993366' => '#000000', 
    '#C0C0C0' => '#000000', 
    '#FF99CC' => '#000000', 
    '#FFCC99' => '#000000', 
    '#FFFF99' => '#000000', 
    '#CCFFFF' => '#000000', 
    '#99CCFF' => '#000000', 
    '#FFFFFF' => '#000000'
  };
  
  def job_status_collection
    [['Draft', 'draft'],['Open', 'open'],['Close', 'close']]
  end
  
  def job_filter_collection
    [["All", ""]] + current_account.jobs.collect{|job| [job.title, job.id.to_s]}
  end

  def application_status_collection
    current_account.job_stages.each.collect{|s| [s.name, s.id]}
  end

  def apt_status_filter_collection
    [["All", ""]] + current_account.job_stages.collect{|s| [s.name, s.id.to_s]} 
  end
  
  def humanize_time(t)
    t0 = Time.now
    d = (t0 - t).to_f
    if d < 60
      "just now"
    elsif d < 3600
      m = d/60
      "#{m.to_i} minute#{m >=2 ? 's' : ''} ago"
    elsif d < 86400
      h = d/3600
      "#{h.to_i} hour#{h >=2 ? 's' : ''} ago"
    elsif d < 604800
      dy = d/86400
      "#{dy.to_i} day#{dy >=2 ? 's' : ''} ago"
    elsif d < 2419200
      w = d/604800
      w <=2 ? "last week" : "#{w.to_i} weeks ago"
    elsif d < 29030400 # not exactly a year, we just count a month as 30 days
       m = d/2419200
       m <= 2 ? "last month" : "#{m.to_i} months ago"
    else
      y = d/31536000
      y <= 2 ? "last year" : "#{y.to_i} years ago"
    end
  end
  
  def map_to_char_color(background_color)
    background_color.gsub!(/\s/, '')
    background_color.upcase!
    CharColorMapping[background_color]
  end
end
