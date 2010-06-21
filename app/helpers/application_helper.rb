module ApplicationHelper
  def job_status_collection
    [['Draft', 'draft'],['Open', 'open'],['Close', 'close']]
  end
  
  def job_filter_collection
    [["All", ""]] + current_account.jobs.collect{|job| [job.title, job.id.to_s]}
  end

  def application_status_collection
    [["New", "new"], ["Screened", "screened"], ["Interviewed", "interviewed"], ["Offered", "offered"], ["Hired", "hired"], ["Rejected", "rejected"]]
  end

  def apt_status_filter_collection
    [["All", ""], ["New", "new"], ["Screened", "screened"], ["Interviewed", "interviewed"], ["Offered", "offered"], ["Hired", "hired"], ["Rejected", "rejected"]]
  end
end
