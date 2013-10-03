require 'test_helper'

class MfilesControllerTest < ActionController::TestCase
  setup do
    @mfile = mfiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mfiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mfile" do
    assert_difference('Mfile.count') do
      post :create, mfile: { filename: @mfile.filename, folder_id: @mfile.folder_id, mod_date: @mfile.mod_date, modified: @mfile.modified }
    end

    assert_redirected_to mfile_path(assigns(:mfile))
  end

  test "should show mfile" do
    get :show, id: @mfile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mfile
    assert_response :success
  end

  test "should update mfile" do
    patch :update, id: @mfile, mfile: { filename: @mfile.filename, folder_id: @mfile.folder_id, mod_date: @mfile.mod_date, modified: @mfile.modified }
    assert_redirected_to mfile_path(assigns(:mfile))
  end

  test "should destroy mfile" do
    assert_difference('Mfile.count', -1) do
      delete :destroy, id: @mfile
    end

    assert_redirected_to mfiles_path
  end
end
