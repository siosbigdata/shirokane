# -*- coding: utf-8 -*-
require "spec_helper"

describe Admin::LoginController do
  describe "GET index" do
    context 'ログイン画面にアクセスした場合' do
      before(:each) do
        get :index
      end
      it 'HTTPレスポンスが 200を返す' do
        expect(response).to be_success
      end
      it 'index のテンプレートが呼ばれる' do
        expect(response).to render_template('index')
      end
    end
  end

  describe "POST create" do
    set_setting
    context "ログインユーザーが管理者の場合" do
      before(:each)  do
        FactoryGirl.create(:admin_user)
      end

      context "存在するユーザーID/パスワードを入力しログインした場合" do
        it "ログインに成功する" do
          post :create, :mail => "dumy_admin@dumy.com", :pass => "dumydumydumy"
          expect(response).to redirect_to( admin_root_path )
        end
      end

      context "存在しないユーザーIDを入力した場合" do
        before(:each) do
          post :create, :mail => "invalid_dumy@dumy.com", :pass => "dumydumydumy"
        end
        it "ログインに失敗する" do
          expect(response).not_to redirect_to( root_path )
        end
        pending('HTTPレスポンスが 400系を返す')
      end

      context "存在するユーザーID/不一致なパスワードを入力した場合" do
        before(:each) do
          post :create, :mail => "dumy@dumy.com", :pass => "invalid_password"
        end
        it "ログインに失敗する" do
          expect(response).not_to redirect_to( root_path )
        end
        pending('HTTPレスポンスが 400系を返す')
      end
    end
    context "ログインユーザーが管理者でない場合" do
      before(:each)  do
        FactoryGirl.create(:user)
        post :create, :mail => "dumy@dumy.com", :pass => "dumydumydumy"
      end

      it 'ログインに失敗する' do
        expect(response).not_to redirect_to( root_path )
      end
    end
  end

  describe "Delete destroy" do
    set_setting
    before(:each)  do
      user = FactoryGirl.create(:admin_user)
      post :create, :mail => "dumy@dumy.com", :pass => "invalid_password"
      delete :destroy, :id => user.id
    end

    context "ログアウトした場合" do
      it "indexテンプレートが呼ばれる" do
        expect(response).to render_template(:index)
      end
      it "session IDが破棄される" do
        expect(session[:user_id]).to be_nil
      end
      it "session servisenameが破棄される" do
        expect(session[:servisename]).to be_nil
      end
    end
  end
end
