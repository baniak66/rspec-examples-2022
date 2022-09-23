module Posts
  class Create
    def initialize(params)
      @params = params
    end

    def call
      # sleep(10)
      Post.create(params)
    end

    private

    attr_reader :params
  end
end
