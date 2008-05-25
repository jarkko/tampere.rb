# Methods added to this helper will be available to all templates in the application.

class ActiveRecord::Base
  def fmt_date
    if self.respond_to? :date
      formatted_date(self.date)
    else
      raise MethodMissing, "object doesn't respond to date"
    end
  end

  private

  def formatted_date(date)
    date.strftime("%d.%m.%Y")
  end
end

module ApplicationHelper
  def fmt_date(dob)
    dob.strftime("%d.%m.%Y")
  end

  def back_to(path, description)
    link_to('&larr; ' + description, path)
  end

  def build_selection(objects, menu_attribute)
    objects.map { |obj| [obj.send(menu_attribute), obj.id] }
  end

  def menu_link_to(description, path, request)
    span_id = description.downcase
    if path != request.path
      description += " &raquo;" unless path == request.path
    end
    content_tag(:span, link_to(description, path), :id => span_id)
  end

  def more_link_to(path)
    link_to "Lue lisää &raquo;", path
  end
end

