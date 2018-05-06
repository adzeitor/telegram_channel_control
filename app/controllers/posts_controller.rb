class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    r = Telegram.send_photo(ENV["TELEGRAM_CHANNEL_ID"], @post.description, params[:post][:image].tempfile, {"parse_mode" => "Markdown"})
    if r["ok"] then
      @post.telegram_message_id = r["result"]["message_id"]
      result = @post.save
      errors = @post.errors
    else
      errors = r
    end

    respond_to do |format|
      if result
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    r = Telegram.edit_message_caption(ENV["TELEGRAM_CHANNEL_ID"], @post.telegram_message_id, @post.description, {"parse_mode" => "Markdown"})

    if r["ok"] then
      @post.telegram_message_id = r["result"]["message_id"]
      result = @post.update(post_params)
      errors = @post.errors
    else
      result = false
      errors = [r["description"]]
    end

    respond_to do |format|
      if result
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    r = Telegram.delete_message(ENV["TELEGRAM_CHANNEL_ID"], @post.telegram_message_id)

    if r["ok"] then
      result = @post.destroy
      errors = @post.errors
    else
      result = false
      errors = r["description"]
    end



    respond_to do |format|
      if result
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to posts_url, notice: errors }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :post_date)
    end
end
