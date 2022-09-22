class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = ::Posts::Create.new(post_params).call

    if @post.valid?
      redirect_to post_url(@post), notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    @post = ::Posts::Update.new(params[:id], post_params).call

    if @post.errors.any?
      render :edit, status: :unprocessable_entity
    else
      redirect_to post_url(@post), notice: "Post was successfully updated."
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    ::Posts::Delete.new(params[:id]).call

    redirect_to posts_url, notice: "Post was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
