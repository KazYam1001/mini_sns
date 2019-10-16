module ApplicationHelper
  def register?
    path = Rails.application.routes.recognize_path(request.referer)
    return true if path[:action] == 'new_address'

    false
  end
end
