module ApplicationHelper

	USER_NAME_REGEX =  /(?<user_name>[a-z]_?(?:[a-z0-9]_?)*)/

	# Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Обеденный советник"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
