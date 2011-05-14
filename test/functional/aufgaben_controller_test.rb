require 'test_helper'

class AufgabenControllerTest < ActionController::TestCase
  setup do
    @aufgabe = aufgaben(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aufgaben)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aufgabe" do
    assert_difference('Aufgabe.count') do
      post :create, :aufgabe => @aufgabe.attributes
    end

    assert_redirected_to aufgabe_path(assigns(:aufgabe))
  end

  test "should show aufgabe" do
    get :show, :id => @aufgabe.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @aufgabe.to_param
    assert_response :success
  end

  test "should update aufgabe" do
    put :update, :id => @aufgabe.to_param, :aufgabe => @aufgabe.attributes
    assert_redirected_to aufgabe_path(assigns(:aufgabe))
  end

  test "should destroy aufgabe" do
    assert_difference('Aufgabe.count', -1) do
      delete :destroy, :id => @aufgabe.to_param
    end

    assert_redirected_to aufgaben_path
  end
end
