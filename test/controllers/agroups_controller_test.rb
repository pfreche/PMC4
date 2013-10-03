require 'test_helper'

class AgroupsControllerTest < ActionController::TestCase
  setup do
    @agroup = agroups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agroup" do
    assert_difference('Agroup.count') do
      post :create, agroup: { name: @agroup.name }
    end

    assert_redirected_to agroup_path(assigns(:agroup))
  end

  test "should show agroup" do
    get :show, id: @agroup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @agroup
    assert_response :success
  end

  test "should update agroup" do
    patch :update, id: @agroup, agroup: { name: @agroup.name }
    assert_redirected_to agroup_path(assigns(:agroup))
  end

  test "should destroy agroup" do
    assert_difference('Agroup.count', -1) do
      delete :destroy, id: @agroup
    end

    assert_redirected_to agroups_path
  end
end
