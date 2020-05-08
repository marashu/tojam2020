module ApplicationHelper
  def page_header(header)
    content_tag :div, class: 'page-header' do
      content_tag :div, class: 'row' do
        content_tag(:h1, header, class: 'col-xs-12 col-sm-9')
      end
    end
  end
end
