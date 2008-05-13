# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def fmt_date(dob)
    dob.strftime("%d.%m.%Y")
  end
end
