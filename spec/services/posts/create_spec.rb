require "rails_helper"

RSpec.describe ::Posts::Create do
  let(:params) do
    {
      title: title,
      content: "Content"
    }
  end
  let(:title) { "Title" }
  let(:instance) { ::Posts::Create.new(params) }

  describe ".call" do
    it "creates post" do
      expect { instance.call }.to change { Post.count }.by(1)
    end

    it "creates post" do
      expect { instance.call }.to change { Post.count }.from(0).to(1)
    end

    it "returns post object" do
      expect(instance.call).to be_a_kind_of(Post)
    end

    it "returns post with proper attirbutes" do
      expect(instance.call).to have_attributes(params)
    end

    it "returns post without errors" do
      expect(instance.call.errors).to match_array([])
    end

    context "when params invalid" do
      let(:title) { nil }

      it "returns post errors" do
        expect(instance.call.errors).to match_array(["Title can't be blank"])
      end
    end
  end
end
