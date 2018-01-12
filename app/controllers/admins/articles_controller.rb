class Admins::ArticlesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.all
  end

  def show
  end

  def new
    @article = Article.new
    @article.pics.build
  end

  def edit
    @article.pics.build if @article.pics.count == 0
  end

  def create
    @article = Article.new article_params
    if @article.save
      redirect_to admins_blog_articles_path, notice: 'Article is successfully created'
    else
      render :edit
    end
  end

  def update
    if @article.update article_params
      redirect_to admins_blog_articles_path, notice: 'Article is successfully updated'
    else
      render :edit
    end
  end

  def destroy
    if @article.destroy
      redirect_to admins_blog_articles_path, notice: 'Article is successfully deleded'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  private
    def set_article
      @article = Article.find params[:id]
    end

    def article_params
      params.require(:article).permit(:title, :pic, :text_short, :text,
                                      :parent, :date, :priv, :anchor,
                                      :bootsy_image_gallery_id,
                                      pics_attributes: [:id, :text, :priv, :path, :_destroy])
    end
end
