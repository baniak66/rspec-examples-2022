require 'rails_helper'

RSpec.describe "/posts", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get posts_url
      expect(response).to be_successful
    end

    it "renderes proder template" do
      expect(get posts_url).to render_template("posts/index")
    end
  end

  describe "GET /posts/:id" do
    let(:post) { create :post }

    it "returns success status" do
      get("/posts/#{post.id}")
      # get post_url(post)
      expect(response.status).to eq(200)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get("/posts/new")
      # get new_post_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    let(:post) { create :post }

    it "renders a successful response" do
      get edit_post_url(post)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    let(:params) do
      {
        post: {
          title: title,
          content: "body"
        }
      }
    end
    let(:title) { "title" }

    subject(:create_post) { post("/posts", params: params) }

    context "with valid parameters" do
      it "creates a new Post" do
        expect { create_post }.to change(Post, :count).by(1)
      end

      it "redirects to the created post" do
        create_post
        expect(response).to redirect_to(post_url(Post.last))
      end
    end

    context "with invalid parameters" do
      let(:title) { "" }

      it "does not create a new Post" do
        expect { create_post }.to change(Post, :count).by(0)
      end

      it "returns unprocessable_entity response" do
        create_post
        expect(response.status).to eq(422)
      end
    end

    # Example with mocked service
    context "when double used" do
      let(:created_post) { create :post }
      let(:post_create_double) { instance_double("::Posts::Create", call: created_post)}
      let(:post_params) do
        ActionController::Parameters.new(title: params[:post][:title], content: params[:post][:content]).permit!
      end
      # let(:post_params) { params[:post] }

      before do
        allow(::Posts::Create).to receive(:new).with(post_params).and_return(post_create_double)
      end

      it "redirects to the created post" do
        create_post
        expect(response).to redirect_to(post_url(created_post))
      end

      it "calls proper post service" do
        create_post
        expect(post_create_double).to have_received(:call)
      end
    end
  end

  describe "PATCH /update" do
    let(:post) { create :post, title: "title", content: "content" }
    let(:params) do
      {
        id: post.id,
        post: {
          title: title,
          content: "content updated"
        }
      }
    end
    let(:title) { "title updated" }

    subject { put("/posts/#{post.id}", params: params) }

    context "with valid parameters" do
      it "retuns success status" do
        subject
        expect(response.status).to eq(302)
      end

      it "updates post params" do
        expect { subject }
          .to change { post.reload.title }.from("title").to("title updated")
          .and change { post.reload.content }.from("content").to("content updated")
      end
    end

    context "with invalid parameters" do
      let(:title) { nil }
      let(:expected_response) { { "title"=>["can't be blank"] } }

      it "retuns unprocess entity status" do
        subject
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:post) { create :post }

    subject { delete("/posts/#{post.id}") }

    it "destroys the requested post" do
      expect { subject }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      subject
      expect(response).to redirect_to(posts_url)
    end
  end
end
