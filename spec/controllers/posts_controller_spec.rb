require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:post_instance) { FactoryBot.create(:post, user: user) }
  let(:valid_attributes) {
    {
      description: 'Sample post description',
      image: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'sample.png'), 'image/png')
    }
  }
  let(:invalid_attributes) { { description: '', image: nil } }

  describe 'GET #index' do
    context 'when user is logged in' do
      before { sign_in user }

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # describe 'GET #feed' do
  #   context 'when user is not logged in' do
  #     it 'redirects to login page' do
  #       get :feed
  #       expect(response).to redirect_to(new_user_session_path)
  #     end
  #   end
  # end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { sign_in user }

      it 'creates a new post' do
        expect {
          post :create, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it 'redirects to the root path' do
        post :create, params: { post: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it 'displays a success message' do
        post :create, params: { post: valid_attributes }
        expect(flash[:notice]).to eq('Пост успешно создан.')
      end
    end
  end


  describe 'POST #create' do
    context 'when user is logged in' do
      before { sign_in user }

      context 'with valid attributes' do
        it 'creates a new post' do
          expect {
            post :create, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it 'redirects to the new post' do
          post :create, params: { post: valid_attributes }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        post :create, params: { post: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:post_to_delete) { FactoryBot.create(:post, user: user) }

    context 'when user is logged in and is the post author' do
      before { sign_in user }

      it 'deletes the post' do
        expect {
          delete :destroy, params: { id: post_to_delete.id }
        }.to change(Post, :count).by(-1)
      end

      it 'redirects to the root path with a notice' do
        delete :destroy, params: { id: post_to_delete.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Пост успешно удален.')
      end
    end

    context 'when user is logged in and is not the post author' do
      before { sign_in other_user }

      it 'does not delete the post' do
        expect {
          delete :destroy, params: { id: post_to_delete.id }
        }.not_to change(Post, :count)
      end

      it 'redirects to the root path with an alert' do
        delete :destroy, params: { id: post_to_delete.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Ошибка удаления.')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        delete :destroy, params: { id: post_to_delete.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'PUT #update' do
    let!(:post) { create(:post) } # предполагая, что у вас есть фабрика для Post
    let(:valid_attributes) { { description: 'Updated description' } }
    let(:invalid_attributes) { { description: '' } } # или любые другие недействительные данные

    before { sign_in user } # предполагая, что у вас есть Devise или аналогичная система аутентификации

    context 'with valid attributes' do
      it 'updates the post' do
        put :update, params: { id: post.id, post: valid_attributes }
        post.reload
        expect(post.description).to eq('Updated description')
      end

      it 'redirects to the posts index' do
        put :update, params: { id: post.id, post: valid_attributes }
        expect(response).to redirect_to(posts_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the post' do
        put :update, params: { id: post.id, post: invalid_attributes }
        post.reload
        expect(post.description).to eq('')
      end
    end
  end
  describe '#feed' do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }
    let(:unfollowed_user) { create(:user) }

    before do
      # Создаем посты для каждого пользователя
      create(:post, user: user)
      create(:post, user: followed_user)
      create(:post, user: unfollowed_user)

      # Пользователь подписывается на followed_user
      user.follow(followed_user)
    end

    it 'includes the posts from the user' do
      expect(user.feed).to include(user.posts.first)
    end

    it 'includes the posts from followed users' do
      expect(user.feed).to include(followed_user.posts.first)
    end

    it 'does not include the posts from unfollowed users' do
      expect(user.feed).not_to include(unfollowed_user.posts.first)
    end
  end
  describe 'User model' do
    let!(:user) { create(:user) }  # предполагается, что у вас есть фабрика для создания пользователей
    let!(:other_user1) { create(:user) }
    let!(:other_user2) { create(:user) }

    before do
      # Пусть user подписывается на other_user1, но не на other_user2
      user.follow(other_user1)
    end

    describe '#feed' do
      it 'includes posts from followed users' do
        post_from_other_user1 = other_user1.posts.create!(description: "Post from followed user")
        expect(user.feed).to include(post_from_other_user1)
      end

      it 'does not include posts from non-followed users' do
        post_from_other_user2 = other_user2.posts.create!(description: "Post from non-followed user")
        expect(user.feed).not_to include(post_from_other_user2)
      end

      it 'includes own posts' do
        own_post = user.posts.create!(description: "Own post")
        expect(user.feed).to include(own_post)
      end
    end
  end

end
