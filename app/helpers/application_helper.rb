module ApplicationHelper
  def register?
    return true if request.referer.match(/.+users\/address/)

    false
  end
end
