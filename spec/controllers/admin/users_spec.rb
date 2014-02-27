# -*- coding: utf-8 -*-
require "spec_helper"

describe Admin::UsersController do
  describe "GET index" do
    #ログインユーザの作成&ログイン
    set_setting
    login_admin_user
    context '登録されているユーザ(全admin)が50件の場合' do
      before(:each) do
        49.times { FactoryGirl.create(:admin_users) }
        get :index
      end

      it 'indexテンプレートが呼ばれる' do
        expect(response).to render_template(:index)
      end

      it '50件のユーザーオブジェクトを取得する' do
        expect(assigns(:admin_users).length).to eq(50)
      end
    end

    context '登録されているユーザ(一般49/admin1)50件の場合' do
      before(:each) do
        49.times { FactoryGirl.create(:users) }
        get :index
      end

      it 'indexテンプレートが呼ばれる' do
        expect(response).to render_template(:index)
      end

      it '総ユーザー数が50件ある' do
        expect(assigns(:admin_users).length).to eq(50)
      end

      it 'maxuserインスタンス変数と設定情報のmaxuser数が等しい' do
        expect(assigns(:maxuser)).to eq($settings['maxuser'].to_i)
      end
    end
  end

  describe "POST create" do
    set_setting
    login_admin_user
    shared_examples_for "invalid_collection" do
      let(:invalid_user_obj) do
        User.new(user_params["admin_user"])
      end

      before(:each) do
        post :create, user_params
      end

      it "保存に失敗する" do
        invalid_user_obj.should_not be_valid
      end

      pending('HTTPレスポンスが 400系を返す')

      it "保存に失敗し、newテンプレートが呼ばれる" do
        expect(response).to render_template('new')
      end
    end

    context 'パラメータのnameが存在しない場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "name"     => "",
            "password" => "dumy",
            "title"    => "title",
            "mail"     => "dumy@dumy.com",
            "group_id" => 1,
            "admin"    => true,
          }
        }
      end

      it_behaves_like "invalid_collection"
    end

    context 'パラメータのpasswordが存在しない場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "name"     => "name",
            "password" => "",
            "title"    => "title",
            "mail"     => "dumy@dumy.com",
            "group_id" => 1,
            "admin"    => true,
          }
        }
      end

      it_behaves_like "invalid_collection"
    end

    context 'パラメータのtitleが存在しない場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "name"     => "name",
            "password" => "password",
            "title"    => "",
            "mail"     => "dumy@dumy.com",
            "group_id" => 1,
            "admin"    => true,
          }
        }
      end

      it_behaves_like "invalid_collection"
    end

    context 'パラメータのmailが存在しない場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "name"     => "name",
            "password" => "password",
            "title"    => "title",
            "mail"     => "",
            "group_id" => 1,
            "admin"    => true,
          }
        }
      end

      it_behaves_like "invalid_collection"
    end

    context 'パラメータ全て存在する場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "name"     => "name",
            "password" => "password",
            "password_confirmation" => "password",
            "title"    => "title",
            "mail"     => "dumydumy@dumy.com",
            "group_id" => 1,
            "admin"    => true,
          }
        }
      end

      before(:each) do
        post :create, user_params
      end

      let(:user_obj) do
        User.new(user_params["admin_user"])
      end

      it "保存に成功する" do
        expect(response).to be_true
      end

      it "保存に成功し、showへレンダーする" do
        expect(response).to redirect_to(admin_user_url(assigns[:admin_user]))
      end
    end
  end

  describe "PATCH update" do
    set_setting
    login_admin_user
    shared_examples_for "invalid_update_collection" do
      let(:user_obj) do
        user = FactoryGirl.create(:users)
        Admin::User.find(user.id)
      end

      it "保存に失敗する" do
        user_obj.update(user_params["admin_user"]).should be_false
      end

      pending('HTTPレスポンスが 400系を返す')

      it "保存に失敗し、editテンプレートが呼ばれる" do
        patch :update, user_params
        should render_template('edit')
      end
    end

    context 'パラメータのnameが存在しない場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "name"     => "",
          },
          "id" => user_obj.id,
        }
      end

      it_behaves_like "invalid_update_collection"
    end

    context 'パラメータのtitleが存在しない場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "title"    => "",
          },
          "id" => user_obj.id,
        }
      end

      it_behaves_like "invalid_update_collection"
    end

    context 'パラメータのmailが存在しない場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "mail"     => "",
          },
          "id" => user_obj.id,
        }
      end

      it_behaves_like "invalid_update_collection"
    end

    context 'パラメータのmailが既に存在する場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "mail"     => "dumy_administrator@dumy.com",
          },
          "id" => user_obj.id,
        }
      end

      it_behaves_like "invalid_update_collection"
    end

    context 'パラメータのnameが既に存在する場合' do
      let(:user_params) do
        {
          "admin_user" => {
            "name" => "dumy administrator tarou",
          },
          "id" => user_obj.id,
        }
      end

      it_behaves_like "invalid_update_collection"
    end

    context '重複の無いパラメータの場合' do
      let(:user_obj) do
        user = FactoryGirl.create(:users)
        Admin::User.find(user.id)
      end

      let(:user_params) do
        {
          "admin_user" => {
            "name"     => "test_dumy",
            "password" => "test_dumy",
            "password_confirmation" => "test_dumy",
            "title"    => "test_dumy",
            "mail"     => "test_dumy@dumy.com",
            "group_id" => 2,
            "admin"    => true,
          },
          "id" => user_obj.id,
        }
      end

      before(:each) { patch :update, user_params }

      it "保存に成功する" do
        should be_true
      end

      it "保存に成功し、showへレンダーする" do
        expect(response).to redirect_to(admin_user_url(assigns[:admin_user]))
      end
    end
  end

  describe 'DELETE destroy' do
    set_setting
    login_admin_user
    let(:user_obj) do
      user = FactoryGirl.create(:users)
      Admin::User.find(user.id)
    end
    let(:user_params)  { { "id" => user_obj.id } }
    let(:request) { delete :destroy, user_params }

    it 'ユーザーindexへリダイレクトする' do
      request
      response.should redirect_to(admin_users_url)
    end

    it '削除するユーザが選択したものと一致する' do
      request
      assigns(:admin_user).should eq(user_obj)
    end

    it '総ユーザ数が1件から0件になる' do
      expect{ request }.to change(User, :count).by(0)
    end
  end
end
