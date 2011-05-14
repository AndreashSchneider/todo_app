require 'test_helper'

class ProjekteControllerTest < ActionController::TestCase
  setup do
    @projekt = projekte(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projekte)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create projekt" do
    assert_difference('Projekt.count') do
      post :create, :projekt => @projekt.attributes
    end

    assert_redirected_to projekt_path(assigns(:projekt))
  end

  test "should show projekt" do
    get :show, :id => @projekt.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @projekt.to_param
    assert_response :success
  end

  test "should update projekt" do
    put :update, :id => @projekt.to_param, :projekt => @projekt.attributes
    assert_redirected_to projekt_path(assigns(:projekt))
  end

  test "should destroy projekt" do
    assert_difference('Projekt.count', -1) do
      delete :destroy, :id => @projekt.to_param
    end

    assert_redirected_to projekte_path
  end
end
