module ApplicationHelper
  def register?
    return true if request.referer.match(/.+users\/new_address/)

    false
  end
end
