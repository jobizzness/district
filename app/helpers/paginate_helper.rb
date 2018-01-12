module PaginateHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    def link text, target, attributes = {}
      attributes['data-remote'] = true
      super
    end

    protected
      def page_number page
        classname = 'active' if page == current_page
        tag :li, link(page, page, rel: rel_value(page)), class: classname
      end

      def previous_or_next_page page, text, classname
        # if page
        #   tag :li, link(text, page), class: classname
        # else
        #   tag :li, text, class: classname + ' disabled'
        # end
      end

      def html_container html
        tag :ul, html, container_attributes
      end
  end
end
