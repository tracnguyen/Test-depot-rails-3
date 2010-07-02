module ApplicationHelper
  def job_status_collection
    [['Draft', 'draft'],['Open', 'open'],['Closed', 'closed']]
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
    elsif d < 2073600
      dy = d/86400
      "#{dy.to_i} day#{dy >=2 ? 's' : ''} ago"
    elsif d < 14515200
      w = d/2073600
      w <=2 ? "last week" : "#{w.to_i} weeks ago"
    elsif d < 756864000
       m = d/14515200
       m <= 2 ? "last month" : "#{m.to_i} months ago"
    else
      y = d/756864000
      y <= 2 ? "last year" : "#{y.to_i} years ago"
    end
  end
end
