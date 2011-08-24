require 'test_helper'

class KarteiControllerTest < ActionController::TestCase
  setup do
    @karte = kartei(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kartei)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create karte" do
    assert_difference('Karte.count') do
      post :create, :karte => @karte.attributes
    end

    assert_redirected_to karte_path(assigns(:karte))
  end

  test "should show karte" do
    get :show, :id => @karte.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @karte.to_param
    assert_response :success
  end

  test "should update karte" do
    put :update, :id => @karte.to_param, :karte => @karte.attributes
    assert_redirected_to karte_path(assigns(:karte))
  end

  test "should destroy karte" do
    assert_difference('Karte.count', -1) do
      delete :destroy, :id => @karte.to_param
    end

    assert_redirected_to kartei_path
  end
end
