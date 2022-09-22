module Posts
  class Delete
    def initialize(post_id)
      @post_id = post_id
    end

    def call
      post = Post.find(post_id)
      post.destroy
    end

    private

    attr_reader :post_id
  end
end
