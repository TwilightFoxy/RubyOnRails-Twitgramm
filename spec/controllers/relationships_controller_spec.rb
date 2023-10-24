require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:relationship) { create(:relationship, follower: user, followed: other_user) }

  describe "POST #create" do
    context "when user is not authenticated" do
      it "should not allow create and redirects to login" do
        post :create, params: { followed_id: other_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "should allow user to follow another user" do
        expect {
          post :create, params: { followed_id: other_user.id }
        }.to change(Relationship, :count).by(1)
      end

      it "redirects to the followed user's profile" do
        post :create, params: { followed_id: other_user.id }
        expect(response).to redirect_to(user_profile_path(other_user))
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is not authenticated" do
      it "should not allow destroy and redirects to login" do
        delete :destroy, params: { id: relationship.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "should allow user to unfollow another user" do
        relationship # create the relationship
        expect {
          delete :destroy, params: { id: relationship.id }
        }.to change(Relationship, :count).by(-1)
      end

      it "redirects to the unfollowed user's profile" do
        delete :destroy, params: { id: relationship.id }
        expect(response).to redirect_to(user_profile_path(other_user))
      end

      context "when relationship doesn't exist" do
        it "redirects to root path with an alert" do
          delete :destroy, params: { id: "nonexistent" }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq "Отношение не найдено"
        end
      end
    end
  end
end
