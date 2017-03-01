module ApplicationHelper
  def hide_div_if(condition, attributes, &block)
    if condition
      attributes['style'] = 'display:none'
      attributes['class'] =  attributes['class'].nil? ? 'hidden' : "#{attributes['class']}hidden"
    end
    content_tag('div', attributes, &block)
  end
end
