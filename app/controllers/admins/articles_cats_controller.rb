class Admins::ArticlesCatsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_article_category, only: [:show, :edit, :update, :destroy]

  def index
    @article_categories = ArticlesCat.all
  end

  def show
  end

  def new
    @article_category = ArticlesCat.new
  end

  def edit
  end

  def create
    @article_category = ArticlesCat.new article_params
    if @article_category.save
      redirect_to admins_blog_articles_cats_path, notice: 'Article is successfully created'
    else
      render :new
    end
  end

  def update
    if @article_category.update article_params
      redirect_to admins_blog_articles_cats_path, notice: 'Article is successfully updated'
    else
      render :edit
    end
  end

  def destroy
    if @article_category.destroy
      redirect_to admins_blog_articles_cats_path, notice: 'Article is successfully deleded'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  private
    def set_article_category
      @article_category = ArticlesCat.find params[:id]
    end

    def article_params
      params.require(:articles_cat).permit(:title, :pic, :text, :priv, :anchor)
    end
end
