require 'test_helper'

class RegurlsControllerTest < ActionController::TestCase
  setup do
    @regurl = regurls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:regurls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create regurl" do
    assert_difference('Regurl.count') do
      post :create, regurl: { examURL: @regurl.examURL, extract: @regurl.extract, fin: @regurl.fin, pattern: @regurl.pattern }
    end

    assert_redirected_to regurl_path(assigns(:regurl))
  end

  test "should show regurl" do
    get :show, id: @regurl
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @regurl
    assert_response :success
  end

  test "should update regurl" do
    patch :update, id: @regurl, regurl: { examURL: @regurl.examURL, extract: @regurl.extract, fin: @regurl.fin, pattern: @regurl.pattern }
    assert_redirected_to regurl_path(assigns(:regurl))
  end

  test "should destroy regurl" do
    assert_difference('Regurl.count', -1) do
      delete :destroy, id: @regurl
    end

    assert_redirected_to regurls_path
  end
end
