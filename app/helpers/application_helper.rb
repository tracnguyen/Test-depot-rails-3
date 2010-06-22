module ApplicationHelper
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
end
