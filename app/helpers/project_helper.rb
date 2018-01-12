module ProjectHelper
  def project_status_name project
    case project.status
    when 'not_approved'
      'Not approved'
    when 'opened'
      project.count_of_bids > 0 ? pluralize(project.count_of_bids, 'bid') : 'Waiting for bids'
    when 'in_work'
      'In work'
    when 'completed'
      'Completed'
    when 'disputed'
      'In dispute'
    when 'cancelled'
      'Cancelled'
    end
  end
end