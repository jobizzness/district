class BlogsController < ApplicationController
  def index
    @cats = ArticlesCat.all
  end

  def section
    @category = ArticlesCat.find_by(anchor: params[:section])
    @articles = @category.articles
    @leaders_facebook = @articles.order(fb_reposts: :desc).limit(1).first
    @leaders_twitter = @articles.where.not(id: @leaders_facebook.id).order(tw_reposts: :desc).limit(1).first
    @count = @articles.count
    @order = 'date'
  end

  def article
    @article = Article.find_by(anchor: params[:article])
    @related_companies = @article.companies.limit(2)
    @related_articles = @article.articles.limit(4)
  end

  def tag
    tag = Tag.find_by(name: URI.decode(params[:tag]))
    @articles = tag.present? ? tag.articles : []
    @count = @articles.count
  end

  def share
    article_id, social = share_params[:article], share_params[:social]

    if cookies[social].present?
      ids = JSON.parse(cookies[social])
      ids.each do |id|
        if id == article_id
          return render nothing: true, status: :ok
        end
      end
    end

    article = Article.find(article_id)
    column = social + '_reposts'
    rating = (article.fb_reposts + article.tw_reposts + article.in_reposts + article.gp_reposts) / (DateTime.now.utc - article.date.to_datetime).to_f + 1
    article.update(rating: rating)
    article.increment(column)

    if article.save
      cookies.delete(social)
      value = []
      value << ids if ids.present?
      value << article_id

      cookies[social] = { value: JSON.generate(value), expires: 3.month.from_now }

      return render nothing: true, status: :ok
    else
      return render nothing: true, status: :bad
    end
  end

  private
    def share_params
      params.permit(:article, :social)
    end
end
