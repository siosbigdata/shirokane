require 'test_helper'

class Admin::GraphsControllerTest < ActionController::TestCase
  setup do
    @admin_graph = admin_graphs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_graphs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_graph" do
    assert_difference('Admin::Graph.count') do
      post :create, admin_graph: { name: @admin_graph.name, term: @admin_graph.term, title: @admin_graph.title, type: @admin_graph.type, x: @admin_graph.x, y: @admin_graph.y }
    end

    assert_redirected_to admin_graph_path(assigns(:admin_graph))
  end

  test "should show admin_graph" do
    get :show, id: @admin_graph
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_graph
    assert_response :success
  end

  test "should update admin_graph" do
    patch :update, id: @admin_graph, admin_graph: { name: @admin_graph.name, term: @admin_graph.term, title: @admin_graph.title, type: @admin_graph.type, x: @admin_graph.x, y: @admin_graph.y }
    assert_redirected_to admin_graph_path(assigns(:admin_graph))
  end

  test "should destroy admin_graph" do
    assert_difference('Admin::Graph.count', -1) do
      delete :destroy, id: @admin_graph
    end

    assert_redirected_to admin_graphs_path
  end
end
