module ApplicationHelper
  def metaTitle
    @company.present? && @company.name.present? ? @company.name : getPageInfo.title
  end

  def metaDescription
    @company.present? && @company.description.present? ? @company.description : getPageInfo.description
  end

  def getPageInfo
    PageInfo.last
  end

  def getPress
    press, links = Press.all, ''
    press.each { |p| links += link_to content_tag(:span, image_tag(p.pic, alt: p.title, title: p.title)), p.link, target: '_blank' }
    links.html_safe
  end

  def getLatestNews
    Article.all.limit(4)
  end

  def getCategories
    Category.all
  end

  def getSubcategory
    Subcategory.all
  end

  def getLocations
    UsaState.all_data
  end

  def getCountries
    Country.all
  end

  def getTxt val, tp = false
    col = tp ? 'txt' : 'val'
    Ctrl.find_by(nm: val)[col]
  end

  def nav_link link_text, link_path, link_class=''
    class_name = current_page?(link_path) ? 'active ' : ''
    link_to link_text, link_path, class: class_name + link_class
  end

  def highlight_phrase str, phrase, tag_open = '<strong>', tag_close = '</strong>'
    phrase.strip!
    str.strip!
    return '' unless str.present?
    if phrase != ''
      return str.gsub(/([#{phrase}])/i, tag_open + '\1' + tag_close).html_safe
    end
    return str.html_safe
  end

  def paginate collection, params= {}
    will_paginate collection, params.merge(renderer: PaginateHelper::LinkRenderer)
  end
end
