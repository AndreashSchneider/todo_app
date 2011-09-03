require 'test_helper'

class VwVokabelnsControllerTest < ActionController::TestCase
  setup do
    @vw_vokabeln = vw_vokabelns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vw_vokabelns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vw_vokabeln" do
    assert_difference('VwVokabeln.count') do
      post :create, :vw_vokabeln => @vw_vokabeln.attributes
    end

    assert_redirected_to vw_vokabeln_path(assigns(:vw_vokabeln))
  end

  test "should show vw_vokabeln" do
    get :show, :id => @vw_vokabeln.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vw_vokabeln.to_param
    assert_response :success
  end

  test "should update vw_vokabeln" do
    put :update, :id => @vw_vokabeln.to_param, :vw_vokabeln => @vw_vokabeln.attributes
    assert_redirected_to vw_vokabeln_path(assigns(:vw_vokabeln))
  end

  test "should destroy vw_vokabeln" do
    assert_difference('VwVokabeln.count', -1) do
      delete :destroy, :id => @vw_vokabeln.to_param
    end

    assert_redirected_to vw_vokabelns_path
  end
end
