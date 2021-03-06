class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :edit, :update, :destroy, :publish]
  load_and_authorize_resource

  def index
    @articles = Article.published.paginate(page: params[:page])
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = 'Article a created'
      redirect_to @article
    else
      flash[:warning] = 'Article did not create'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @article.update_attributes(article_params)
      flash[:success] = "Article's atributes are updated"
      redirect_to @article
    else
      flash.now[:warning] = "Article's atributes are not correct"
      render 'edit'
    end
  end

  def destroy
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :body, :picture, :category_id)
  end

  def find_article
    @article = Article.find_by_id(params[:id])
  end
end
