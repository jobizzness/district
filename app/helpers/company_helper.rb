module CompanyHelper
  def address(company)
    [ company.address1, company.address2, company.city,
      company.state, company.country, company.zip ].join ', '
  end
end