class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update,:destroy] 
    before_action :require_user, except: [:index, :show]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    def show
        #byebug
        #@article = Article.find(params[:id])
    end

    def index
        #@articles =Article.all
        @articles = Article.paginate(page: params[:page], per_page: 2)
    end

    def new
        @article = Article.new
    end

    def edit
       # @article = Article.find(params[:id])
    end

    def create
        #render plain: params[:article]
        @article = Article.new(article_params)
        @article.user = current_user
        #render plain: @article.inspect
        if @article.save
            flash[:notice] ="Successfully Saved"
            redirect_to  article_path(@article)
        else
            render 'new' 
        end
    end 

    def update 
        #@article = Article.find(params[:id])
        if @article.update(article_params)
            flash[:notice] ="Successfully Updated"
            redirect_to  article_path(@article)
        else
            render 'edit' 
        end
    end

    def destroy
        #@article = Article.find(params[:id])
        @article.destroy
        redirect_to articles_path
    end

    private

    def set_article
        @article = Article.find(params[:id])
    end

    def article_params
        params.require(:article).permit(:title,:description, category_ids: [])
    end

    def require_same_user 
        if current_user!=@article.user && !current_user.admin?
            flash[:alert] = "you can only edit or delete your article"
            redirect_to @article
        end
    end
end
