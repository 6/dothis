module ApplicationHelper
  # http://stackoverflow.com/a/2962410/659050
  def inside_layout(layout, &block)
    render :inline => capture_haml(&block), :layout => "layouts/#{layout}"
  end

  def link_to_active(text, path, options = {})
    if current_page?(path)
      options[:class] ||= ""
      options[:class] += " active"
    end
    link_to text, path, options
  end
end
