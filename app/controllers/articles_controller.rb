class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    #render plain: params[:article].inspect
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "Article was created successfully"
      redirect_to article_path(@article)
    else
      render 'new' # or render :new
    end
  end

  def update 
    @article = Article.find(params[:id])
    if @article.update(article_params)
      flash[:success] = "Article was succesfully updated!"
      redirect_to article_path(@article)
    else
      render 'edit' # or render :edit
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def destroy
    set_article
    @article.destroy
    flash[:danger] = "Article was successfully deleteddddddddd"
    redirect_to articles_path
  end

  private 

    def set_article
      @article = Article.find(params[:id])
    end  

    def article_params
      params.require(:article).permit(:title, :description)
    end

    def require_same_user
      if current_user != @article.user && !current_user.admin?
        flash[:danger] = "You can't do that!"
        redirect_to root_path
      end
    end
end
