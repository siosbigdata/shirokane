# -*- coding: utf-8 -*-
require "spec_helper"

describe Admin::User do
  let(:build) { Admin::User.new(user_params) }
  let(:user_params) do
    {
      "name"     => "dumy",
      "password" => "dumy",
      "password_confirmation" => "dumy",
      "title"    => "title",
      "mail"     => "dumy@dumy.com",
      "group_id" => 1,
      "admin"    => true,
    }
  end

  describe "validation" do
    shared_examples_for "invalid_collection" do |column|
      before(:each) { user_params[column] = "" }
      it "保存に失敗する" do
        expect(build).not_to be_valid
      end
      it "#{column}のエラーメッセージを取得する" do
        expect(build).to have(1).errors_on(column)
      end
    end

    context "パラメータにnameが存在しない場合" do
      it_behaves_like "invalid_collection", :name
    end

    context "パラメータにnameが既に存在する場合" do
      before(:each) do
        user_params["name"] = "dumy tarou"
        FactoryGirl.create(:admin_user)
      end
      it "保存に失敗する" do
        expect(build).not_to be_valid
      end
      it "nameのエラーメッセージを取得する" do
        expect(build).to have(1).errors_on(:name)
      end
    end

    context "パラメータにpasswordが存在しない場合" do
      it_behaves_like "invalid_collection", :password
    end

    context "パラメータにtitleが存在しない場合" do
      it_behaves_like "invalid_collection", :title
    end

    context "パラメータにpassword_confirmationが存在しない場合" do
      it "保存に失敗する" do
        user_params["password_confirmation"] = ""
        expect(build).not_to be_valid
      end
    end

    context "パラメータにmailが存在しない場合" do
      it "保存に失敗する" do
        user_params["mail"] = ""
        expect(build).not_to be_valid
      end
    end

    context "パラメータmailがメール形式でない場合" do
      before(:each) { user_params["mail"] = "dumy" }
      it "保存に失敗する" do
        expect(build).not_to be_valid
      end
      it "mailのエラーメッセージを取得する" do
        expect(build).to have(1).errors_on(:mail)
      end
    end

    context "パラメータが全て存在する場合" do
      it "保存に成功する" do
        expect(build).to be_valid
      end
    end
  end

  describe "save" do
    context "有効なパラメータの場合" do
      it "保存に成功する" do
        expect(build.save).to be_true
      end
      it "User数が１つ増える" do
        expect{build.save}.to change{ User.count }.from(0).to(1)
      end
    end

    context "無効なパラメータの場合" do
      before(:each) { user_params["mail"] = "" }
      it "保存に失敗する" do
        expect(build.save).to be_false
      end
      it "User数が変わらない" do
        expect{build.save}.to change{ User.count }.by(0)
      end
    end
  end
end
