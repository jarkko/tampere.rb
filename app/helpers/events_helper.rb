module EventsHelper
  def fmt_date(dob)
    dob.strftime("%d.%m.%Y")
  end
end
