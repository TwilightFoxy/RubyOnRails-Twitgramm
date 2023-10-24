require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:created_post) { FactoryBot.create(:post, user: user) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "when user has not liked the post" do
      it 'creates a new like' do
        expect {
          post :create, params: { post_id: created_post.id }
        }.to change(Like, :count).by(1)
      end

      it 'redirects to the root path with an anchor' do
        post :create, params: { post_id: created_post.id }
        expect(response).to redirect_to(root_path(anchor: "anchor-post-#{created_post.id}"))
      end
    end

    context "when user has already liked the post" do
      before do
        FactoryBot.create(:like, user: user, post: created_post)
      end

      it "does not create a new like" do
        expect {
          post :create, params: { post_id: created_post.id }
        }.not_to change(Like, :count)
      end

      it "redirects to the root path with an alert" do
        post :create, params: { post_id: created_post.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Вы уже ставили лайк этому посту.')
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user has liked the post" do
      let!(:like) { FactoryBot.create(:like, user: user, post: created_post) }

      it "deletes the like" do
        expect {
          delete :destroy, params: { id: like.id }
        }.to change(Like, :count).by(-1)
      end

      it "redirects to the root path with an anchor" do
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to(root_path(anchor: "anchor-post-#{created_post.id}"))
      end
    end

    context "when user has not liked the post" do
      let!(:other_like) { FactoryBot.create(:like, user: other_user, post: created_post) }

      it "does not delete any likes" do
        expect {
          delete :destroy, params: { id: other_like.id }
        }.not_to change(Like, :count)
      end

      it "redirects to the root path with an alert" do
        delete :destroy, params: { id: other_like.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Ошибка удаления лайка.')
      end
    end
  end
end
