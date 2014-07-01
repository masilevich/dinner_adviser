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

  def current_user?(user)
    current_user == user
  end

  def wrap(content)
    if !content.nil?
      sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
    end
  end

  private

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
    text.scan(regex).join(zero_width_space)
  end
end
