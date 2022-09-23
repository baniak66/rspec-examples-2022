require 'rails_helper'

RSpec.describe "/posts", type: :request do
  describe "GET /posts" do
    subject(:request) { get posts_url }

    before { request }

    it "returns successful response" do
      expect(response).to be_successful
    end

    it "returns successful response" do
      expect(response.status).to eq(200)
    end

    it "renders proper template" do
      expect(response).to render_template("posts/index")
    end
  end

  describe "GET /posts/post_id" do
    let(:post) { create :post }

    it "returns successful response" do
      get("/posts/#{post.id}")
      expect(response.status).to eq(200)
    end
  end

  describe "GET /posts/new" do
    it "returns successful response" do
      get("/posts/new")
      expect(response.status).to eq(200)
    end

    it "renders proper template" do
      get("/posts/new")
      expect(response).to render_template("posts/new")
    end
  end

  describe "POST /posts" do
    let(:params) do
      {
        post: {
          title: title,
          content: "content"
        }
      }
    end
    let(:title) { "title" }

    it "returns successful response" do
      post("/posts", params: params)
      expect(response.status).to eq(302)
    end

    it "creates post record" do
      expect { post("/posts", params: params) }.to change(Post, :count).by(1)
    end

    context "when params invalid" do
      let(:title) { nil }

      it "creates post record" do
        expect { post("/posts", params: params) }.not_to change(Post, :count)
      end

      it "returns successful response" do
        post("/posts", params: params)
        expect(response.status).to eq(422)
      end
    end

    context "when we use double" do
      let(:created_post) { create :post }
      let(:post_create_double) do
        instance_double("::Posts::Create", call: created_post)
      end
      # let(:controller_params) do
      #   ActionController::Parameters.new("title"=>"title", "content"=>"content").permit!
      # end
      let(:controller_params) do
        {
          title: "title",
          content: "content"
        }
      end

      before do
        allow(::Posts::Create)
          .to receive(:new)
          .with(controller_params)
          .and_return(post_create_double)
      end

      it "returns successful response" do
        post("/posts", params: params)
        expect(response.status).to eq(302)
      end

      it "calls Posts::Create service" do
        post("/posts", params: params)
        expect(post_create_double).to have_received(:call)
      end
    end
  end
end
