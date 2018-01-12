module AdminHelper
  def navbar_link link_text, link_path
    current_controller = controller.request.path_parameters[:controller]
    link_controller = Rails.application.routes.recognize_path(link_path)[:controller]

    content_tag :li, class: ('active' if current_controller == link_controller) do
      link_to link_text, link_path
    end
  end

  def navbar_sub_link link_text, link_path
    class_name = 'active' if current_page?(link_path)
    content_tag :li, class: class_name do
      link_to link_text, link_path
    end
  end

  def blog_categories
    ArticlesCat.pluck(:title, :id)
  end
end
