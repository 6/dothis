module ApplicationHelper
  def link_to_active(text, path, options = {})
    if current_page?(path)
      options[:class] ||= ""
      options[:class] += " active"
    end
    link_to text, path, options
  end
end
