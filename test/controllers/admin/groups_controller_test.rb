require 'test_helper'

class Admin::GroupsControllerTest < ActionController::TestCase
  setup do
    @admin_group = admin_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_group" do
    assert_difference('Admin::Group.count') do
      post :create, admin_group: { name: @admin_group.name, title: @admin_group.title }
    end

    assert_redirected_to admin_group_path(assigns(:admin_group))
  end

  test "should show admin_group" do
    get :show, id: @admin_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_group
    assert_response :success
  end

  test "should update admin_group" do
    patch :update, id: @admin_group, admin_group: { name: @admin_group.name, title: @admin_group.title }
    assert_redirected_to admin_group_path(assigns(:admin_group))
  end

  test "should destroy admin_group" do
    assert_difference('Admin::Group.count', -1) do
      delete :destroy, id: @admin_group
    end

    assert_redirected_to admin_groups_path
  end
end
