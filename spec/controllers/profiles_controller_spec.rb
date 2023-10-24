require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET #show' do
    context 'when id is not provided' do
      before do
        sign_in user
        get :show
      end

      it 'assigns the current user to @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when id is provided' do
      before do
        sign_in user
        get :show, params: { id: other_user.id }
      end

      it 'assigns the specified user to @user' do
        expect(assigns(:user)).to eq(other_user)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #edit' do
    before do
      sign_in user
      get :edit
    end

    it 'assigns the current user to @user' do
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    context "with invalid attributes" do
      let(:invalid_attributes) { { description: "" } }

      before do
        sign_in user
        put :update, params: { id: user.id, user: invalid_attributes }
      end

      it "does not update the user attributes" do
        user.reload
        expect(user.description).to eq("")
      end

      it "redirects to the profile path" do
        expect(response).to redirect_to(profile_path)
      end

    end
  end


  describe "GET #index" do
    before { sign_in create(:user) }

    context "with search parameter" do
      let!(:user1) { create(:user, username: "user1", email: "user1@example.com") }
      let!(:user2) { create(:user, username: "user2", email: "user2@example.com") }

      it "filters users based on the search" do
        get :index, params: { search: "user1" }
        expect(assigns(:users)).to eq([user1])
      end
    end

    context "without search parameter" do
      it "assigns all users to @users" do
        get :index
        expect(assigns(:users)).to eq(User.all)
      end
    end
  end
  describe "GET #friends" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "with search parameter" do
      let(:friend1) { create(:user, username: "friend1", email: "friend1@example.com") }
      let(:friend2) { create(:user, username: "friend2", email: "friend2@example.com") }

      before do
        user.follow(friend1)
        user.follow(friend2)
      end

      it "filters friends based on the search" do
        get :friends, params: { search: "friend1" }
        expect(assigns(:friends)).to eq([friend1])
      end
    end

    context "without search parameter" do
      it "assigns all friends to @friends" do
        get :friends
        expect(assigns(:friends)).to eq(user.following)
      end
    end
  end
end
