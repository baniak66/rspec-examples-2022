require "rails_helper"

RSpec.describe Posts::Create do
  let(:params) do
    {
      title: title,
      content: "content",
      image: file,
    }
  end
  let(:expected_attributes) do
    {
      title: title,
      content: "content",
    }
  end
  let(:title) { "title" }
  let(:file) { fixture_file_upload("img1.jpeg", "image/jpeg") }
  let(:instance) { described_class.new(params) }

  subject { instance.call }

  describe ".call" do
    it "creates new post" do
      expect { subject }.to change { Post.count }.by(1)
    end

    it "creates new post" do
      expect { subject }.to change { Post.count }.from(0).to(1)
    end

    it "returns post object" do
      expect(subject).to be_a_kind_of(Post)
    end

    it "returns post object with proper attributes" do
      expect(subject).to have_attributes(expected_attributes)
    end

    it "returns post object with proper attributes" do
      subject
      expect(Post.last.image.metadata["filename"]).to eq("img1.jpeg")
    end

    it "returns object without errors" do
      expect(subject.errors).to match_array([])
    end

    context "when params invalid" do
      let(:title) { nil }

      it "returns object with errors" do
        expect(subject.errors).to match_array(["Title can't be blank"])
      end
    end
  end
end
