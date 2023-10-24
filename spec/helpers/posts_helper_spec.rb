# spec/helpers/posts_helper_spec.rb

require 'rails_helper'

RSpec.describe PostsHelper, type: :helper do
  describe "#user_like" do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }

    before do
      allow(helper).to receive(:current_user).and_return(user)
    end

    context "when user liked the post" do
      before do
        create(:like, user: user, post: post)
      end

      it "returns the like" do
        expect(helper.user_like(post)).to be_present
      end
    end

    context "when user didn't like the post" do
      it "returns nil" do
        expect(helper.user_like(post)).to be_nil
      end
    end
  end
end
