class AdminMailerPreview < ActionMailer::Preview
  def create_company_after_imports
    user = User.last
    company = user.company
    token = 'test'
    AdminMailer.create_company(user, company, token)
  end
end
