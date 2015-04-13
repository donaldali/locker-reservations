module ApplicationHelper
  def page_title title
    title.blank? ? "UT Hotel" : "#{ title } | UT Hotel"
  end
end
