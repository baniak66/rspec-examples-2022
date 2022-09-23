require "rails_helper"

RSpec.describe ::Posts::Delete do
  describe ".call" do
    let(:post) { create :post }

    subject(:delete_post) { described_class.new(post.id).call }

    before { post }

    it "deletes post" do
      expect { delete_post }.to change(Post, :count).by(-1)
    end
  end
end
