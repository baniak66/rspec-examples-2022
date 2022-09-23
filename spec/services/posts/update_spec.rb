require "rails_helper"

RSpec.describe ::Posts::Update do
  describe ".call" do
    let(:post) { create :post, title: "title" }
    let(:params) do
      {
        title: title,
        content: "content updated"
      }
    end
    let(:title) { "title updated" }

    subject(:update_post) { described_class.new(post.id, params).call }

    it "updates post attributes" do
      expect { update_post }.to change { post.reload.title }.from("title").to("title updated")
        .and change { post.reload.content }.from("My content").to("content updated")
    end

    it "retuns post object" do
      expect(update_post).to eq(post)
    end

    it "returns post object without errors" do
      expect(update_post.errors).to be_empty
    end

    context "when params invalid" do
      let(:title) { nil }

      it "doesn't update post attributes" do
        expect { update_post }.not_to change { post.reload.title }
      end

      it "returns post object with errors" do
        expect(update_post.errors).not_to be_empty
      end

      it "returns post object with proper errors" do
        expect(update_post.errors).to match_array(["Title can't be blank"])
      end
    end
  end
end
