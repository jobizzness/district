class Mail::CreateProject
  def self.call project, company
    ProjectMailer.create_project(project, company).deliver
  end
end
